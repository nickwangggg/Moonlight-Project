using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project.registered_user
{
    public partial class booking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    // 檢查 Session["UserName"] 是否存在
            //    if (Session["UserName"] != null)
            //    {
            //        string userId = Session["UserName"].ToString();
            //        Response.Write($"使用者 ID: {userId} 已儲存於 Session 中。");
            //        Response.Write($"Session UserName: {Session["UserName"]}");
            //    }
            //    else
            //    {
            //        Response.Write("Session 中沒有 UserName，使用者尚未登入。");
            //    }
            //}
        }

        protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
    }
}