using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.SessionState;

namespace Project
{
    public class UploadProfileImage : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var response = new { success = false, imageUrl = "", error = "" };

            try
            {
                // 確認使用者是否已登入並存在於 Session 中
                if (context.Session["UserName"] != null)
                {
                    string userId = context.Session["UserName"].ToString();  // 從 Session 中取得使用者 ID

                    // 檢查是否是移除圖片的操作
                    string action = context.Request.QueryString["action"];
                    if (action == "remove")
                    {
                        // 將圖片設為預設圖片並從資料庫中刪除路徑
                        string defaultImageUrl = context.Request.Url.GetLeftPart(UriPartial.Authority) +
                            VirtualPathUtility.ToAbsolute("~/Content/Images/airview1.jpg");

                        RemoveProfileImageFromDatabase(userId);

                        response = new { success = true, imageUrl = defaultImageUrl, error = "" };
                    }
                    else
                    {
                        // 上傳圖片的邏輯保持不變
                        if (context.Request.Files.Count > 0)
                        {
                            HttpPostedFile file = context.Request.Files["profileImage"];
                            if (file != null && file.ContentLength > 0)
                            {
                                // 獲取檔案名稱並生成存放路徑
                                string uploadPath = context.Server.MapPath("~/UserImages/");
                                string fileName = Path.GetFileName(file.FileName);
                                string filePath = Path.Combine(uploadPath, fileName);

                                // 確保目錄存在
                                if (!Directory.Exists(uploadPath))
                                {
                                    Directory.CreateDirectory(uploadPath);
                                }

                                // 儲存圖片
                                file.SaveAs(filePath);

                                // 生成圖片 URL
                                string imageUrl = context.Request.Url.GetLeftPart(UriPartial.Authority) +
                                    "/UserImages/" + fileName;

                                // 儲存使用者圖片路徑到資料庫
                                SaveProfileImageToDatabase(userId, imageUrl);

                                // 返回圖片的 URL 給前端
                                response = new { success = true, imageUrl = imageUrl, error = "" };
                            }
                            else
                            {
                                response = new { success = false, imageUrl = "", error = "沒有上傳檔案" };
                            }
                        }
                    }
                }
                else
                {
                    response = new { success = false, imageUrl = "", error = "使用者尚未登入" };
                }
            }
            catch (Exception ex)
            {
                response = new { success = false, imageUrl = "", error = ex.Message };
            }

            // 返回 JSON 格式的回應
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(response));
        }

        // 用來清除使用者圖片路徑
        private void RemoveProfileImageFromDatabase(string userId)
        {
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "UPDATE UserImg SET ProfileImageUrl = NULL WHERE userid = @userid";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userid", userId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // 儲存圖片路徑到資料庫
        private void SaveProfileImageToDatabase(string userId, string imageUrl)
        {
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    IF EXISTS (SELECT 1 FROM UserImg WHERE userid = @userid)
                    BEGIN
                        UPDATE UserImg SET ProfileImageUrl = @imageUrl WHERE userid = @userid
                    END
                    ELSE
                    BEGIN
                        INSERT INTO UserImg (userid, ProfileImageUrl) VALUES (@userid, @imageUrl)
                    END";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userid", userId);
                    cmd.Parameters.AddWithValue("@imageUrl", imageUrl);
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
