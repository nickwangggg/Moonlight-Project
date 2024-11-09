using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

namespace Project
{
    public partial class CustermerService : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 初始化頁面內容（如果有需要）
            }
        }

        // 按鈕點擊事件處理方法
        protected void SendFeedbackButton_Click(object sender, EventArgs e)
        {
            // 實現發送反饋郵件的邏輯
        }
    }
}