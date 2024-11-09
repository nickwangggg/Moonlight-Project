using System;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.SessionState;

namespace Project
{
    /// <summary>
    /// ResetPassword 的摘要描述
    /// </summary>
    public class ResetPassword : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.AddHeader("Access-Control-Allow-Origin", "*"); // 跨域請求允許
            string email = context.Request["email"];
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            if (string.IsNullOrEmpty(email))
            {
                context.Response.Write("請提供電子郵件地址。");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 查詢是否有該電子郵件的註冊記錄
                    string query = "SELECT userid FROM dbo.accountInformation WHERE email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();

                        if (result == null)
                        {
                            // 如果沒有該電子郵件，返回錯誤訊息
                            context.Response.Write("此信箱尚未註冊過，請先註冊帳號。");
                        }
                        else
                        {
                            // 儲存 email 到 Session 中
                            context.Session["ResetEmail"] = email;

                            // 生成唯一的 token
                            string token = Guid.NewGuid().ToString();
                            DateTime createdAt = DateTime.Now;
                            DateTime expiresAt = createdAt.AddMinutes(10); // 設置 token 有效期為 10 分鐘

                            // 儲存 token 到 PasswordResetTokens 資料表中
                            string tokenQuery = "INSERT INTO PasswordResetTokens (email, token, created_at, expires_at, is_used) VALUES (@Email, @Token, @CreatedAt, @ExpiresAt, 0)";
                            using (SqlCommand tokenCmd = new SqlCommand(tokenQuery, conn))
                            {
                                tokenCmd.Parameters.AddWithValue("@Email", email);
                                tokenCmd.Parameters.AddWithValue("@Token", token);
                                tokenCmd.Parameters.AddWithValue("@CreatedAt", createdAt);
                                tokenCmd.Parameters.AddWithValue("@ExpiresAt", expiresAt);
                                tokenCmd.ExecuteNonQuery();
                            }

                            // 發送包含重設密碼連結的郵件
                            SendEmail(email, token);
                            context.Response.Write("已發送重設密碼連結至您的信箱。");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // 如果發生錯誤，回傳錯誤訊息
                context.Response.Write("伺服器錯誤，請稍後再試。" + ex.Message);
            }
        }

        private void SendEmail(string userEmail, string token)
        {
            string senderEmail = "sunshinehotel2024@gmail.com"; // 發送郵件的帳號
            string senderPassword = "tbfikoadbbtgffnd"; // SMTP 應用程式密碼

            // 設定 SMTP 客戶端
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587)
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(senderEmail, senderPassword)
            };

            // 構建發送給使用者的重設密碼郵件內容
            string resetLink = $"https://moomlight.azurewebsites.net/RestPass?token={token}";
            string emailBody = $@"
                <div style='background-color:#f5f6f7; padding: 20px; text-align: center; font-family: Arial, sans-serif;'>
                    <h2 style='color: #003366;'>日光民宿</h2>
                    <div style='background-color: #ffffff; padding: 30px; border-radius: 10px; display: inline-block;'>
                        <h3 style='color: #333333;'>密碼重設申請</h3>
                        <p>點擊以下按鈕進行密碼重設（連結10分鐘後將會失效）</p>
                        <a href='{resetLink}' style='background-color: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-size: 16px;'>密碼重設</a>
                        <p style='color: #888888; margin-top: 20px;'>如果您並未要求重設密碼，請忽略此封信件。</p>
                    </div>
                    <footer style='margin-top: 20px; font-size: 12px; color: #888888;'>
                        <p>此信件為系統發送，請勿直接回覆</p>
                        <p>&copy; 日光民宿</p>
                    </footer>
                </div>";

            MailMessage userMail = new MailMessage(senderEmail, userEmail)
            {
                Subject = "日光民宿 - 密碼重設申請",
                Body = emailBody,
                IsBodyHtml = true
            };

            try
            {
                // 發送郵件
                smtpClient.Send(userMail);
            }
            catch (Exception ex)
            {
                // 可以加入錯誤處理邏輯，例如記錄錯誤訊息
                Console.WriteLine("郵件發送失敗：" + ex.Message);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
