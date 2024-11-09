using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Text;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;

namespace Project.registered_user
{
    public class booking1 : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string actionCheck = context.Request["actionCheck"];
            string actionBooking = context.Request["actionBooking"];

            try
            {
                if (actionCheck == "actionCheck")
                {
                    HandleRoomCheck(context);
                }
                else if (actionBooking == "actionBooking")
                {
                    HandleRoomBooking(context);
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("錯誤: " + ex.Message);
                context.Response.Write("錯誤: " + ex.Message);
            }
        }

        private void HandleRoomCheck(HttpContext context)
        {
            string checkIn = context.Request["checkIn"];
            string calendarCheck = context.Request["calendarCheck"];

            if (string.IsNullOrEmpty(checkIn))
            {
                context.Response.StatusCode = 400;
                context.Response.Write("入住日期不可為空。");
                return;
            }

            try
            {
                if (calendarCheck == "true")
                {
                    var availabilityList = GetAvailabilityForCalendar(checkIn);

                    // 將結果序列化為 JSON 格式
                    string jsonResult = JsonConvert.SerializeObject(availabilityList);
                    context.Response.ContentType = "application/json";

                    // 返回 JSON
                    context.Response.Write(jsonResult);
                }
                else
                {
                    string checkOut = context.Request["checkOut"];
                    string occupancy = context.Request["occupancy"];

                    if (string.IsNullOrEmpty(checkOut) || string.IsNullOrEmpty(occupancy))
                    {
                        context.Response.StatusCode = 400;
                        context.Response.Write("入住或退房日期或入住人數不可為空。");
                        return;
                    }

                    string availableRooms = GetAvailableRoomsWithPrices(checkIn, checkOut, occupancy);

                    context.Response.ContentType = "text/html";
                    context.Response.Write(availableRooms);
                }
            }
            catch (JsonSerializationException jsonEx)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("JSON 格式化錯誤: " + jsonEx.Message);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("錯誤: " + ex.Message);
            }
        }

        private void HandleRoomBooking(HttpContext context)
        {
            string checkIn = context.Request["checkIn"];
            string checkOut = context.Request["checkOut"];
            string rooms = context.Request["rooms"];
            string occupancy = context.Request["occupancy"];

            string bookingResult = BookRooms(checkIn, checkOut, rooms, occupancy);
            context.Response.Write(bookingResult);
        }

        private string GetAvailableRoomsWithPrices(string checkIn, string checkOut, string occupancy)
        {
            StringBuilder availableRoomsHtml = new StringBuilder();
            DateTime checkInDate = DateTime.Parse(checkIn);
            DateTime checkOutDate = DateTime.Parse(checkOut);

            string query = @"
                SELECT r.RoomId, r.Building, r.RoomType, r.MaxOccupancy 
                FROM Rooms r
                WHERE r.MaxOccupancy = @occupancy
                AND r.RoomId NOT IN (
                    SELECT RoomId 
                    FROM Bookings 
                    WHERE @checkOut > CheckInDate AND @checkIn < CheckOutDate)";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@checkIn", checkInDate);
                    cmd.Parameters.AddWithValue("@checkOut", checkOutDate);
                    cmd.Parameters.AddWithValue("@occupancy", occupancy);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        availableRoomsHtml.Append(@"
                            <h5 class='text-center' style='background-color: #f5f5f5; font-weight: bold; padding: 10px; margin: 0 auto 15px auto; width: 60%;'>
                                請選擇您要訂購的房型
                            </h5>
                        ");
                        availableRoomsHtml.Append("<div style='display: flex; flex-direction: column; align-items: center; width: 100%;'>");

                        while (reader.Read())
                        {
                            int roomId = (int)reader["RoomId"];
                            string building = reader["Building"].ToString();
                            string roomType = reader["RoomType"].ToString();
                            int maxOccupancy = (int)reader["MaxOccupancy"];
                            decimal totalPrice = CalculateTotalPrice(roomId, checkInDate, checkOutDate);

                            availableRoomsHtml.Append($@"
                                <div style='display: flex; align-items: center; margin-bottom: 5px; width: 80%; margin-left: 300px;'>
                                    <input type='checkbox' name='roomCheckbox' value='{roomId}' data-price='{(int)totalPrice}' style='transform: scale(1.2); margin-right: 10px;' />
                                    <span>房型：{building} - {roomType}（最多可入住 {maxOccupancy} 人） 總價：NT${(int)totalPrice} 元</span>
                                </div>
                                <hr style='border-top: 2px solid #ccc; width: 55%; margin: 5px auto;' />
                            ");
                        }

                        availableRoomsHtml.Append("</div>");
                    }
                }
            }

            return availableRoomsHtml.ToString();
        }

        // 新增給月曆用的查詢剩餘房間功能
        private List<AvailableRoomInfo> GetAvailabilityForCalendar(string checkIn)
        {
            DateTime checkInDate = DateTime.Parse(checkIn);
            DateTime endDate = checkInDate.AddMonths(1); // 查詢日期範圍為一個月

            var availabilityList = new List<AvailableRoomInfo>();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                conn.Open();

                // 從入住日期到一個月後的每一天查詢可用房數
                for (DateTime date = checkInDate; date < endDate; date = date.AddDays(1))
                {
                    string query = @"
                SELECT MaxOccupancy, COUNT(RoomId) AS AvailableRooms
                FROM Rooms
                WHERE RoomId NOT IN (
                    SELECT RoomId
                    FROM Bookings
                    WHERE @date >= CheckInDate AND @date < CheckOutDate)
                    GROUP BY MaxOccupancy";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@date", date);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            int twoPersonRooms = 0;
                            int threePersonRooms = 0;

                            while (reader.Read())
                            {
                                int maxOccupancy = Convert.ToInt32(reader["MaxOccupancy"]);
                                int availableRooms = Convert.ToInt32(reader["AvailableRooms"]);

                                if (maxOccupancy == 2)
                                {
                                    twoPersonRooms = availableRooms;
                                }
                                else if (maxOccupancy == 3)
                                {
                                    threePersonRooms = availableRooms;
                                }
                            }

                            availabilityList.Add(new AvailableRoomInfo
                            {
                                Date = date.ToString("yyyy-MM-dd"),
                                TwoPersonRoomsAvailable = twoPersonRooms,
                                ThreePersonRoomsAvailable = threePersonRooms
                            });
                        }
                    }
                }
            }

            return availabilityList;
        }

        private decimal CalculateTotalPrice(int roomId, DateTime checkInDate, DateTime checkOutDate)
        {
            decimal totalPrice = 0;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                conn.Open();
                for (DateTime date = checkInDate; date < checkOutDate; date = date.AddDays(1))
                {
                    string timePeriod = GetTimePeriod(date);
                    totalPrice += GetRoomPrice(roomId, timePeriod, conn);
                }
            }

            return totalPrice;
        }

        private string GetTimePeriod(DateTime date)
        {
            DateTime newYearStart = new DateTime(2025, 1, 25);
            DateTime newYearEnd = new DateTime(2025, 2, 2);

            HashSet<DateTime> holidays = new HashSet<DateTime>
            {
                new DateTime(2025, 1, 1), new DateTime(2025, 2, 28),
                new DateTime(2025, 3, 1), new DateTime(2025, 3, 2),
                new DateTime(2025, 4, 3), new DateTime(2025, 4, 4),
                new DateTime(2025, 4, 5), new DateTime(2025, 5, 1),
                new DateTime(2025, 10, 10)
            };

            if (date >= newYearStart && date <= newYearEnd) return "NewYear";
            if (holidays.Contains(date) || date.DayOfWeek == DayOfWeek.Saturday) return "Holiday";
            return "Normal";
        }

        private decimal GetRoomPrice(int roomId, string timePeriod, SqlConnection conn)
        {
            string query = "SELECT Price FROM RoomPrices WHERE RoomId = @roomId AND TimePeriod = @timePeriod";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@roomId", roomId);
                cmd.Parameters.AddWithValue("@timePeriod", timePeriod);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return Convert.ToDecimal(reader["Price"]);
                    }
                }
            }

            return 0;
        }

        private string BookRooms(string checkIn, string checkOut, string rooms, string occupancy)
        {
            string userId = HttpContext.Current.Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                return "錯誤: 使用者尚未登入，無法進行訂房。";
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        foreach (string roomId in rooms.Split(','))
                        {
                            decimal totalPrice = CalculateTotalPrice(int.Parse(roomId), DateTime.Parse(checkIn), DateTime.Parse(checkOut));

                            string query = @"
                                INSERT INTO Bookings (RoomId, CheckInDate, CheckOutDate, Occupancy, UserId, Price, bookingTime) 
                                VALUES (@roomId, @checkIn, @checkOut, @occupancy, @userId, @price, @bookingTime)";

                            using (SqlCommand cmd = new SqlCommand(query, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@roomId", roomId);
                                cmd.Parameters.AddWithValue("@checkIn", checkIn);
                                cmd.Parameters.AddWithValue("@checkOut", checkOut);
                                cmd.Parameters.AddWithValue("@occupancy", occupancy);
                                cmd.Parameters.AddWithValue("@userId", userId);
                                cmd.Parameters.AddWithValue("@price", totalPrice);
                                cmd.Parameters.AddWithValue("@bookingTime", DateTime.Now);

                                cmd.ExecuteNonQuery();
                            }
                        }

                        transaction.Commit();
                        return "訂房成功!";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "錯誤: " + ex.Message;
                    }
                }
            }
        }

        public bool IsReusable => false;

        public class AvailableRoomInfo
        {
            public string Date { get; set; }
            public int TwoPersonRoomsAvailable { get; set; }
            public int ThreePersonRoomsAvailable { get; set; }
        }
    }
}
