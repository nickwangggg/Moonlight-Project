using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Project
{
    /// <summary>
    /// MotifyUserData 的摘要描述
    /// </summary>
    public class MotifyUserData : IHttpHandler
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

                // 連接字串
                string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        // 檢查使用者是否存在
                        string checkUserQuery = "SELECT COUNT(*) FROM dbo.accountInformation WHERE userid = @UserId";
                        using (SqlCommand cmdCheckUser = new SqlCommand(checkUserQuery, conn))
                        {
                            cmdCheckUser.Parameters.AddWithValue("@UserId", userid);
                            int userCount = (int)cmdCheckUser.ExecuteScalar();
                            if (userCount == 0)
                            {
                                // 如果找不到使用者，返回錯誤訊息
                                context.Response.Write("UserNotFound");
                                return;
                            }
                        }

                        // 更新 SQL 語句，更新使用者的基本資料
                        string updateQuery = "UPDATE dbo.accountInformation SET firstName = @FirstName, lastName = @LastName, identityNumber = @IdentityNumber, phoneNumber = @PhoneNumber, email = @Email WHERE userid = @UserId";

                        // 建立 SQL 命令來執行更新
                        using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                        {
                            // 添加參數到 SQL 命令中
                            cmdUpdate.Parameters.AddWithValue("@FirstName", firstName);
                            cmdUpdate.Parameters.AddWithValue("@LastName", lastName);
                            cmdUpdate.Parameters.AddWithValue("@UserId", userid);
                            cmdUpdate.Parameters.AddWithValue("@IdentityNumber", identityNumber);
                            cmdUpdate.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                            cmdUpdate.Parameters.AddWithValue("@Email", email);

                            // 執行命令，更新資料庫中的資料
                            cmdUpdate.ExecuteNonQuery();
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
                    context.Response.Write("Error: 無法更新資料庫，詳情：" + ex.Message);
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
    }
}