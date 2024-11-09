using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;

namespace Project
{
    public class GetProfileImage : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var response = new { imageUrl = "", message = "" };

            // 測試 Session 狀態
            if (context.Session["UserName"] != null)
            {
                string userId = context.Session["UserName"].ToString();  // 從 Session 中獲取 userId

                // 測試輸出，確認 Session 中的 userId
                response = new { imageUrl = "", message = $"Session 有值: {userId}" };

                // 從資料庫讀取該使用者的圖片 URL
                string imageUrl = GetProfileImageFromDatabase(userId);
                if (!string.IsNullOrEmpty(imageUrl))
                {
                    response = new { imageUrl = imageUrl, message = $"取得的圖片 URL: {imageUrl}" };
                }
            }
            else
            {
                // Session 沒有值，返回提示訊息
                response = new { imageUrl = "", message = "Session 無值，使用者尚未登入" };
            }

            // 返回測試訊息和圖片 URL 給前端
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(response));
        }

        private string GetProfileImageFromDatabase(string userId)
        {
            string imageUrl = null;
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT ProfileImageUrl FROM UserImg WHERE userid = @userid";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userid", userId);
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        imageUrl = reader["ProfileImageUrl"].ToString();
                    }
                }
            }

            return imageUrl;
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
