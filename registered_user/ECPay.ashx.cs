using System;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.Collections.Generic;
using System.Linq;

namespace Project.registered_user
{
    public class ECPay : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                // 從前端接收價格和房間名稱資訊
                string price = context.Request.Form["amount"];
                string roomName = context.Request.Form["roomName"];

                if (string.IsNullOrEmpty(price) || string.IsNullOrEmpty(roomName))
                {
                    context.Response.Write($"Received Price: {price}, Room Name: {roomName}");
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"error\": \"Price or room name is missing.\"}");
                    return;
                }

                // 產生訂單的 URL
                string paymentUrl = GenerateECPayPaymentUrl(price, roomName);

                // 返回包含付款 URL 的 JSON 格式
                string jsonResponse = $"{{\"url\": \"{paymentUrl}\"}}";
                context.Response.Write(jsonResponse);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write($"{{\"error\": \"Internal server error: {ex.Message}\"}}");
            }
        }

        private string GenerateECPayPaymentUrl(string price, string roomName)
        {
            // 固定參數
            string merchantID = "3002607";
            string hashKey = "pwFHCqoQZGmho4w6";
            string hashIV = "EkRm7iFT261dpevs";
            string returnUrl = "https://dd65-61-57-67-234.ngrok-free.app/Project/registered_user/ECPayNotification.ashx";
            string tradeNo = "ORDER" + DateTime.Now.Ticks;
            string tradeDate = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
            string tradeDesc = "RoomOder" + roomName;
            string itemName = roomName;

            // 構建參數字典
            var parameters = new Dictionary<string, string>
            {
                { "MerchantID", merchantID },
                { "MerchantTradeNo", tradeNo },
                { "MerchantTradeDate", tradeDate },
                { "PaymentType", "aio" },
                { "TotalAmount", price },
                { "TradeDesc", tradeDesc },
                { "ItemName", itemName },
                { "ReturnURL", returnUrl },
                { "ChoosePayment", "Credit" },
                { "EncryptType", "1" }
            };

            // 計算 CheckMacValue
            string checkMacValue = GenerateCheckMacValue(parameters, hashKey, hashIV);
            parameters.Add("CheckMacValue", checkMacValue);

            string baseUrl = "https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5";
            string queryString = string.Join("&", parameters.Select(p => $"{p.Key}={p.Value}"));

            return $"{baseUrl}?{queryString}";
        }

        private string GenerateCheckMacValue(Dictionary<string, string> parameters, string hashKey, string hashIV)
        {
            // 按鍵名進行排序
            var sortedParameters = parameters.OrderBy(p => p.Key).Select(p => $"{p.Key}={p.Value}").ToList();

            // 構建待加密字串，使用原始形式
            string rawData = $"HashKey={hashKey}&{string.Join("&", sortedParameters)}&HashIV={hashIV}";

            // 計算 MD5 雜湊值
            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(Encoding.UTF8.GetBytes(rawData));
                return BitConverter.ToString(hash).Replace("-", "").ToUpper();
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
