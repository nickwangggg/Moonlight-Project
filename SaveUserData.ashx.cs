using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Project
{
    public class SaveUserData : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                // 獲取 AJAX 發送過來的資料
                string firstName = context.Request["firstName"];
                string lastName = context.Request["lastName"];
                string userid = context.Request["userid"];
                string identityNumber = context.Request["identityNumber"];
                string phoneNumber = context.Request["phoneNumber"];
                string email = context.Request["email"];
                string password = context.Request["password"];
                bool agreeToTerms = Convert.ToBoolean(context.Request["agreeToTerms"]);

                // 加密密碼
                string hashedPasswordWithSalt = HashPassword(password);

                // 設定 permissionID 為 2
                int permissionID = 2;

                // 連接字串
                string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        // 先檢查使用者名稱是否存在
                        string checkUserQuery = "SELECT COUNT(*) FROM dbo.accountInformation WHERE userid = @UserId";
                        using (SqlCommand cmdCheckUser = new SqlCommand(checkUserQuery, conn))
                        {
                            cmdCheckUser.Parameters.AddWithValue("@UserId", userid);
                            int userCount = (int)cmdCheckUser.ExecuteScalar();
                            if (userCount > 0)
                            {
                                context.Response.Write("UsernameExists");
                                return;
                            }
                        }

                        // 再檢查 e-mail 是否存在
                        string checkEmailQuery = "SELECT COUNT(*) FROM dbo.accountInformation WHERE email = @Email";
                        using (SqlCommand cmdCheckEmail = new SqlCommand(checkEmailQuery, conn))
                        {
                            cmdCheckEmail.Parameters.AddWithValue("@Email", email);
                            int emailCount = (int)cmdCheckEmail.ExecuteScalar();
                            if (emailCount > 0)
                            {
                                context.Response.Write("EmailExists");
                                return;
                            }
                        }

                        // 根據 permissionID 生成對應區間的 id
                        int newID = GenerateNewID(conn, permissionID);

                        // 插入 SQL 語句
                        string query = "INSERT INTO dbo.accountInformation (id, firstName, lastName, userid, identityNumber, phoneNumber, email, password, agreeToTerms, initDate, permissionID) " +
                                       "VALUES (@ID, @FirstName, @LastName, @UserId, @IdentityNumber, @PhoneNumber, @Email, @Password, @AgreeToTerms, GETDATE(), @PermissionID)";

                        // 建立 SQL 命令
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            // 添加參數到 SQL 命令中
                            cmd.Parameters.AddWithValue("@ID", newID);
                            cmd.Parameters.AddWithValue("@FirstName", firstName);
                            cmd.Parameters.AddWithValue("@LastName", lastName);
                            cmd.Parameters.AddWithValue("@UserId", userid);
                            cmd.Parameters.AddWithValue("@IdentityNumber", identityNumber);
                            cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Password", hashedPasswordWithSalt); // 加密後的密碼
                            cmd.Parameters.AddWithValue("@AgreeToTerms", agreeToTerms);
                            cmd.Parameters.AddWithValue("@PermissionID", permissionID);

                            // 執行命令，將資料插入資料庫
                            cmd.ExecuteNonQuery();
                        }

                        // 返回成功訊息
                        context.Response.Write("Success");
                    }
                }
                catch (Exception ex)
                {
                    // 捕捉資料庫連接失敗或執行失敗的異常
                    System.Diagnostics.Debug.WriteLine("Connection failed: " + ex.Message);
                    context.Response.StatusCode = 500;
                    context.Response.Write("Error: 無法寫入資料庫，詳情：" + ex.Message);
                }
            }
            catch (Exception ex)
            {
                // 捕捉處理其他異常
                context.Response.StatusCode = 500;
                context.Response.Write("Error: 發生其他錯誤。詳情：" + ex.Message);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        // 生成根據 permissionID 分配的 ID
        private int GenerateNewID(SqlConnection conn, int permissionID)
        {
            int minID = 0, maxID = 0;
            switch (permissionID)
            {
                case 1:
                    minID = 1; maxID = 1000; break;
                case 2:
                    minID = 1001; maxID = 2000; break;
                case 3:
                    minID = 2001; maxID = 3000; break;
                case 4:
                    minID = 3001; maxID = 4000; break;
                case 5:
                    minID = 4001; maxID = 5000; break;
                default:
                    throw new ArgumentException("Invalid permissionID");
            }

            // 查找該區間內的最大 ID
            string query = "SELECT ISNULL(MAX(id), @MinID - 1) + 1 FROM dbo.accountInformation WHERE id BETWEEN @MinID AND @MaxID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@MinID", minID);
                cmd.Parameters.AddWithValue("@MaxID", maxID);

                int newID = (int)cmd.ExecuteScalar();
                return newID;
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
    }
}
