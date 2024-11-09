using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace Project.registered_user
{
    /// <summary>
    /// RoomAI 的摘要描述
    /// </summary>
    public class RoomAI : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // 嘗試取得 Session 中的 userId，但允許為空值
            string userId = HttpContext.Current.Session["UserName"]?.ToString() ?? string.Empty;

            try
            {
                // 讀取 JSON 資料
                string jsonData = new StreamReader(context.Request.InputStream).ReadToEnd();
                var serializer = new JavaScriptSerializer();

                // 嘗試反序列化為 Dictionary<string, int>
                var scores = serializer.Deserialize<Dictionary<string, int>>(jsonData);

                if (scores == null || scores.Count == 0)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"error\":\"無法解析排序結果\"}");
                    return;
                }

                // 將資料寫入資料庫
                SaveOrUpdateScores(scores, userId);

                context.Response.Write("{\"status\":\"success\"}");
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\":\"" + ex.Message + "\"}");
            }
        }

        private void SaveOrUpdateScores(Dictionary<string, int> scores, string userId)
        {
            // 取得連接字串
            using (SqlConnection conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                // 使用 MERGE 語法來插入或更新資料
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
                            submission_date = GETDATE() -- 更新日期時間為當前時間
                    WHEN NOT MATCHED THEN
                        INSERT (userid, Cost_effectiveness, Clean, Entertainment, Convenience, Others, submission_date) 
                        VALUES (NULLIF(@userId, ''), @CostEffectiveness, @Clean, @Entertainment, @Convenience, @Others, GETDATE());";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // 加入參數以防止 SQL Injection
                    cmd.Parameters.AddWithValue("@userId", userId);
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
