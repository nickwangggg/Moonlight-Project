<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="rebuitpassword.aspx.cs" Inherits="Project.rebuitpassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 引入 Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/login.css") %>' />
    
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
            margin-top: 10px !important; /* 縮小上方距離 */
            margin-bottom: 30px !important; /* 保持下方距離，便於表單與水平線之間有適當的空間 */
        }

        /* 自定義的送出按鈕 */
        .custom-submit-button {
            width: 100%;
            font-size: 1.2rem;
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
                    <img src='<%= ResolveUrl("~/Content/Images/light.png") %>' alt="Sign Up Image" class="img-fluid full-height" />
                </div>

                <!-- 右邊註冊資訊 -->
                <div class="right-content-container p-4 d-flex flex-column justify-content-center">
                    <!-- SIGN UP 標題，字體變小 -->
                    <h5 class="text-danger">請輸入信箱以發送重設密碼連結</h5>
                    <!-- 添加水平線 -->
                    <div class="divider"></div>
                    <!-- 註冊表單 -->
                    <form>
                        <!-- 信箱欄位 -->
                        <div class="form-group mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <img src='<%= ResolveUrl("~/Content/Images/email.png") %>' alt="Email Icon" class="icon-align">
                                <input type="email" class="form-control form-control-lg email-input flex-grow-1" id="resetEmail" placeholder="信箱">
                            </div>
                        </div>
                        <!-- 送出按鈕 -->
                        <button type="submit" class="btn btn-primary custom-submit-button">送出</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
