using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class AccountManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 測試是否有儲存使用者的 Session
            if (Session["UserName"] != null)
            {
                string userId = Session["UserName"].ToString();
                // 不再需要印出測試訊息到頁面
            }
            else
            {
                // 如果 Session["UserName"] 為空，則顯示此訊息
                Response.Write("Session 無值，使用者尚未登入<br/>");
            }

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")  // 檢查是否為 AJAX 請求
            {
                string userId = Session["UserName"]?.ToString();
                if (!string.IsNullOrEmpty(userId))
                {
                    LoadUserData(userId);  // 回傳 JSON 資料
                }
                else
                {
                    Response.StatusCode = 401;  // 未登入
                    Response.End();
                }
            }
            else
            {
                // 非 AJAX 請求時正常加載頁面
                if (!IsPostBack)
                {
                    if (Session["UserName"] != null)
                    {
                        string userId = Session["UserName"].ToString();
                        // 正常的頁面加載邏輯，抓取資料庫顯示於頁面
                        // 你可以在這裡執行需要的後端邏輯
                    }
                    else
                    {
                        Response.Redirect("~/Login.aspx");  // 沒有登入時導向登入頁面
                    }
                }
            }
        }

        private void LoadUserData(string userId)
        {
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT firstName, lastName, userid, email, phoneNumber, identityNumber FROM dbo.accountInformation WHERE userid = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // 將資料組裝成 JSON 物件並回傳給前端
                            var userData = new
                            {
                                firstName = reader["firstName"].ToString(),
                                lastName = reader["lastName"].ToString(),
                                userId = reader["userid"].ToString(),
                                email = reader["email"].ToString(),
                                phoneNumber = reader["phoneNumber"].ToString(),
                                identityNumber = reader["identityNumber"].ToString()
                            };

                            var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(userData);
                            Response.Clear();
                            Response.ContentType = "application/json";
                            Response.Write(json);
                            Response.End();
                        }
                    }
                }
            }
        }
    }
}
