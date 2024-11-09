using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace Project
{
    public partial class RestPass : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 從 URL 取得 token
                string token = Request.QueryString["token"];
                // 從 Session 取得 email
                string email = Session["ResetEmail"] as string;

                // 檢查 Session 中是否有 email 並且 URL 中有 token
                if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(token))
                {
                    // 如果沒有 email 或 token，顯示錯誤訊息
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowError", "document.getElementById('passwordError').innerText = '連結無效，請重新申請重設密碼。';", true);
                    return;
                }

                // 驗證 token 是否有效
                bool isValidToken = ValidateToken(email, token);
                if (!isValidToken)
                {
                    // 如果 token 無效或已過期，顯示錯誤訊息
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowError", "document.getElementById('passwordError').innerText = '連結已過期或無效，請重新申請重設密碼。';", true);
                    return;
                }

                // 如果驗證通過，顯示 email 資訊在頁面上
                emailLabel.Text = $"Hi {email}，請輸入新密碼進行重設";

                // 將 email 值嵌入 JavaScript 中
                UserEmailScriptLiteral.Text = $"<script>var userEmail = '{email}';</script>";
            }
        }

        private bool ValidateToken(string email, string token)
        {
            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT expires_at, is_used FROM PasswordResetTokens WHERE email = @Email AND token = @Token";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Token", token);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            DateTime expiresAt = reader.GetDateTime(0);
                            bool isUsed = reader.GetBoolean(1);

                            // 檢查 token 是否未過期且未被使用
                            if (expiresAt > DateTime.Now && !isUsed)
                            {
                                return true; // Token is valid
                            }
                        }
                    }
                }
            }
            return false; // Token is invalid or expired
        }
    }
}
