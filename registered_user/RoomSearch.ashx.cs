using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Configuration;

namespace Project.registered_user
{
    public class RoomSearch : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // 取得前端傳來的查詢參數
            string userIdOrName = context.Request["userIdOrName"];
            string checkIn = context.Request["checkIn"];
            string checkOut = context.Request["checkOut"];
            string occupancy = context.Request["occupancy"];

            List<object> bookingHistory = new List<object>();

            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
                {
                    // SQL 查詢語句
                    string query = @"
                        SELECT 
                            B.BookingId, 
                            B.CheckInDate, 
                            B.CheckOutDate, 
                            A.lastName + A.firstName AS FullName, 
                            A.userid, 
                            A.identityNumber, 
                            A.phoneNumber, 
                            A.email, 
                            R.Building + ' ' + R.RoomType AS RoomDescription, 
                            B.Price
                        FROM 
                            Bookings B
                        JOIN 
                            accountInformation A ON B.UserId = A.userid
                        JOIN 
                            Rooms R ON B.RoomId = R.RoomId
                        WHERE 
                            (@UserIdOrName IS NULL OR A.userid = @UserIdOrName 
                             OR A.lastName + A.firstName LIKE '%' + @UserIdOrName + '%') AND
                            (@CheckIn IS NULL OR @CheckIn = '' OR B.CheckInDate >= @CheckIn) AND
                            (@CheckOut IS NULL OR @CheckOut = '' OR B.CheckOutDate <= @CheckOut) AND
                            (@Occupancy IS NULL OR @Occupancy = '' OR B.Occupancy = @Occupancy) AND
                            B.CheckInDate >= DATEADD(DAY, -5, GETDATE()) -- 過濾五天前的紀錄
                        ORDER BY B.CheckInDate ASC; -- 近到遠排序";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // 將查詢參數賦值給 SQL Command
                        cmd.Parameters.AddWithValue("@UserIdOrName",
                            string.IsNullOrEmpty(userIdOrName) ? (object)DBNull.Value : userIdOrName);
                        cmd.Parameters.AddWithValue("@CheckIn",
                            string.IsNullOrEmpty(checkIn) ? (object)DBNull.Value : checkIn);
                        cmd.Parameters.AddWithValue("@CheckOut",
                            string.IsNullOrEmpty(checkOut) ? (object)DBNull.Value : checkOut);
                        cmd.Parameters.AddWithValue("@Occupancy",
                            string.IsNullOrEmpty(occupancy) ? (object)DBNull.Value : occupancy);

                        // 開啟資料庫連接
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
                                    IdentityNumber = reader["identityNumber"],
                                    PhoneNumber = reader["phoneNumber"],
                                    Email = reader["email"],
                                    RoomDescription = reader["RoomDescription"],
                                    Price = reader["Price"]
                                });
                            }
                        }
                    }
                }

                // 將結果序列化為 JSON 格式並返回
                JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.Write(js.Serialize(bookingHistory));
            }
            catch (Exception ex)
            {
                // 發生錯誤時返回錯誤訊息
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\":\"發生錯誤：" + ex.Message + "\"}");
            }
        }

        public bool IsReusable => false;
    }
}
