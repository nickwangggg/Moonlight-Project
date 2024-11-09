using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;
using System.Web.Security;
using Newtonsoft.Json;
using System.Security.Cryptography;
using System.Text;
using System.Collections;

namespace Project
{
    public class LoginHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string emailOrUserid = context.Request["emailOrUserid"];
            string password = context.Request["password"];

            string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 查詢 email 或 userid 是否存在，並取得儲存的鹽值與密碼
                    string query = "SELECT userid, firstName, lastName, email, password, permissionID FROM dbo.accountInformation WHERE email = @EmailOrUserid OR userid = @EmailOrUserid";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmailOrUserid", emailOrUserid);

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            // 從資料庫中取得密碼和使用者相關資訊
                            string userId = reader["userid"].ToString();
                            string firstName = reader["firstName"].ToString();
                            string lastName = reader["lastName"].ToString();
                            string email = reader["email"].ToString();
                            string storedPassword = reader["password"].ToString(); // 儲存的密碼（鹽+雜湊）
                            string permission = reader["permissionID"].ToString();

                            // 驗證使用者輸入的密碼是否正確
                            if (VerifyPassword(password, storedPassword))
                            {
                                // 成功登入，創建 userinformation 物件
                                var userInfo = new
                                {
                                    id = userId,
                                    name = firstName + " " + lastName,
                                    username = userId,
                                    mail = email,
                                    permission = permission
                            };

                                // 序列化使用者資訊到 JSON
                                string userData = JsonConvert.SerializeObject(userInfo);

                                // 設置 Forms Authentication 票卷
                                SetAuthenTicket(userData, userId, context);

                                // 將使用者 ID 儲存在 Session 中
                                context.Session["UserName"] = userId;
                                context.Session["Permission"] = permission; // 將 permission 存入 Session

                                // 成功返回
                                context.Response.Write("Success");
                            }
                            else
                            {
                                // 密碼驗證失敗
                                context.Response.Write("Fail");
                            }
                        }
                        else
                        {
                            // 使用者不存在
                            context.Response.Write("Fail");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("Error: " + ex.Message);
            }
        }

        // 設置 Forms Authentication 票卷的方法
        private void SetAuthenTicket(string userData, string userId, HttpContext context)
        {
            // 創建 Forms Authentication 票卷
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                1, // 版本號
                userId, // 使用者 ID
                DateTime.Now, // 發行時間
                DateTime.Now.AddHours(3), // 過期時間
                false, // 是否記住用戶
                userData, // 使用者資料（序列化為 JSON）
                FormsAuthentication.FormsCookiePath // Cookie 路徑
            );

            // 加密票卷
            string encryptedTicket = FormsAuthentication.Encrypt(ticket);

            // 建立 HttpCookie 保存加密的票卷
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
            authCookie.Expires = DateTime.Now.AddHours(3); // 設定 Cookie 過期時間
            context.Response.Cookies.Add(authCookie); // 添加到回應中
        }

        // 使用 SHA256 進行密碼雜湊並加鹽驗證的方法
        private bool VerifyPassword(string enteredPassword, string storedHash)
        {
            // 從儲存的 hash 中提取出 salt 和 hash
            byte[] hashWithSaltBytes = Convert.FromBase64String(storedHash);

            // 第一個 16 位元組是 salt
            byte[] saltBytes = new byte[16];
            Array.Copy(hashWithSaltBytes, 0, saltBytes, 0, saltBytes.Length);

            // 剩下的部分是原始的 hash
            byte[] storedHashBytes = new byte[hashWithSaltBytes.Length - saltBytes.Length];
            Array.Copy(hashWithSaltBytes, saltBytes.Length, storedHashBytes, 0, storedHashBytes.Length);

            // 將使用者輸入的密碼與提取的 salt 結合
            var passwordBytes = Encoding.UTF8.GetBytes(enteredPassword);
            var saltedPasswordBytes = new byte[saltBytes.Length + passwordBytes.Length];
            Array.Copy(saltBytes, 0, saltedPasswordBytes, 0, saltBytes.Length);
            Array.Copy(passwordBytes, 0, saltedPasswordBytes, saltBytes.Length, passwordBytes.Length);

            // 重新計算 hash
            using (var sha256 = SHA256.Create())
            {
                byte[] enteredHashBytes = sha256.ComputeHash(saltedPasswordBytes);

                // 比較儲存的 hash 和重新計算的 hash
                return StructuralComparisons.StructuralEqualityComparer.Equals(storedHashBytes, enteredHashBytes);
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
