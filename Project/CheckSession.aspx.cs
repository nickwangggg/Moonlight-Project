using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class CheckSession : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string userName = Session["UserName"]?.ToString();
            string permission = Session["Permission"]?.ToString();

            if (userName != null && permission != null)
            {
                Response.Write($"UserName: {userName}, Permission: {permission}");
            }
            else
            {
                Response.Write("Session is empty or not set.");
            }
        }
    }
}