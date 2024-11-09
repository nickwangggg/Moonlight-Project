<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="CustermerService.aspx.cs" Inherits="Project.CustermerService" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 背景顏色設置 */
        .title-area {
            background: rgba(218,237,231,255); /* 設置淺綠色背景 */
            padding: 20px; /* 內邊距設置 */
            text-align: center; /* 將 TextBox 置中 */
            margin-top: -23px; /* 移除圖片上方的間距 */
        }    
        .content-area {
            display: flex;
            flex-direction: column;
            justify-content: center; /* 垂直方向置中 */
            align-items: center; /* 水平方向置中 */
            width: 100%; /* 確保寬度為100%，填滿整個區塊 */
            font-size: 14pt;
            color: gray;
            padding: 20px; /* 增加內邊距 */
            box-sizing: border-box; /* 確保寬度包含內邊距和邊框 */
            margin: 0 auto; /* 水平居中 */
        }
        .content-area label {
            text-align: left; /* Label 內容靠左對齊 */
            margin-left: 0px; /* 移除所有左邊的 margin */
        }
        iframe {
            width: 60%;  /* 設置地圖寬度為容器的 100% */
            height: 500px;  /* 設置固定的高度 */
        }
        .content-area {
            background: rgba(218,237,231,255); /* 設置淺綠色背景 */
            width: 100%; /* 確保寬度為100%，填滿整個區塊 */
            padding: 10px 20px; /* 增加適當的內邊距 */
            margin: 0 auto; /* 確保內容在視窗中居中 */
            box-sizing: border-box; /* 確保寬度包含內邊距和邊框 */
        }
       html, body {
           width: 100%;
           height: 100%;
           margin: 0;
           padding: 0;
       }
       .container {
           width: 100%;
           padding: 0;
           margin: 0;
           box-sizing: border-box;
       }
       #main-content {
           width: 100%; /* 確保內容區域寬度填滿 */
           max-width: none; /* 取消任何最大寬度限制 */
           margin: 0;
           padding: 0;
       }
        #TextBox4 {
            padding: 5px 5px; /* 增加左右邊的內邊距，5px 上下，10px 左右 */
            padding-left: 10px !important; /* 強制應用 100px 的內邊距 */
            text-align: left; /* 確保文字從左邊開始 */
            line-height: 1.5; /* 調整行高，使文字靠近上方 */
            vertical-align: top; /* 確保文字從頂部開始 */
            box-sizing: border-box; /* 確保寬度包含內邊距和邊框 */
            overflow-wrap: break-word; /* 確保自動換行 */
            resize: none; /* 禁止調整大小（如果需要） */
            white-space: pre-wrap; /* 保留空格和換行符 */
        }

        .custom-response-button {
            padding: 10px 30px; /* 調整按鈕的大小 */
            background-color: green; /* 設置按鈕背景顏色為綠色 */
            color: white; /* 設置按鈕文字顏色為白色 */
            font-size: 16px; /* 調整文字大小 */
            border: none; /* 移除邊框 */
            border-radius: 5px; /* 添加圓角 */
            cursor: pointer; /* 鼠標懸停時顯示為手型 */
            transition: background-color 0.3s ease; /* 添加背景顏色過渡效果 */
        }

        .custom-response-button:hover {
            background-color: darkgreen; /* 設置懸停時按鈕的顏色 */
        }
        .content-area a {
            text-decoration: none; /* 移除下劃線 */
            color: inherit; /* 保持文字顏色和周圍文本一致 */
            margin-bottom: 10px;
        }

        .content-area a:hover {
            text-decoration: underline; /* 顯示下劃線 */
            color: blue; /* 改變顏色 */
        }

        .ratings-container {
            background-color: rgba(218, 237, 231, 1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            padding: 20px;
            box-sizing: border-box;
            gap: 10px;
        }

        .ratings-wrapper {
            flex: 1;
            text-align: center;
            margin: 0 10px;
        }

        .ratings {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            flex-direction: row-reverse;
        }

        .ratings span {
            cursor: pointer;
            font-size: 50px;
            transition: color 0.2s;
            color: gray; /* 預設顏色 */
        }

        .ratings span.active {
            color: orange; /* 點擊後設為橙色 */
        }

        .ratings span:hover {
            color: orange;
        }

        .ratings span:hover ~ span {
            color: orange;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="title-area">
        <h2 style="color: green; text-align: center;">聯繫日光</h2>
        <h5 style="color: green; text-align: center; margin-top: 15px; margin-bottom: 5px;">如有任何疑問都歡迎聯繫，我們會竭誠為您服務。</h5>
        <h5 style="color: green; text-align: center; margin-top: 10px;">客服時間為08:00~20:00。</h5>
    </div>

    <!-- 客服表單 -->
    <form id="customerForm" method="post" runat="server">
        <div class="content-area">
           <asp:Label ID="name" runat="server" Text="您的大名(或使用者名稱)"></asp:Label>
           <asp:TextBox ID="TextBox1" runat="server" ClientIDMode="Static" Style="width: 500px; height:30px;" autocomplete="off"></asp:TextBox>
           <label id="nameError_R" class="error" style="color: red;"></label>
        </div>

        <div class="content-area">
            <asp:Label ID="phone" runat="server" Text="電話"></asp:Label>
            <asp:TextBox ID="TextBox2" runat="server" ClientIDMode="Static" Style="width: 500px; height:30px;" autocomplete="off"></asp:TextBox>
            <label id="phoneError_R" class="error" style="color: red;"></label>
        </div>

        <div class="content-area">
            <asp:Label ID="e_mail" runat="server" Text="電子郵件"></asp:Label>
            <asp:TextBox ID="TextBox3" runat="server" ClientIDMode="Static" Style="width: 500px; height:30px;" autocomplete="off"></asp:TextBox>
            <label id="emailError_R" class="error" style="color: red;"></label>
        </div>
        
        <div class="content-area">
            <asp:Label ID="message" runat="server" Text="留言或您的住宿評價" style="display: block; text-align: center;"></asp:Label>
            <asp:TextBox ID="TextBox4" runat="server" ClientIDMode="Static" TextMode="MultiLine" Wrap="True" Rows="5" Columns="50" Style="width: 500px; height: 100px; padding: 0px; text-align: left; vertical-align: top;" autocomplete="off"></asp:TextBox>
        </div>

        <h2 style="color: green; text-align: center; background: rgba(218,237,231,1); padding: 10px; border-radius: 5px; margin-top:0px;">
            回饋評分
        </h2>
        <div class="content-area" style="text-align: center; margin-top: -10px;">
            <div class="dropdown" style="display: inline-block; margin-right: 10px;">
                <button
                    class="btn btn-secondary dropdown-toggle"
                    type="button"
                    id="dropdownMenuButton1"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                    style="font-size: 18px; height: 50px; padding: 10px 20px; background-color: seagreen; border-color: #d6d6d6;">
                    請選擇您的房型
                </button>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                    <li><a class="dropdown-item" href="#" onclick="selectRoom('香水百合')">香水百合</a></li>
                    <li><a class="dropdown-item" href="#" onclick="selectRoom('天使薔薇')">天使薔薇</a></li>
                    <li><a class="dropdown-item" href="#" onclick="selectRoom('向日葵')">向日葵</a></li>
                    <li><a class="dropdown-item" href="#" onclick="selectRoom('蝴蝶蘭')">蝴蝶蘭</a></li>
                </ul>
            </div>

            <!-- 初始狀態的 label 隱藏 -->
            <label id="selectedRoomLabel" 
                   class="mt-3" 
                   style="display: none; margin-left: 10px; font-size: 24px; font-weight: bold; color:blue;">
                您選擇的是：
            </label>
        </div>
        <div class="ratings-container" style="margin-top:-10px;">
            <div class="ratings-wrapper">
                <label style="font-size: 20px; margin-right: 15px;">性價比</label>
                <div data-productid="39" class="ratings">
                    <span data-rating="5">☆</span>
                    <span data-rating="4">☆</span>
                    <span data-rating="3">☆</span>
                    <span data-rating="2">☆</span>
                    <span data-rating="1">☆</span>
                </div>
            </div>

            <div class="ratings-wrapper">
                <label style="font-size: 20px; margin-right: 15px;">娛樂性</label>
                <div data-productid="40" class="ratings">
                    <span data-rating="5">☆</span>
                    <span data-rating="4">☆</span>
                    <span data-rating="3">☆</span>
                    <span data-rating="2">☆</span>
                    <span data-rating="1">☆</span>
                </div>
            </div>

            <div class="ratings-wrapper">
                <label style="font-size: 20px; margin-right: 15px;">便利性</label>
                <div data-productid="41" class="ratings">
                    <span data-rating="5">☆</span>
                    <span data-rating="4">☆</span>
                    <span data-rating="3">☆</span>
                    <span data-rating="2">☆</span>
                    <span data-rating="1">☆</span>
                </div>
            </div>

            <div class="ratings-wrapper">
                <label style="font-size: 20px; margin-right: 15px;">其他設施</label>
                <div data-productid="42" class="ratings">
                    <span data-rating="5">☆</span>
                    <span data-rating="4">☆</span>
                    <span data-rating="3">☆</span>
                    <span data-rating="2">☆</span>
                    <span data-rating="1">☆</span>
                </div>
            </div>

            <div class="ratings-wrapper">
                <label style="font-size: 20px; margin-right: 15px;">乾淨程度</label>
                <div data-productid="43" class="ratings">
                    <span data-rating="5">☆</span>
                    <span data-rating="4">☆</span>
                    <span data-rating="3">☆</span>
                    <span data-rating="2">☆</span>
                    <span data-rating="1">☆</span>
                </div>
            </div>
        </div>

        <div class="content-area">
            <button type="submit" class="custom-response-button">送出</button>
        </div>

        <div class="content-area">
            <a href="mailto:service@loherb.com.tw" target="_blank">service@loherb.com.tw</a>
            <a href="tel:+88639595685" target="_blank">+88639595685</a>
            <a href="https://www.google.com/maps?q=宜蘭縣冬山鄉寶福路386號" target="_blank">宜蘭縣冬山鄉寶福路386號</a>
        </div>
    </form>

    <div style="width: 100%; text-align: center; margin-top: 30px;">
        <h2 style="color: green; margin-bottom: 15px;">我們的位置</h2>
        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3625.9244826993004!2d121.80793717651525!3d24.660727578060232!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3467e61d55a9d87b%3A0xdc93b07cb47e22a9!2zTE9IRVJCIOaXpeWFieWunOiYrQ!5e0!3m2!1szh-TW!2stw!4v1728473349669!5m2!1szh-TW!2stw"
                style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>

    <!-- jQuery 驗證程式碼 -->
<script>
    $(document).ready(function () {
        let ratings = {}; // 儲存評分項目
        let selectedRoomType = null; // 儲存選擇的房型，初始為 null

        // 星星點選事件處理
        $(".ratings span").on("click", function () {
            const productId = $(this).parent().data("productid");
            const ratingValue = $(this).data("rating");

            $(this).siblings().removeClass('active');
            $(this).addClass('active');
            $(this).nextAll().addClass('active');

            ratings[productId] = ratingValue;
        });

        // 房型選擇事件處理
        function selectRoom(roomName) {
            selectedRoomType = roomName; // 更新房型名稱
            const label = $("#selectedRoomLabel");
            label.text(`您選擇的是：${roomName} 房型`);
            label.show(); // 顯示 label
        }

        // 將 selectRoom 函數設為全域可用
        window.selectRoom = selectRoom;

        // 表單提交處理
        $("#customerForm").on("submit", function (event) {
            event.preventDefault();
            let isValid = true;

            // 清除錯誤訊息
            $("#nameError_R").text("");
            $("#phoneError_R").text("");
            $("#emailError_R").text("");

            const name_R = $("#TextBox1").val().trim();
            if (name_R === "") {
                $("#nameError_R").html("請輸入名字與姓氏");
                isValid = false;
            }

            const phoneNumber_R = $("#TextBox2").val().trim();
            let phoneErrorMessage_R = "";
            if (phoneNumber_R === "") {
                phoneErrorMessage_R = "請輸入電話號碼";
            } else if (phoneNumber_R.length !== 10) {
                phoneErrorMessage_R = "電話號碼必須為 10 位數";
            } else if (!/^09/.test(phoneNumber_R)) {
                phoneErrorMessage_R = "電話號碼前兩個必須為 09 開頭";
            } else if (!/^\d{10}$/.test(phoneNumber_R)) {
                phoneErrorMessage_R = "電話號碼必需都為數字";
            }
            if (phoneErrorMessage_R !== "") {
                $("#phoneError_R").html(phoneErrorMessage_R);
                isValid = false;
            }

            const email_R = $("#TextBox3").val().trim();
            let emailErrorMessage_R = "";
            if (email_R === "") {
                emailErrorMessage_R = "請輸入信箱";
            } else if (!email_R.includes("@")) {
                emailErrorMessage_R = "缺少 @ 符號";
            } else if (email_R.split("@").length !== 2) {
                emailErrorMessage_R = "電子郵件信箱只能有一個 @ 符號";
            }
            if (emailErrorMessage_R !== "") {
                $("#emailError_R").html(emailErrorMessage_R);
                isValid = false;
            }

            // 檢查是否每個評分項目都被評分
            const requiredProductIds = [39, 40, 41, 42, 43]; // 需要的評分項目 ID
            let hasMissingRating = false; // 檢查標誌

            requiredProductIds.forEach(id => {
                if (!ratings[id]) {
                    hasMissingRating = true;
                    return false; // 停止檢查
                }
            });

            if (hasMissingRating) {
                alert("請對每個項目進行評分");
                isValid = false;
            }

            if (isValid) {
                $(".custom-response-button").prop("disabled", true);

                const message_R = $("#TextBox4").val().trim();

                // 先發送資料到 sentimentAPI 以取得 percent_positive
                $.ajax({
                    url: 'https://sentiment-api-app-ded8cnb6gua0hcay.canadacentral-01.azurewebsites.net/api/sentiment',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        name: name_R,
                        message: message_R
                    }),
                    success: function (response) {
                        // 獲取 sentimentAPI 的 percent_positive
                        const percent_positive = response.percent_positive;

                        // 然後將所有資料傳送到 SaveCustomerResponse.ashx
                        $.ajax({
                            url: 'SaveCustomerResponse.ashx',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                name: name_R,
                                phoneNumber: phoneNumber_R,
                                email: email_R,
                                message: message_R,
                                ratings: ratings,
                                roomtype: selectedRoomType, // 若未選擇則為 null
                                percent_positive: percent_positive
                            }),
                            success: function (response) {
                                if (response.message === "成功") {
                                    alert("感謝您寶貴的意見回饋！");

                                    // 重置表單
                                    $("form")[0].reset();
                                    $(".custom-response-button").prop("disabled", false);
                                    $("#selectedRoomLabel").hide(); // 隱藏 label
                                    selectedRoomType = null; // 重置選擇的房型

                                    // 清除星星評分的狀態
                                    $(".ratings span").removeClass('active');
                                    ratings = {}; // 清空評分資料

                                } else {
                                    alert("傳送失敗：" + response);
                                    $(".custom-response-button").prop("disabled", false);
                                }
                            },
                            error: function (jqXHR) {
                                const errorDetails = JSON.stringify(jqXHR.responseText || jqXHR);
                                alert("發生錯誤：" + errorDetails);
                                $(".custom-response-button").prop("disabled", false);
                            }
                        });
                    },
                    error: function (jqXHR) {
                        const errorDetails = JSON.stringify(jqXHR.responseText || jqXHR);
                        alert("無法取得情感分析結果：" + errorDetails);
                        $(".custom-response-button").prop("disabled", false);
                    }
                });
            }
        });
    });
</script>


</asp:Content>
