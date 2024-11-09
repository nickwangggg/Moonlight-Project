using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;

namespace Project.registered_user
{
    public class Payment1 : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                string userId = HttpContext.Current.Session["UserName"]?.ToString();

                if (string.IsNullOrEmpty(userId))
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"error\": \"Session UserId is missing.\"}");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
                {
                    string query = @"
                        SELECT TOP 1 
                            B.RoomId, 
                            B.CheckInDate, 
                            B.CheckOutDate, 
                            B.Occupancy, 
                            B.UserId, 
                            B.Price, 
                            B.bookingTime, 
                            R.RoomType 
                            FROM Bookings B
                            JOIN Rooms R ON B.RoomId = R.RoomId
                            WHERE B.UserId = @UserId
                            ORDER BY B.bookingTime DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string bookingTime = Convert.ToDateTime(reader["bookingTime"]).ToString("yyyy-MM-dd HH:mm:ss");
                            string priceFormatted = decimal.Parse(reader["Price"].ToString()).ToString("F0");

                            var bookingDetails = new
                            {
                                RoomId = reader["RoomId"].ToString(),
                                CheckInDate = reader["CheckInDate"].ToString(),
                                CheckOutDate = reader["CheckOutDate"].ToString(),
                                Occupancy = reader["Occupancy"].ToString(),
                                UserId = reader["UserId"].ToString(),
                                Price = priceFormatted,
                                BookingTime = bookingTime,
                                RoomType = reader["RoomType"].ToString()
                            };

                            string json = JsonConvert.SerializeObject(bookingDetails);
                            context.Response.Write(json);
                            return;
                        }
                    }

                    // 如果沒有找到任何有效資料，返回 404
                    context.Response.StatusCode = 404;
                    context.Response.Write("{\"error\": \"No booking found for this user.\"}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("資料處理錯誤: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\": \"Internal server error: " + ex.Message + "\", \"stackTrace\": \"" + ex.StackTrace + "\"}");
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
