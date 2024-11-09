<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Project.login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 引入 Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/login.css") %>' />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        .icon-align {
            height: 20px;
            width: 20px;
            display: inline-block;
            vertical-align: middle;
            margin-top: -15px;
        }

        /* 確保社群註冊與下方元素距離縮小 */
        .social-login-section {
            margin-bottom: 10px !important; /* 使用 !important 覆蓋 Bootstrap 的間距，縮小到 10px */
        }

        /* 設置水平線距離上方的距離 */
        .divider {
            border-top: 1px solid #ccc;
            width: 70%;
            margin-top: -10px !important; /* 縮小上方距離 */
            margin-bottom: 30px !important; /* 保持下方距離，便於表單與水平線之間有適當的空間 */
        }

        /* 登入狀態的 label 設置 */
        #loginStatus {
            color: red;
            display: none; /* 預設隱藏 */
            margin-top: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- 使用 Flexbox 讓整個內容居中對齊 -->
    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="shadow p-0 bg-body rounded custom-login-form">
            <div class="d-flex h-100">
                <!-- 左邊圖片 -->
                <div class="left-image-container">
                    <img src='<%= ResolveUrl("~/Content/Images/light.png") %>' alt="Login Image" class="img-fluid full-height" />
                </div>

                <!-- 右邊登入資訊 -->
                <div class="right-content-container p-4 d-flex flex-column justify-content-center">
                    <!-- SIGN IN 標題，完全移除底部間距 -->
                    <h3 class="text-center mb-4">社群登入</h3>
                    <div class="mb-3 text-center d-flex justify-content-center align-items-center social-login-section">
                        <!-- Facebook 註冊圖片 -->
                        <a href="https://www.facebook.com/login" target="_blank">
                            <img src='<%= ResolveUrl("~/Content/Images/facebook.png") %>' alt="Facebook Sign Up" class="social-login-icon me-3" />
                        </a>
                        <!-- Google 註冊圖片 -->
                        <a href="https://accounts.google.com/signin" target="_blank">
                            <img src='<%= ResolveUrl("~/Content/Images/google.png") %>' alt="Google Sign Up" class="social-login-icon" />
                        </a>
                    </div>
                    <!-- 添加水平線 -->
                    <div class="divider"></div>

                    <!-- 登入表單 -->
                    <form id="loginForm" runat="server">
                        <!-- 加入 ScriptManager -->
                        <asp:ScriptManager runat="server" />

                        <!-- 信箱或使用者帳號欄位 -->
                        <div class="form-group">
                            <label for="email" class="form-label">信箱或使用者帳號</label>
                            <input type="text" class="form-control email-input" id="email" placeholder="Enter your email or your ID" autocomplete="off">
                        </div>

                        <!-- 密碼欄位 -->
                        <div class="form-group">
                            <label for="password" class="form-label">密碼</label>
                            <input type="password" class="form-control password-input" id="password" placeholder="Enter your password" autocomplete="off">
                        </div>

                        <!-- 登入狀態的label -->
                        <div class="form-group">
                            <label id="loginStatus">登入狀態</label> <!-- 預設隱藏，顯示時可以修改文字 -->
                        </div>

                        <!-- 登入按鈕 -->
                        <button type="submit" class="btn btn-primary custom-login-button">登入</button>
                    </form>
                    <!-- 忘記密碼的連結 -->
                    <div class="mt-3 text-center">
                        <a href="rebuitpassword.aspx">忘記密碼？</a>
                    </div>
                    <!-- 註冊帳號的連結 -->
                    <div class="mt-2 text-center">
                        還不是會員？<a href="register.aspx">註冊帳號</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery AJAX 登入邏輯 -->
    <script>
        $(document).ready(function () {
            $("#loginForm").on("submit", function (event) {
                event.preventDefault();  // 防止表單默認提交

                // 獲取表單數據
                let emailOrUserid = $("#email").val().trim();
                let password = $("#password").val().trim();

                // 簡單檢查用戶輸入是否為空
                if (emailOrUserid === "" || password === "") {
                    $("#loginStatus").text("請輸入信箱或使用者帳號和密碼").show();
                    return;
                }

                // AJAX 發送到後端進行登入驗證
                $.ajax({
                    url: '<%= ResolveUrl("~/LoginHandler.ashx") %>',  // 指向 .ashx 處理程序
                    type: 'POST',
                    data: {
                        emailOrUserid: emailOrUserid,
                        password: password
                    },
                    success: function (response) {
                        if (response === "Success") {
                            $("#loginStatus").hide();
                            window.location.href = '<%= ResolveUrl("~/homepage.aspx") %>';  // 登入成功後跳轉
                        } else {
                            $("#loginStatus").text("帳號或密碼錯誤").show();  // 顯示錯誤訊息
                        }
                    },
                    error: function () {
                        $("#loginStatus").text("伺服器錯誤，請稍後重試").show();
                    }
                });
            });
        });
    </script>
</asp:Content>