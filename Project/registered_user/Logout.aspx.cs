using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 清除表單驗證票券
            FormsAuthentication.SignOut();

            // 清除所有使用者的 session 資料
            Session.Abandon();

            // 可選，清除所有的 session cookie
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            }

            // 重導向到登入頁面
            Response.Redirect("~/homepage.aspx");
        }
    }
}