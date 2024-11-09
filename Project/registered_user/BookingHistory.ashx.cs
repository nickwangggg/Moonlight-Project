using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Web.SessionState;

namespace Project.registered_user
{
    public class BookingHistory : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // 從 Session 中取得目前登入的 UserId
            string userId = HttpContext.Current.Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                context.Response.StatusCode = 401; // 未授權
                context.Response.Write("{\"error\":\"使用者未登入或 Session 已過期\"}");
                return;
            }

            List<object> bookingHistory = new List<object>();

            try
            {
                // SQL 查詢邏輯
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
                {
                    string query = @"
                        SELECT 
                            B.BookingId, 
                            B.CheckInDate, 
                            B.CheckOutDate, 
                            B.Price, 
                            A.lastName + A.firstName AS FullName, 
                            A.userid, 
                            A.phoneNumber, 
                            A.identityNumber, 
                            A.email, 
                            R.Building + ' ' + R.RoomType AS RoomDescription 
                        FROM 
                            Bookings B
                        JOIN 
                            accountInformation A ON B.UserId = A.userid
                        JOIN 
                            Rooms R ON B.RoomId = R.RoomId
                        WHERE 
                            B.UserId = @UserId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            bookingHistory.Add(new
                            {
                                BookingId = reader["BookingId"],
                                CheckInDate = Convert.ToDateTime(reader["CheckInDate"]).ToString("yyyy-MM-dd"),
                                CheckOutDate = Convert.ToDateTime(reader["CheckOutDate"]).ToString("yyyy-MM-dd"),
                                FullName = reader["FullName"],
                                UserId = reader["userid"],
                                PhoneNumber = reader["phoneNumber"],
                                RoomDescription = reader["RoomDescription"],
                                Price = reader["Price"],
                                IdentityNumber = reader["identityNumber"],
                                Email = reader["email"]
                            });
                        }
                    }
                }

                // 將結果序列化為 JSON 並返回
                JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.Write(js.Serialize(bookingHistory));
            }
            catch (Exception ex)
            {
                // 發生錯誤時返回詳細的錯誤訊息
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\":\"發生錯誤：" + ex.Message + "\"}");
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
