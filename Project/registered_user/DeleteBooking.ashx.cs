using System;
using System.Data.SqlClient;
using System.Web;
using System.Configuration;
using System.Web.SessionState;

namespace Project.registered_user
{
    public class DeleteBooking : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                // 取得並檢查 bookingId
                if (!int.TryParse(context.Request.Form["bookingId"], out int bookingId))
                {
                    context.Response.Write("{\"success\":false, \"error\":\"無效的訂單 ID。\"}");
                    return;
                }

                // 從 Session 取得刪除者的 userid
                string deletedBy = context.Session["UserName"]?.ToString();
                if (string.IsNullOrEmpty(deletedBy))
                {
                    context.Response.Write("{\"success\":false, \"error\":\"無法識別刪除者。\"}");
                    return;
                }

                // 建立資料庫連線
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // 先檢查訂單是否存在
                    using (SqlCommand selectCmd = new SqlCommand(@"
                        SELECT 
                            BookingId, CheckInDate, CheckOutDate, Price, 
                            A.lastName + A.firstName AS FullName, A.userid, 
                            A.phoneNumber, A.identityNumber, A.email, 
                            R.Building + ' ' + R.RoomType AS RoomDescription 
                        FROM 
                            Bookings B
                        JOIN 
                            accountInformation A ON B.UserId = A.userid
                        JOIN 
                            Rooms R ON B.RoomId = R.RoomId
                        WHERE 
                            B.BookingId = @BookingId", conn))
                    {
                        selectCmd.Parameters.AddWithValue("@BookingId", bookingId);

                        using (SqlDataReader reader = selectCmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                context.Response.Write("{\"success\":false, \"error\":\"找不到該訂單。\"}");
                                return;
                            }

                            // 取得需要插入的資料
                            var bookingData = new
                            {
                                BookingId = reader["BookingId"],
                                CheckInDate = reader["CheckInDate"],
                                CheckOutDate = reader["CheckOutDate"],
                                FullName = reader["FullName"],
                                UserId = reader["userid"],
                                PhoneNumber = reader["phoneNumber"],
                                RoomDescription = reader["RoomDescription"],
                                Price = reader["Price"],
                                IdentityNumber = reader["identityNumber"],
                                Email = reader["email"]
                            };

                            reader.Close(); // 確保 Reader 已關閉

                            // 插入到 DeletedRoomHistory 表
                            using (SqlCommand insertCmd = new SqlCommand(@"
                                INSERT INTO DeletedRoomHistory 
                                (BookingId, CheckInDate, CheckOutDate, FullName, UserId, 
                                PhoneNumber, RoomDescription, Price, identityNumber, email, DeletedName)
                                VALUES 
                                (@BookingId, @CheckInDate, @CheckOutDate, @FullName, @UserId, 
                                @PhoneNumber, @RoomDescription, @Price, @identityNumber, @Email, @DeletedName)", conn))
                            {
                                insertCmd.Parameters.AddWithValue("@BookingId", bookingData.BookingId);
                                insertCmd.Parameters.AddWithValue("@CheckInDate", bookingData.CheckInDate);
                                insertCmd.Parameters.AddWithValue("@CheckOutDate", bookingData.CheckOutDate);
                                insertCmd.Parameters.AddWithValue("@FullName", bookingData.FullName);
                                insertCmd.Parameters.AddWithValue("@UserId", bookingData.UserId);
                                insertCmd.Parameters.AddWithValue("@PhoneNumber", bookingData.PhoneNumber);
                                insertCmd.Parameters.AddWithValue("@RoomDescription", bookingData.RoomDescription);
                                insertCmd.Parameters.AddWithValue("@Price", bookingData.Price);
                                insertCmd.Parameters.AddWithValue("@identityNumber", bookingData.IdentityNumber);
                                insertCmd.Parameters.AddWithValue("@Email", bookingData.Email);
                                insertCmd.Parameters.AddWithValue("@DeletedName", deletedBy);

                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }

                    // 刪除 Bookings 中的資料
                    using (SqlCommand deleteCmd = new SqlCommand(
                        "DELETE FROM Bookings WHERE BookingId = @BookingId", conn))
                    {
                        deleteCmd.Parameters.AddWithValue("@BookingId", bookingId);

                        int rowsAffected = deleteCmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            context.Response.Write("{\"success\":true}");
                        }
                        else
                        {
                            context.Response.Write("{\"success\":false, \"error\":\"無法刪除訂單。\"}");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // 回傳錯誤訊息
                context.Response.StatusCode = 500;
                context.Response.Write("{\"success\":false, \"error\":\"發生錯誤：" + ex.Message + "\"}");
            }
        }

        public bool IsReusable => false;
    }
}
