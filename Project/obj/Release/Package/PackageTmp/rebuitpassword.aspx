<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="rebuitpassword.aspx.cs" Inherits="Project.rebuitpassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        .error-message {
            color: red;
            font-size: 0.9rem; /* 調整字型大小 */
        }
        .custom-submit-button {
            width: 100%;
            font-size: 1.2rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="shadow p-0 bg-body rounded custom-login-form">
            <div class="d-flex h-100">
                <div class="left-image-container">
                    <img src='<%= ResolveUrl("~/Content/Images/light.png") %>' alt="Sign Up Image" class="img-fluid full-height" />
                </div>
                <div class="right-content-container p-4 d-flex flex-column justify-content-center">
                    <h5 class="text-danger">請輸入信箱以發送重設密碼連結</h5>
                    <div class="divider"></div>
                    <form id="resetForm" novalidate> <!-- 移除內建檢查 -->
                        <div class="form-group mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <img src='<%= ResolveUrl("~/Content/Images/email.png") %>' alt="Email Icon" class="icon-align">
                                <input type="email" class="form-control form-control-lg email-input flex-grow-1" id="resetEmail" placeholder="信箱">
                            </div>
                            <label id="emailError" class="error-message"></label>
                        </div>
                        <button type="submit" class="btn btn-primary custom-submit-button">送出</button>
                    </form>
                    <label id="backendResponse" class="error-message mt-3"></label>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            $("#resetForm").on("submit", function (e) {
                e.preventDefault();
                let isValid = true;

                $("#emailError").text("");
                $("#backendResponse").text("");  // 清空之前的後端回應訊息

                const email = $("#resetEmail").val().trim();
                let emailErrorMessage = "";

                if (email === "") {
                    emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入信箱";
                    isValid = false;
                } else if (!email.includes("@")) {
                    emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;缺少 @ 符號";
                    isValid = false;
                } else {
                    const userDomain = email.split("@");
                    if (userDomain.length !== 2) {
                        emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電子郵件信箱只能有一個 @ 符號";
                        isValid = false;
                    } else {
                        const [user, domain] = userDomain;

                        if (user === "") {
                            emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@前使用者帳號部分不可為空";
                            isValid = false;
                        } else if (!/^[a-zA-Z0-9_.]+$/.test(user)) {
                            emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@前使用者帳號部分格式不正確";
                            isValid = false;
                        } else if (!domain.includes(".")) {
                            emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分缺少 . 符號";
                            isValid = false;
                        } else {
                            const domainParts = domain.split(".");

                            if (domainParts.length < 2) {
                                emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分結構不正確";
                                isValid = false;
                            } else if (!domainParts.every(part => /^[a-zA-Z0-9-]+$/.test(part))) {
                                emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分格式不正確";
                                isValid = false;
                            } else {
                                const tld = domainParts[domainParts.length - 1];
                                if (!/^[a-zA-Z]{2,4}$/.test(tld)) {
                                    emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;頂級域名格式不正確";
                                    isValid = false;
                                }
                            }
                        }
                    }
                }

                if (emailErrorMessage) {
                    $("#emailError").html(emailErrorMessage);
                }

                if (isValid) {
                    // 使用 AJAX 將電子郵件傳送到 ResetPassword.ashx
                    $.ajax({
                        url: "ResetPassword.ashx",
                        type: "POST",
                        data: { email: email },
                        success: function (response) {
                            // 顯示後端回應訊息
                            $("#backendResponse").html(response);
                        },
                        error: function () {
                            $("#backendResponse").html("發生錯誤，請稍後再試！");
                        }
                    });
                }
            });
        });
    </script>
</asp:Content>

