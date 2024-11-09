<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Project.register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 引入 Bootstrap CSS 和 jQuery -->
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
        width: 100%;
        margin-top: -10px !important; /* 縮小上方距離 */
        margin-bottom: 30px !important; /* 保持下方距離，便於表單與水平線之間有適當的空間 */
    }

    /* 調整輸入框和錯誤訊息之間的距離 */
    .form-group {
        margin-bottom: 0rem; /* 增加表單組件之間的距離，確保每個輸入框之間的距離更大 */
    }

    .form-group.mb-0 {
        margin-bottom: -15px !important; /* 強制應用負邊距 */
    }

    /* 縮小錯誤訊息與輸入框之間的距離，確保錯誤訊息靠近輸入框 */
    label.error {
        color: red;
        font-size: 0.9rem;
        display: block;
        height: 2px; /* 固定高度，防止閃爍 */
        margin-top: -7px;
        margin-bottom: 15px; /* 確保與輸入框緊貼 */
        line-height: 10px; /* 讓錯誤訊息垂直居中 */
    }

    /* 確保輸入框本身沒有額外的下邊距 */
    .form-control {
        margin-bottom: 0; /* 保證輸入框沒有額外的下邊距 */
        padding: 0.5rem; /* 調整內邊距，使輸入框更緊湊 */
    }

    form .form-control.wide-input {
        width: 400px !important; /* 強制設定寬度 */
        max-width: 100%;
    }

    .wide-input {
        width: 400px !important; /* 強制設定寬度 */
    }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="form1" runat="server">
    <!-- 使用 Flexbox 讓整個內容居中對齊 -->
    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="shadow p-0 bg-body rounded custom-login-form">
            <div class="d-flex h-100">
                <!-- 左邊圖片 -->
                <div class="left-image-container">
                    <img src='<%= ResolveUrl("~/Content/Images/light.png") %>' alt="Sign Up Image" class="img-fluid full-height" />
                </div>

                <!-- 右邊註冊資訊 -->
                <div class="right-content-container p-4 d-flex flex-column justify-content-center">
                    <!-- SIGN UP 標題，完全移除底部間距 -->
                    <h3 class="text-center mb-4">社群註冊</h3>
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
                    <!-- 註冊表單 -->
                    <div class="form-group mb-0">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/person.png") %>' alt="User Icon" class="icon-align">
                            <div class="d-flex flex-grow-1 gap-2">
                                <input type="text" class="form-control" id="firstName" placeholder="名" autocomplete="on">
                                <input type="text" class="form-control" id="lastName" placeholder="姓" autocomplete="on">
                            </div>
                        </div>
                        <label id="nameError" class="error" style="height:20px;"></label> <!-- 預留空間 -->
                    </div>
                    <!-- 使用者名稱 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/id.png") %>' alt="ID Icon" class="icon-align">
                            <input type="text" class="form-control wide-input" id="userid" placeholder="輸入使用者名稱" autocomplete="on">
                        </div>
                        <label id="useridError" class="error"></label><!-- 預留空間 -->
                    </div>

                    <!-- 身分證號 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/id_card.png") %>' alt="ID Card Icon" class="icon-align">
                            <input type="text" class="form-control wide-input" id="identityNumber" placeholder="身分證號" autocomplete="off">
                        </div>
                        <label id="identityError" class="error"></label>
                    </div>

                    <!-- 電話號碼 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/phone.png") %>' alt="Phone Icon" class="icon-align">
                            <input type="tel" class="form-control wide-input" id="phoneNumber" placeholder="電話號碼" autocomplete="off">
                        </div>
                        <label id="phoneError" class="error"></label>
                    </div>

                    <!-- 信箱 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/email.png") %>' alt="Email Icon" class="icon-align">
                            <input type="email" class="form-control wide-input" id="email" placeholder="信箱" autocomplete="off">
                        </div>
                        <label id="emailError" class="error"></label>
                    </div>

                    <!-- 密碼 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/password.png") %>' alt="Password Icon" class="icon-align">
                            <input type="password" class="form-control wide-input" id="password" placeholder="密碼至少6個字元(需含一個大小寫字母及一個數字)" autocomplete="off">
                        </div>
                        <label id="passwordError" class="error"></label>
                    </div>

                    <!-- 確認密碼 -->
                    <div class="form-group">
                        <div class="d-flex align-items-center gap-2">
                            <img src='<%= ResolveUrl("~/Content/Images/passwordrecheck.png") %>' alt="Password Recheck Icon" class="icon-align">
                            <input type="password" class="form-control wide-input" id="confirmPassword" placeholder="確認密碼" autocomplete="off">
                        </div>
                        <label id="confirmPasswordError" class="error"></label>
                    </div>
                    <div class="form-check mb-4">
                        <input type="checkbox" class="form-check-input" id="agreeToTerms">
                        <label class="form-check-label" for="agreeToTerms">
                            我願意透過信箱接收最新消息與優惠通知
                        </label>
                        <label id="termsError" class="error"></label>
                    </div>
                    <button type="submit" class="btn btn-primary custom-sign-up-button">註冊</button>
                </div>
            </div>
        </div>
    </div>
</form>
<!-- jQuery 驗證程式碼 -->
<script>
    $(document).ready(function () {
        $("form").on("submit", function (event) {
            event.preventDefault(); // 阻止表單默認提交
            let isValid = true;

            // 清除先前的錯誤訊息
            $("label.error").text("");

            // 驗證名字與姓氏
            const firstName = $("#firstName").val().trim();
            const lastName = $("#lastName").val().trim();
            if (firstName === "" || lastName === "") {
                $("#nameError").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入名字與姓氏");
                isValid = false;
            }

            // 驗證使用者名稱
            const userid = $("#userid").val().trim();
            if (userid === "") {
                $("#useridError").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入使用者名稱");
                isValid = false;
            }

            // 驗證身分證號
            const identityNumber = $("#identityNumber").val().trim();
            let identityErrorMessage = "";

            if (identityNumber === "") {
                identityErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入身分證號";
            } else if (identityNumber.length !== 10) {
                identityErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身分證號必須為 10 位數";
            } else if (!/^[A-Z]/.test(identityNumber[0])) {
                identityErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身分證號的第一個字必須為大寫字母";
            } else if (!/^[1-2]$/.test(identityNumber[1])) {
                identityErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身分證號的第二個字必須為 1 或 2";
            } else if (!/^\d{8}$/.test(identityNumber.slice(2))) {
                identityErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身分證號的後八位必須為數字";
            }

            if (identityErrorMessage !== "") {
                $("#identityError").html(identityErrorMessage);
                isValid = false;
            } else {
                $("#identityError").html("");
            }

            // 驗證電話號碼
            const phoneNumber = $("#phoneNumber").val().trim();
            let phoneErrorMessage = "";

            if (phoneNumber === "") {
                phoneErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入電話號碼";
            } else if (phoneNumber.length !== 10) {
                phoneErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電話號碼必須為 10 位數";
            } else if (!/^\d{2}$/.test(phoneNumber.slice(0, 2)) || phoneNumber.slice(0, 2) !== "09") {
                phoneErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電話號碼前兩個必須為數字且為 09 開頭";
            } else if (!/^\d{10}$/.test(phoneNumber)) {
                phoneErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電話號碼必需都為數字";
            }

            if (phoneErrorMessage !== "") {
                $("#phoneError").html(phoneErrorMessage);
                isValid = false;
            } else {
                $("#phoneError").html("");
            }

            // 驗證信箱
            const email = $("#email").val().trim();
            let emailErrorMessage = "";

            if (email === "") {
                emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入信箱";
            } else if (!email.includes("@")) {
                emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;缺少 @ 符號";
            } else {
                const userDomain = email.split("@");
                if (userDomain.length !== 2) {
                    emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電子郵件信箱只能有一個 @ 符號";
                } else {
                    const [user, domain] = userDomain;

                    if (user === "") {
                        emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@前使用者帳號部分不可為空";
                    } else if (!/^[a-zA-Z0-9_.]+$/.test(user)) {
                        emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@前使用者帳號部分格式不正確";
                    } else if (!domain.includes(".")) {
                        emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分缺少 . 符號";
                    } else {
                        const domainParts = domain.split(".");

                        if (domainParts.length < 2) {
                            emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分結構不正確";
                        } else if (!domainParts.every(part => /^[a-zA-Z0-9-]+$/.test(part))) {
                            emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主機域名部分格式不正確";
                        } else {
                            const tld = domainParts[domainParts.length - 1];
                            if (!/^[a-zA-Z]{2,4}$/.test(tld)) {
                                emailErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;頂級域名格式不正確";
                            }
                        }
                    }
                }
            }

            if (emailErrorMessage !== "") {
                $("#emailError").html(emailErrorMessage);
                isValid = false;
            } else {
                $("#emailError").html("");
            }

            // 驗證密碼
            const password = $("#password").val().trim();
            let passwordErrorMessage = "";

            if (password === "") {
                passwordErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請輸入密碼";
            } else if (password.length < 6) {
                passwordErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密碼必須至少 6 個字元";
            } else if (!/[A-Z]/.test(password)) {
                passwordErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密碼必須包含至少一個大寫字母";
            } else if (!/[a-z]/.test(password)) {
                passwordErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密碼必須包含至少一個小寫字母";
            } else if (!/[0-9]/.test(password)) {
                passwordErrorMessage = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密碼必須包含至少一個數字";
            }

            if (passwordErrorMessage !== "") {
                $("#passwordError").html(passwordErrorMessage);
                isValid = false;
            } else {
                $("#passwordError").html("");
            }

            // 驗證確認密碼
            const confirmPassword = $("#confirmPassword").val().trim();
            if (password !== confirmPassword) {
                $("#confirmPasswordError").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密碼與確認密碼不一致");
                isValid = false;
            }

            // 如果驗證成功，發送 AJAX 請求
            if (isValid) {
                $(".custom-sign-up-button").prop("disabled", true); // 禁用按鈕，防止重複提交
                $.ajax({
                    url: '<%= ResolveUrl("~/SaveUserData.ashx") %>',  // 修正URL部分
                    type: 'POST',
                    data: {
                        firstName: firstName,
                        lastName: lastName,
                        userid: userid,
                        identityNumber: identityNumber,
                        phoneNumber: phoneNumber,
                        email: email,
                        password: password,
                        agreeToTerms: $("#agreeToTerms").is(":checked")
                    },
                    success: function (response) {
                        if (response === "Success") {
                            alert("註冊成功！");
                            $("form")[0].reset(); // 重置表單
                            window.location.href = '<%= ResolveUrl("~/login.aspx") %>'; // 跳轉到 login.aspx 頁面
                        } else if (response === "UsernameExists") {
                            $("#useridError").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用者名稱已存在，請選擇其他名稱");
                        } else if (response === "EmailExists") {
                            $("#emailError").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;電子郵件已存在，請選擇其他電子郵件");
                        } else {
                            alert("註冊失敗：" + response);
                        }
                        $(".custom-sign-up-button").prop("disabled", false); // 重新啟用按鈕
                    },
                    error: function (xhr) {
                        let errorMessage = "發生錯誤，請稍後重試！";
                        if (xhr.status === 500) {
                            errorMessage = "伺服器內部錯誤，請稍後再試。";
                        }
                        alert(errorMessage);
                        $(".custom-sign-up-button").prop("disabled", false); // 重新啟用按鈕
                    }
                });
            }
        });
    });
</script>
</asp:Content>
