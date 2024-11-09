using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Project
{
    public class ResetPasswordHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string email = context.Request["email"];
            string newPassword = context.Request["password"];
            string token = context.Request["token"]; // 從 URL 或表單中取得 token

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(token))
            {
                context.Response.Write("InvalidRequest");
                return;
            }

            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 驗證 token 是否有效，且符合條件
                    string checkTokenQuery = @"
                        SELECT TOP 1 token 
                        FROM PasswordResetTokens 
                        WHERE email = @Email AND is_used = 0 AND expires_at > GETDATE()
                        ORDER BY ABS(DATEDIFF(SECOND, created_at, GETDATE())) ASC";

                    using (SqlCommand cmdCheckToken = new SqlCommand(checkTokenQuery, conn))
                    {
                        cmdCheckToken.Parameters.AddWithValue("@Email", email);
                        string validToken = (string)cmdCheckToken.ExecuteScalar();

                        if (validToken == null || !validToken.Equals(token))
                        {
                            // 如果 token 無效，返回錯誤訊息
                            context.Response.Write("InvalidToken");
                            return;
                        }
                    }

                    // 檢查 email 是否存在於 accountInformation 表中
                    string checkEmailQuery = "SELECT COUNT(*) FROM dbo.accountInformation WHERE email = @Email";
                    using (SqlCommand cmdCheckEmail = new SqlCommand(checkEmailQuery, conn))
                    {
                        cmdCheckEmail.Parameters.AddWithValue("@Email", email);
                        int userCount = (int)cmdCheckEmail.ExecuteScalar();
                        if (userCount == 0)
                        {
                            context.Response.Write("UserNotFound");
                            return;
                        }
                    }

                    // 雜湊並加鹽處理新密碼
                    string hashedPasswordWithSalt = HashPassword(newPassword);

                    // 更新使用者的密碼
                    string updatePasswordQuery = "UPDATE dbo.accountInformation SET password = @Password WHERE email = @Email";
                    using (SqlCommand cmdUpdatePassword = new SqlCommand(updatePasswordQuery, conn))
                    {
                        cmdUpdatePassword.Parameters.AddWithValue("@Password", hashedPasswordWithSalt);
                        cmdUpdatePassword.Parameters.AddWithValue("@Email", email);
                        cmdUpdatePassword.ExecuteNonQuery();
                    }

                    // 更新 token 狀態為已使用
                    string updateTokenQuery = "UPDATE PasswordResetTokens SET is_used = 1 WHERE email = @Email AND token = @Token";
                    using (SqlCommand cmdUpdateToken = new SqlCommand(updateTokenQuery, conn))
                    {
                        cmdUpdateToken.Parameters.AddWithValue("@Email", email);
                        cmdUpdateToken.Parameters.AddWithValue("@Token", token);
                        cmdUpdateToken.ExecuteNonQuery();
                    }

                    context.Response.Write("PasswordResetSuccess");
                }
            }
            catch (Exception)
            {
                // 若發生錯誤，回傳一般的錯誤訊息避免敏感訊息洩露
                context.Response.Write("ServerError");
            }
        }

        // 使用 SHA256 進行密碼雜湊並加鹽
        private string HashPassword(string password)
        {
            // 生成隨機的 Salt
            byte[] saltBytes = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }

            // 將 Salt 與密碼結合
            var passwordBytes = Encoding.UTF8.GetBytes(password);
            var saltedPasswordBytes = new byte[saltBytes.Length + passwordBytes.Length];
            Array.Copy(saltBytes, 0, saltedPasswordBytes, 0, saltBytes.Length);
            Array.Copy(passwordBytes, 0, saltedPasswordBytes, saltBytes.Length, passwordBytes.Length);

            // 使用 SHA256 進行雜湊
            using (var sha256 = SHA256.Create())
            {
                byte[] hashBytes = sha256.ComputeHash(saltedPasswordBytes);

                // 將 Salt 和 Hash 結果合併存儲
                byte[] hashWithSaltBytes = new byte[saltBytes.Length + hashBytes.Length];
                Array.Copy(saltBytes, 0, hashWithSaltBytes, 0, saltBytes.Length);
                Array.Copy(hashBytes, 0, hashWithSaltBytes, saltBytes.Length, hashBytes.Length);

                // 返回 Base64 字符串
                return Convert.ToBase64String(hashWithSaltBytes);
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
