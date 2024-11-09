using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace Project
{
    /// <summary>
    /// RoomAPI 的摘要描述
    /// </summary>
    public class RoomAPI : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string logDirectory = HttpContext.Current.Server.MapPath("~/Logs");
                if (!Directory.Exists(logDirectory))
                {
                    Directory.CreateDirectory(logDirectory); // 若 Logs 資料夾不存在，則建立
                }

                string logFilePath = Path.Combine(logDirectory, "log.txt");
                File.AppendAllText(logFilePath, $"Request arrived: {DateTime.Now}\n");

                context.Response.ContentType = "application/json";

                // 嘗試取得 Session 中的 UserID，若不存在則設為 null
                string userId = HttpContext.Current.Session["UserName"]?.ToString() ?? string.Empty;
                File.AppendAllText(logFilePath, $"UserID from session: {userId}\n");


                // 讀取傳入的 JSON 資料
                string jsonData = new StreamReader(context.Request.InputStream).ReadToEnd();
                var serializer = new JavaScriptSerializer();

                // 反序列化為 Dictionary<string, int>
                var scores = serializer.Deserialize<Dictionary<string, int>>(jsonData);
                File.AppendAllText(logFilePath, $"Received JSON: {jsonData}\n");


                if (scores == null || scores.Count == 0)
                {
                    context.Response.StatusCode = 400; // Bad Request
                    context.Response.Write("{\"error\":\"無法解析排序結果\"}");
                    return;
                }

                // 嘗試將資料寫入資料庫
                try
                {
                    SaveOrUpdateScores(scores, userId);
                }
                catch (Exception dbEx)
                {
                    // 若資料庫操作失敗，紀錄錯誤並回傳 500 錯誤
                    File.AppendAllText(logFilePath, $"Database error: {dbEx.Message}\n");
                    context.Response.StatusCode = 500;
                    context.Response.Write($"{{\"error\":\"Database operation failed: {dbEx.Message}\"}}");
                    return;
                }

                // 回傳成功訊息
                context.Response.Write("{\"status\":\"success\"}");
            }
            catch (Exception ex)
            {
                // 若整個流程發生例外，紀錄錯誤並回傳 500 錯誤
                string logFilePath = HttpContext.Current.Server.MapPath("~/Logs/log.txt");
                File.AppendAllText(logFilePath, $"Unhandled error: {ex.Message}\n");

                context.Response.StatusCode = 500;
                context.Response.Write($"{{\"error\":\"{ex.Message}\"}}");
            }
        }

        private void SaveOrUpdateScores(Dictionary<string, int> scores, string userId)
        {
            // 取得連接字串
            using (SqlConnection conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                string query = @"
                    MERGE INTO savescore AS target
                    USING (SELECT @userId AS userid) AS source
                    ON target.userid = source.userid
                    WHEN MATCHED THEN
                        UPDATE SET 
                            Cost_effectiveness = @CostEffectiveness,
                            Clean = @Clean,
                            Entertainment = @Entertainment,
                            Convenience = @Convenience,
                            Others = @Others,
                            submission_date = GETDATE()
                    WHEN NOT MATCHED THEN
                        INSERT (userid, Cost_effectiveness, Clean, Entertainment, Convenience, Others, submission_date) 
                        VALUES (NULLIF(@userId, ''), @CostEffectiveness, @Clean, @Entertainment, @Convenience, @Others, GETDATE());";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // 加入參數以防止 SQL Injection
                    cmd.Parameters.AddWithValue("@userId", (object)userId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CostEffectiveness", scores["CostEffectiveness"]);
                    cmd.Parameters.AddWithValue("@Clean", scores["Clean"]);
                    cmd.Parameters.AddWithValue("@Entertainment", scores["Entertainment"]);
                    cmd.Parameters.AddWithValue("@Convenience", scores["Convenience"]);
                    cmd.Parameters.AddWithValue("@Others", scores["Others"]);

                    // 開啟連接並執行 SQL 指令
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
