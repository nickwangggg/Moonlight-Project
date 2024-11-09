using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

namespace Project.registered_user
{
    /// <summary>
    /// ResponseCheckAPI 的摘要描述
    /// </summary>
    public class ResponseCheck1 : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // 從 Web.config 獲取連線字串
            string connectionString = ConfigurationManager.ConnectionStrings["accountConnectionString"].ConnectionString;

            // 定義 SQL 查詢語句
            string query = @"
            SELECT s.custermerName, s.cost_effectiveness, s.entertainment, s.convenience, s.others, s.clean, s.initDate, s.RoomType,
                   r.custermerMessage, r.custermerPhone, r.custermerEmail, r.percent_positive
            FROM dbo.starrating s
            INNER JOIN dbo.custumerresponse r ON s.custermerName = r.custermerName"; // 假設聯結鍵為 custermerName

            // 建立 DataTable 來儲存查詢結果
            DataTable dataTable = new DataTable();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        // 填充 DataTable
                        adapter.Fill(dataTable);
                    }
                }
            }

            // 將 DataTable 轉換成 JSON 格式
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var rows = new List<Dictionary<string, object>>();
            foreach (DataRow row in dataTable.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in dataTable.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                rows.Add(dict);
            }

            // 將結果序列化並寫入回應
            context.Response.Write(serializer.Serialize(rows));
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
