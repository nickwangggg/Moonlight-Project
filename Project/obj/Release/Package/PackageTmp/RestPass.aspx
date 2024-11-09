<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="RestPass.aspx.cs" Inherits="Project.RestPass" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>   
    <style>
        .page-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f5f6f7;
            font-family: Arial, sans-serif;
        }
        .reset-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        .reset-container h5 {
            color: #333;
            font-weight: 600;
        }
        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .form-control {
            padding-left: 2.5rem;
            background-color: #f0f4f8;
        }
        .form-control::placeholder {
            color: #888;
        }
        .icon-align {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #007bff;
        }
        .custom-submit-button {
            width: 100%;
            font-size: 1.1rem;
            background: linear-gradient(to right, #f093fb, #f5576c);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            transition: background 0.3s ease;
        }
        .custom-submit-button:hover {
            background: linear-gradient(to right, #f5576c, #f093fb);
        }
        .error-message {
            color: red;
            font-size: 0.9rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Session 檢查顯示區域 -->
    <asp:Label ID="sessionCheckLabel" runat="server" CssClass="h6"></asp:Label>

    <div class="page-container">
        <div class="reset-container">
            <asp:Label ID="emailLabel" runat="server" CssClass="h6"></asp:Label>
            <hr class="my-4" style="width: 100%; margin: 20px auto;">
            <form id="resetPasswordForm">
                <div class="form-group">
                    <i class="icon-align fas fa-lock"></i>
                    <input type="password" class="form-control form-control-lg" id="newPassword" placeholder="新密碼">
                </div>
                <div class="form-group">
                    <i class="icon-align fas fa-lock"></i>
                    <input type="password" class="form-control form-control-lg" id="confirmPassword" placeholder="確認新密碼">
                </div>
                <button type="submit" class="btn custom-submit-button">送出</button>
            </form>
            <label id="passwordError" class="error-message mt-3"></label>
            <label id="confirmPasswordError" class="error-message mt-3"></label>
            <asp:Literal ID="UserEmailScriptLiteral" runat="server"></asp:Literal>
        </div>
    </div>

<script>
    // 從 URL 中取得 token
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        const results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }

    // 取得 token
    const token = getUrlParameter('token');

    $(document).ready(function () {
        console.log("userEmail:", userEmail);
        console.log("token:", token); // 檢查 token 是否正確取得

        $("#resetPasswordForm").on("submit", function (e) {
            e.preventDefault();

            // 重置錯誤訊息
            $("#passwordError").text("");
            $("#confirmPasswordError").text("");

            const newPassword = $("#newPassword").val().trim();
            const confirmPassword = $("#confirmPassword").val().trim();
            let passwordErrorMessage = "";
            let isValid = true;

            // 驗證新密碼
            if (!newPassword) {
                passwordErrorMessage = "請輸入新密碼";
                isValid = false;
            } else if (newPassword.length < 6) {
                passwordErrorMessage = "密碼長度至少為 6 個字元";
                isValid = false;
            } else if (!/[A-Z]/.test(newPassword)) {
                passwordErrorMessage = "密碼必須包含至少一個大寫字母";
                isValid = false;
            } else if (!/[a-z]/.test(newPassword)) {
                passwordErrorMessage = "密碼必須包含至少一個小寫字母";
                isValid = false;
            } else if (!/[0-9]/.test(newPassword)) {
                passwordErrorMessage = "密碼必須包含至少一個數字";
                isValid = false;
            }

            if (passwordErrorMessage) {
                $("#passwordError").text(passwordErrorMessage);
                console.log("Password validation failed:", passwordErrorMessage);
            } else {
                $("#passwordError").text("");
            }

            // 驗證確認密碼
            if (newPassword !== confirmPassword) {
                $("#confirmPasswordError").text("新密碼和確認密碼不匹配");
                console.log("Confirm password validation failed: 密碼不匹配");
                isValid = false;
            } else {
                $("#confirmPasswordError").text("");
            }

            // 如果驗證通過，發送新密碼和 token 到後端進行重設
            if (isValid) {
                console.log("Sending AJAX request with email:", userEmail, "password:", newPassword, "and token:", token);

                $.ajax({
                    url: "ResetPasswordHandler.ashx",
                    type: "POST",
                    data: { email: userEmail, password: newPassword, token: token }, // 傳遞 email、password 和 token
                    success: function (response) {
                        console.log("Server response:", response);
                        if (response === "PasswordResetSuccess") {
                            $("#passwordError").text("密碼已成功重設！");
                            // 2 秒後跳轉到 login.aspx
                            setTimeout(function () {
                                window.location.href = "login.aspx";
                            }, 1000);
                        } else if (response === "UserNotFound") {
                            $("#passwordError").text("找不到用戶，請重新確認您的電子郵件。");
                        } else if (response === "InvalidRequest") {
                            $("#passwordError").text("請求無效，請重試。");
                        } else if (response === "TokenInvalidOrExpired") {
                            $("#passwordError").text("Token 無效或已過期，請重新申請重設密碼。");
                        } else {
                            $("#passwordError").text(response);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.log("AJAX request failed - Status:", status, "Error:", error);
                        $("#passwordError").text("發生錯誤，請稍後再試！");
                    }
                });
            }
        });
    });
</script>

</asp:Content>
