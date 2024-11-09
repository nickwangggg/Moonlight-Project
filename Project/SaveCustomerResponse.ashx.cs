using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Net;
using System.Web;

namespace Project
{
    public class SaveCustomerResponse : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.AddHeader("Access-Control-Allow-Origin", "*"); // 跨域請求允許

            string name_R = "", phoneNumber_R = "", email_R = "", message_R = "", roomtype = null;
            int percent_positive = 0;
            Dictionary<string, string> ratings = new Dictionary<string, string>();

            try
            {
                // 讀取 JSON 資料
                using (var reader = new StreamReader(context.Request.InputStream))
                {
                    string json = reader.ReadToEnd();
                    if (string.IsNullOrEmpty(json))
                    {
                        RespondWithError(context, 400, "請求中沒有資料。");
                        return;
                    }

                    var requestData = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
                    if (requestData == null)
                    {
                        RespondWithError(context, 400, "無法解析請求中的 JSON 資料。");
                        return;
                    }

                    // 取得資料並轉換為字串
                    name_R = requestData.GetValueOrDefault("name", "").ToString();
                    phoneNumber_R = requestData.GetValueOrDefault("phoneNumber", "").ToString();
                    email_R = requestData.GetValueOrDefault("email", "").ToString();
                    message_R = requestData.GetValueOrDefault("message", "").ToString();
                    roomtype = requestData.GetValueOrDefault("roomtype", null)?.ToString();

                    // 取得情感分析的 percent_positive
                    if (requestData.ContainsKey("percent_positive") && int.TryParse(requestData["percent_positive"].ToString(), out int percent))
                    {
                        percent_positive = percent;
                    }

                    // 取得 ratings 評分資料
                    if (requestData.ContainsKey("ratings"))
                    {
                        ratings = JsonConvert.DeserializeObject<Dictionary<string, string>>(
                            requestData["ratings"].ToString() ?? "{}");
                    }
                }

                // 檢查必要欄位是否填寫
                if (string.IsNullOrEmpty(name_R) || string.IsNullOrEmpty(phoneNumber_R) || string.IsNullOrEmpty(email_R))
                {
                    RespondWithError(context, 400, "請填寫所有必要的欄位。");
                    return;
                }

                // 取得資料庫連接字串
                string connectionString = System.Web.Configuration.WebConfigurationManager
                    .ConnectionStrings["accountConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 插入客戶回應資料，包含情感分析百分比
                    string customerQuery = @"
                        INSERT INTO dbo.custumerresponse 
                        (custermerName, custermerPhone, custermerEmail, custermerMessage, percent_positive, custermerinitDate) 
                        VALUES (@custermerName, @custermerPhone, @custermerEmail, @custermerMessage, @percent_positive, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(customerQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@custermerName", name_R);
                        cmd.Parameters.AddWithValue("@custermerPhone", phoneNumber_R);
                        cmd.Parameters.AddWithValue("@custermerEmail", email_R);
                        cmd.Parameters.AddWithValue("@custermerMessage", message_R);
                        cmd.Parameters.AddWithValue("@percent_positive", percent_positive);
                        cmd.ExecuteNonQuery();
                    }

                    // 插入評分資料（包括 roomtype）
                    string ratingQuery = @"
                        INSERT INTO dbo.starrating 
                        (custermerName, Cost_effectiveness, Entertainment, Convenience, Others, Clean, RoomType, initDate) 
                        VALUES (@custermerName, @CostEffectiveness, @Entertainment, @Convenience, @Others, @Clean, @RoomType, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(ratingQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@custermerName", name_R);
                        cmd.Parameters.AddWithValue("@CostEffectiveness", ratings.GetValueOrDefault("39", "0"));
                        cmd.Parameters.AddWithValue("@Entertainment", ratings.GetValueOrDefault("40", "0"));
                        cmd.Parameters.AddWithValue("@Convenience", ratings.GetValueOrDefault("41", "0"));
                        cmd.Parameters.AddWithValue("@Others", ratings.GetValueOrDefault("42", "0"));
                        cmd.Parameters.AddWithValue("@Clean", ratings.GetValueOrDefault("43", "0"));

                        // 處理 roomtype 為 null 的情況
                        if (string.IsNullOrEmpty(roomtype))
                            cmd.Parameters.AddWithValue("@RoomType", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@RoomType", roomtype);

                        cmd.ExecuteNonQuery();
                    }
                }
                // 發送郵件給管理者和留言者
                SendEmail(email_R, message_R, name_R, phoneNumber_R);

                // 回傳成功訊息
                context.Response.Write(JsonConvert.SerializeObject(new { message = "成功" }));
            }
            catch (SqlException ex)
            {
                LogError(ex);
                RespondWithError(context, 500, "資料庫操作失敗：" + ex.Message);
            }
            catch (Exception ex)
            {
                LogError(ex);
                RespondWithError(context, 500, "發生未知錯誤：" + ex.Message);
            }
        }
        private void SendEmail(string userEmail, string message_R, string name_R, string phoneNumber_R)
        {
            string adminEmail = "sunshinehotel2024@gmail.com"; //管理者的郵件地址
            string senderEmail = "sunshinehotel2024@gmail.com"; // 發送郵件的帳號
            string senderPassword = "tbfikoadbbtgffnd"; // SMTP應用程式密碼

            // 配置 SMTP 客戶端
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587) //Gmail 的 SMTP 伺服器地址。587 是伺服器的端口號
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(senderEmail, senderPassword)
            };

            // 發送給管理者的郵件
            MailMessage adminMail = new MailMessage(senderEmail, adminEmail)
            {
                Subject = "綠光民宿旅客的意見回饋",
                Body = $"收到一則來自 {name_R} 的意見回饋：\n\n" +
                       $"旅客的信箱為：{userEmail}\n" +
                       $"旅客的電話為：{phoneNumber_R}\n" +
                       $"內容為:{message_R}\n\n",

                IsBodyHtml = false
            };

            // 發送給留言者的確認郵件
            MailMessage userMail = new MailMessage(senderEmail, userEmail)
            {
                Subject = "日光民宿已收到您的意見回饋",
                Body = "再次感謝您提供的意見回饋，我們歡迎您下次光臨！",
                IsBodyHtml = false  //表示電子郵件的內容（Body）是純文字格式，而不是 HTML 格式。
            };

            // 發送郵件
            smtpClient.Send(adminMail);
            smtpClient.Send(userMail);
        }

        public bool IsReusable => false;

        // 統一錯誤回應方法
        private void RespondWithError(HttpContext context, int statusCode, string message)
        {
            context.Response.StatusCode = statusCode;
            context.Response.Write(JsonConvert.SerializeObject(new { error = message }));
        }

        // 紀錄錯誤訊息
        private void LogError(Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"[Error] {ex.Message}\n{ex.StackTrace}");
        }
    }

    // 靜態類別：包含擴展方法
    public static class DictionaryExtensions
    {
        public static TValue GetValueOrDefault<TKey, TValue>(
            this Dictionary<TKey, TValue> dictionary,
            TKey key,
            TValue defaultValue = default)
        {
            return dictionary != null && dictionary.TryGetValue(key, out TValue value)
                ? value
                : defaultValue;
        }
    }
}
