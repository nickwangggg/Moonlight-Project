using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["returnUrl"] != null)
            {
                // 顯示彈出視窗，告知使用者必須先登入
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('請先登入以繼續訪問該頁面。');", true);
            }
        }
    }
}