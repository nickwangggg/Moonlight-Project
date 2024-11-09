<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Project.registered_user.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>付款系統</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .content-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin: 0 5%;
        }

        .left-section, .right-section {
            width: 48%;
        }

        .img-container {
            width: 100%;
            margin-bottom: 20px;
        }

        .img-container img {
            width: 100%;
            height: auto;
        }

        .form-section {
            margin-bottom: 20px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }

        .booking-info {
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }

        .card-header {
            background-color: #E6F4E6;
            font-weight: bold;
        }

        .card {
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="row">
            <!-- 房間照片 -->
            <div class="col-md-7">
                <!-- 調整圖片區域大小 -->
                <img id="roomImage" src="" alt="房間圖片" class="img-fluid" style="max-width: 100%; height: auto;" />
                <!-- 訂房資訊 -->
                <div class="card mt-4" style="background-color: #E6F4E6;">
                    <div class="card-header bg-success text-white">訂房資訊</div>
                    <!-- 淺綠色背景和標題框格 -->
                    <div class="card-body">
                        <p><strong>房間編號：</strong><span id="roomId"></span></p>
                        <p><strong>房間名稱：</strong><span id="roomName"></span></p>
                        <p><strong>入住日期：</strong><span id="checkInDate"></span></p>
                        <p><strong>退房日期：</strong><span id="checkOutDate"></span></p>
                        <p><strong>入住人數：</strong><span id="occupancy"></span></p>
                        <p><strong>用戶ID：</strong><span id="userId"></span></p>
                        <p><strong>價格：</strong><span id="price"></span></p>
                        <p><strong>訂房時間：</strong><span id="bookingTime"></span></p>
                    </div>
                </div>
            </div>

            <!-- 右側的付款和聯絡資訊 -->
            <div class="col-md-5">
                <!-- 調整右側顯示區域大小 -->
                <!-- 付款和聯絡資訊 -->
                <div class="card mb-4" style="background-color: #E6F4E6;">
                    <div class="card-header bg-success text-white">付款和聯絡資訊</div>
                    <!-- 淺綠色背景 -->
                    <div class="card-body">
                        <form id="contactForm">
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="lastName" class="form-label">姓</label>
                                    <input type="text" class="form-control" id="lastName" required>
                                </div>
                                <div class="col">
                                    <label for="firstName" class="form-label">名</label>
                                    <input type="text" class="form-control" id="firstName" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="phone" class="form-label">聯絡電話</label>
                                    <input type="text" class="form-control" id="phone" required>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 信用卡資訊 -->
                <div class="card mb-4" style="background-color: #E6F4E6;">
                    <div class="card-header bg-success text-white">信用卡資訊</div>
                    <!-- 淺綠色背景 -->
                    <div class="card-body">
                        <form id="paymentForm">
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">卡片號碼</label>
                                <input type="text" class="form-control" id="cardNumber" required>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="expiryDate" class="form-label">到期日</label>
                                    <input type="text" class="form-control" id="expiryDate" placeholder="MM/YY" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="text" class="form-control" id="cvv" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="cardHolderName" class="form-label">持卡人姓名</label>
                                <input type="text" class="form-control" id="cardHolderName" required>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- 確認付款按鈕 -->
        <div class="text-center mt-4">
            <button type="button" id="confirmPaymentBtn" class="btn btn-primary">確認付款</button>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            var userId = '<%= Session["UserName"] %>';

            console.log("UserId: " + userId);  // 檢查是否正確顯示 UserId

            if (!userId || userId.trim() === "" || userId === "null") {
                alert('未找到有效的用戶 ID');
                return;
            }

            $.ajax({
                url: './Payment.ashx',
                type: 'POST',
                data: { userId: userId },
                contentType: 'application/x-www-form-urlencoded',
                success: function (data) {
                    $('#roomId').text(data.RoomId);
                    $('#checkInDate').text(data.CheckInDate);
                    $('#checkOutDate').text(data.CheckOutDate);
                    $('#occupancy').text(data.Occupancy);
                    $('#userId').text(data.UserId);
                    $('#price').text(data.Price);
                    $('#bookingTime').text(data.BookingTime);
                    $('#roomName').text(data.RoomType);

                    let imageUrl = "";
                    switch (data.RoomType) {
                        case "香水百合_2人房":
                        case "香水百合_3人房":
                            imageUrl = '<%= ResolveUrl("~/Content/Images/rooma1.jpg") %>';
                            break;
                        case "天使薔薇_2人房":
                        case "天使薔薇_3人房":
                            imageUrl = '<%= ResolveUrl("~/Content/Images/roomc2.jpg") %>';
                            break;
                        case "向日葵_2人房":
                        case "向日葵_3人房":
                            imageUrl = '<%= ResolveUrl("~/Content/Images/roomb1.jpg") %>';
                            break;
                        case "蝴蝶蘭_2人房":
                        case "蝴蝶蘭_3人房":
                            imageUrl = '<%= ResolveUrl("~/Content/Images/roomd1.jpg") %>';
                            break;
                        default:
                            imageUrl = '<%= ResolveUrl("~/Content/Images/default_room.jpg") %>';
                            break;
                    }
                    $("#roomImage").attr("src", imageUrl);

                    console.log("訂房資料：", data);
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 錯誤: ', xhr.status, error);
                    alert('無法載入訂房資訊: ' + xhr.responseText);
                }
            });

            // 信用卡號輸入監聽與格式化
            $('#cardNumber').on('blur', function () {
                var input = $(this).val();

                // 移除所有非數位字元
                input = input.replace(/\D/g, '');

                // 限制輸入最多16個字元
                if (input.length > 16) {
                    input = input.substring(0, 16);
                }

                // 當輸入的字數是16時進行格式化
                if (input.length === 16) {
                    var formattedInput = input.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '$1 $2 $3 $4');
                    $(this).val(formattedInput);
                } else {
                    $(this).val(input); // 如果不夠16字元就直接顯示輸入的內容
                }
            });

            // 信用卡到期日輸入監聽與格式化
            $('#expiryDate').on('input', function (e) {
                var input = $(this).val();

                // 移除非數位字元
                input = input.replace(/\D/g, '');

                // 限制輸入為4個字元
                if (input.length > 4) {
                    input = input.slice(0, 4);
                }

                // 當輸入達到4個字元時，自動格式化為MM/YY格式
                if (input.length === 4) {
                    $(this).val(input.slice(0, 2) + '/' + input.slice(2));
                }
            });

            // 安全碼輸入監聽與格式化
            $('#cvv').on('input', function () {
                var input = $(this).val();

                // 移除非數字字符
                input = input.replace(/\D/g, '');

                // 限制輸入為3個字元
                if (input.length > 3) {
                    input = input.slice(0, 3);
                }

                $(this).val(input);
            });

            // 聯絡電話輸入監聽與格式化
            $('#phone').on('blur', function () {
                var input = $(this).val();

                // 移除所有非數位字元
                input = input.replace(/\D/g, '');

                // 限制輸入最多10個字元
                if (input.length > 10) {
                    input = input.substring(0, 10);
                }

                // 當輸入的字數是10時進行格式化
                if (input.length === 10) {
                    var formattedInput = input.replace(/(\d{4})(\d{3})(\d{3})/, '$1-$2-$3');
                    $(this).val(formattedInput);
                } else {
                    $(this).val(input); // 如果不夠10字元就直接顯示輸入的內容
                }
            });

            // 確認付款按鈕點擊事件
            $('#confirmPaymentBtn').click(function () {
                // 獲取表單輸入值
                var lastName = $('#lastName').val().trim();
                var firstName = $('#firstName').val().trim();
                var phone = $('#phone').val().trim();
                var cardNumber = $('#cardNumber').val().trim();
                var expiryDate = $('#expiryDate').val().trim();
                var cvv = $('#cvv').val().trim();
                var cardHolderName = $('#cardHolderName').val().trim();
                var roomName = $('#roomName').text();
                var amount = $('#price').text();
                console.log("Sending Amount: ", amount);
                console.log("Sending Room Name: ", roomName);

                // 檢查每個必填欄位是否都有值
                if (!lastName || !firstName || !phone || !cardNumber || !expiryDate || !cvv || !cardHolderName) {
                    // 如果有一個或多個欄位未填寫，顯示錯誤提示
                    alert('付款資料未填寫完整');
                    return;
                }

                // 進一步檢查卡號和其他輸入格式是否正確
                if (cardNumber.length !== 19) {  // 因為格式化後卡號有空格共19字元
                    alert('信用卡號格式不正確，請輸入有效的16位信用卡號');
                    return;
                }

                if (expiryDate.length !== 5 || !expiryDate.match(/^\d{2}\/\d{2}$/)) {
                    alert('到期日格式不正確，請輸入有效的MM/YY格式');
                    return;
                }

                if (cvv.length !== 3 || !cvv.match(/^\d{3}$/)) {
                    alert('安全碼格式不正確，請輸入3位數字的CVV');
                    return;
                }

                if (phone.length !== 12 || !phone.match(/^09\d{2}-\d{3}-\d{3}$/)) {
                    alert('聯絡電話格式不正確，請輸入有效的手機號碼格式09xx-xxx-xxx');
                    return;
                }

                alert('付款資料已填寫完整，準備進行付款');

                $.ajax({
                    url: './ECPay.ashx',
                    type: 'POST',
                    data: {
                        amount: amount,
                        roomName: roomName
                    },
                    success: function (response) {
                        try {
                            if (response && response.url) {
                                // 跳轉至綠界付款頁面
                                window.location.href = response.url;
                            } else {
                                alert('無法產生訂單，請稍後重試');
                            }
                        } catch (error) {
                            console.error('解析回應時發生錯誤:', error);
                            alert('付款失敗，請稍後重試');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX 錯誤: ', xhr.status, error);
                        alert('付款請求失敗: ' + xhr.responseText);
                    }
                });
            });
        });
    </script>
</asp:Content>
