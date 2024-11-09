<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AccountManagement.aspx.cs" Inherits="Project.AccountManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script> <!-- jQuery UI -->
    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/accountManagment.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="row">
            <!-- 左邊區塊 (個人帳戶選項) -->
            <div class="col-md-3">
                <div class="list-group">
                    <span class="list-group-item" style="background-color: rgba(0,61,51,255); color: white;">個人帳戶</span>
                    <a href="#" class="list-group-item list-group-item-action list-group-item-light" id="basicInfoTab">基本資料</a>
                    <a href="#" class="list-group-item list-group-item-action list-group-item-light" id="bookingHistoryTab">訂房紀錄</a>
                    <a href="#" class="list-group-item list-group-item-action list-group-item-light" id="homePageTab">回到首頁</a>
                </div>
            </div>

            <!-- 中間區塊 (內容區域) -->
            <div class="col-md-9">
                <!-- 基本資料內容 -->
                <div id="basicInfo" class="content-section">
                    <div class="row">
                        <!-- 表單內容 (左邊) -->
                        <div class="col-md-8">
                            <form id="userForm" method="post">
                                <div class="card p-4" style="border: none;">
                                    <h4 class="profile-header">個人資料</h4>
                                    <div class="divider"></div>

                                    <div class="mb-3">
                                        <label for="firstNameInput" class="form-label" style="font-size: 18px;">姓名</label>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <input type="text" id="firstNameInput" class="form-control custom-input">
                                            </div>
                                            <div class="col-md-6">
                                                <input type="text" id="lastNameInput" class="form-control custom-input">
                                            </div>
                                            <label id="name_M_Error" class="error"></label><!-- 預留空間 -->
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="usernameInput" class="form-label" style="font-size: 18px;">用戶名稱</label>
                                        <input type="text" id="usernameInput" class="form-control custom-input" disabled>
                                        <label id="userid_M_Error" class="error"></label><!-- 預留空間 -->
                                    </div>

                                    <div class="mb-3">
                                        <label for="useremail" class="form-label" style="font-size: 18px;">e-mail</label>
                                        <input type="text" id="useremail" class="form-control custom-input">
                                        <label id="email_M_Error" class="error"></label><!-- 預留空間 -->
                                    </div>

                                    <div class="mb-3">
                                        <label for="usernamephone" class="form-label" style="font-size: 18px;">電話</label>
                                        <input type="text" id="usernamephone" class="form-control custom-input">
                                        <label id="phone_M_Error" class="error"></label><!-- 預留空間 -->
                                    </div>

                                    <div class="mb-3">
                                        <label for="useridcard" class="form-label" style="font-size: 18px;">身分證號</label>
                                        <input type="text" id="useridcard" class="form-control custom-input">
                                        <label id="idcard_M_Error" class="error"></label><!-- 預留空間 -->
                                    </div>
                                    <!-- 表單提交按鈕 -->
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-outline-danger custom-btn">更新</button>
                                    </div>
                                    <div class="divider" style="margin-top: 25px;" ></div>

                                    <!-- 排序區域開始 -->
                                    <div class="mb-3">
                                        <h5>請依照您對房間的需求排行 (拖拉移動的方式)：</h5>
                                        <div class="row">
                                            <!-- 灰色 Drop Box 區域 -->
                                            <div class="col-md-6">
                                                <ul class="dropzone list-unstyled">
                                                    <li class="drop-box" id="box-1">1</li>
                                                    <li class="drop-box" id="box-2">2</li>
                                                    <li class="drop-box" id="box-3">3</li>
                                                    <li class="drop-box" id="box-4">4</li>
                                                    <li class="drop-box" id="box-5">5</li>
                                                </ul>
                                            </div>

                                            <!-- 可拖曳的選項 -->
                                            <div class="col-md-6">
                                                <ul id="sortable-list" class="list-unstyled">
                                                    <li class="sortable-item" id="item-A" data-value="A">性價比</li>
                                                    <li class="sortable-item" id="item-B" data-value="B">乾淨程度</li>
                                                    <li class="sortable-item" id="item-C" data-value="C">娛樂性</li>
                                                    <li class="sortable-item" id="item-D" data-value="D">便利性</li>
                                                    <li class="sortable-item" id="item-E" data-value="E">其他設施</li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <button id="get-order" class="btn btn-primary mt-3">提交排序結果</button>
                                            <button id="ai-selection" class="btn btn-success mt-3 ms-3">AI 智慧選房</button>
                                            <!-- 新增一個label顯示AI選房結果 -->
                                            <label id="ai-selection-result" class="d-block mt-2" style="font-weight: bold; color: orangered;"></label>
                                        </div>
                                    </div>
                                    <!-- 排序區域結束 -->
                                </div>
                            </form>
                        </div>

                        <!-- 用戶圖片和編輯 (右邊) -->
                        <div class="col-md-4">
                            <div class="text-center">
                                <img id="profileImage" src="<%= ResolveUrl("~/Content/Images/airview1.jpg") %>" alt="User Image" class="rounded-circle mb-3" style="width: 150px; height: 150px;">
                                <div>
                                    <!-- 隱藏檔案上傳的 input -->
                                    <input type="file" id="fileUpload" class="form-control mb-3" accept="image/*" style="display: none;" />
                                    <button id="uploadBtn" class="btn btn-secondary">更改</button>
                                    <button id="removeBtn" class="btn btn-danger">移除</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 訂房紀錄內容 -->
                <div id="bookingHistory" class="content-section" style="display:none;">
                    <h4>訂房紀錄</h4>
                    <p style="color: #FF8C00; font-weight: bold;">以下是您的訂房紀錄</p>

                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>訂房者姓名</th>
                                <th>使用者ID</th>
                                <th>連絡電話</th>
                                <th>房型</th>
                                <th>入住時間</th>
                                <th>退房時間</th>
                                <th>取消訂房</th> <!-- 新增操作欄 -->
                            </tr>
                        </thead>
                        <tbody id="bookingHistoryTableBody">
                            <!-- 這裡會動態插入資料 -->
                        </tbody>
                    </table>

                    <!-- 新增簡單的說明標籤 -->
                    <label id="cancellationPolicy" class="notice-label">
                        注意：入住時間差 10 天以上（含）方可取消訂房，否則恕不接受取消。
                    </label>
                </div>
                <!-- 回到首頁內容 -->
                <div id="homePage" class="content-section" style="display:none;"></div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            // 預設顯示基本資料並設置對應選單項目為 active
            $('.content-section').hide();
            $('#basicInfo').show();
            $('#basicInfoTab').addClass('active');

            // 切換內容的選單點擊事件
            $('#basicInfoTab').click(function (e) {
                e.preventDefault();
                switchSection('#basicInfo', this);
            });

            $('#bookingHistoryTab').click(function (e) {
                e.preventDefault();
                switchSection('#bookingHistory', this);
                loadBookingHistory(); // 加載訂房紀錄
            });

            $('#homePageTab').click(function (e) {
                e.preventDefault();
                window.location.href = '<%= ResolveUrl("~/homepage.aspx") %>'; // 重定向到首頁
            });

            // 切換內容區域與設置 active 樣式的函式
            function switchSection(sectionId, element) {
                $('.content-section').hide();
                $(sectionId).show();
                $('.list-group-item').removeClass('active');
                $(element).addClass('active');
            }

            // 初始化可拖曳項目
            $(".sortable-item").draggable({
                helper: "original",
                revert: function (isValidDrop) {
                    if (!isValidDrop) {
                        // 如果未放入有效 Box，返回選項區
                        $("#sortable-list").append($(this).css({ top: 0, left: 0 }));
                        return false;
                    }
                    return false;
                },
                start: function (event, ui) {
                    $(this).addClass("being-dragged");
                },
                stop: function (event, ui) {
                    $(this).removeClass("being-dragged");
                }
            });

            // 初始化 Drop Box
            $(".drop-box").droppable({
                accept: ".sortable-item",
                drop: function (event, ui) {
                    const item = ui.draggable;

                    // 將項目移入 Box 並設置其位置和大小
                    $(this).empty().append(item.css({
                        top: 0,
                        left: 0,
                        width: "100%",
                        height: "100%"
                    }));
                }
            });


            let isSubmitted = false; // 追蹤是否已提交排序結果
            // 提交排序結果按鈕事件
            $("#get-order").click(function () {
                const scores = {
                    CostEffectiveness: 0,
                    Clean: 0,
                    Entertainment: 0,
                    Convenience: 0,
                    Others: 0
                };

                // 遍歷每個 Drop Box 並分配對應分數
                $(".drop-box").each(function (index) {
                    const score = 5 - index;
                    const item = $(this).find(".sortable-item");
                    const value = item.data("value");

                    if (value) {
                        switch (value) {
                            case 'A':
                                scores.CostEffectiveness = score;
                                break;
                            case 'B':
                                scores.Clean = score;
                                break;
                            case 'C':
                                scores.Entertainment = score;
                                break;
                            case 'D':
                                scores.Convenience = score;
                                break;
                            case 'E':
                                scores.Others = score;
                                break;
                        }
                    }
                });

                // 發送 AJAX 請求
                $.ajax({
                    url: "RoomAI.ashx", // 替換為你的後端處理程序
                    type: "POST",
                    data: JSON.stringify(scores), // 注意：這裡不要用陣列包裝
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        alert("資料已成功提交！");
                        $(".sortable-item").draggable("disable");
                        $(".drop-box").droppable("disable");
                        isSubmitted = true;
                    },
                    error: function (xhr, status, error) {
                        alert("提交失敗：" + xhr.responseText);
                    }
                });
            });


            // AI 智慧選房按鈕事件
            $("#ai-selection").click(function () {
                if (!isSubmitted) {
                    alert("請先提交排序結果！");
                    return;
                }

                const scores = {
                    CostEffectiveness: 0,
                    Clean: 0,
                    Entertainment: 0,
                    Convenience: 0,
                    Others: 0
                };

                // 根據每個 Box 的位置計算對應的分數
                $(".drop-box").each(function (index) {
                    const score = 5 - index;  // 第一個 Box 內容的分數為 5，第二個為 4 依此類推
                    const item = $(this).find(".sortable-item");  // 找到 Box 內的項目
                    const value = item.data("value");  // 取得 data-value

                    if (value) {
                        // 根據 data-value 分配對應的分數
                        switch (value) {
                            case 'A':
                                scores.CostEffectiveness = score;
                                break;
                            case 'B':
                                scores.Clean = score;
                                break;
                            case 'C':
                                scores.Entertainment = score;
                                break;
                            case 'D':
                                scores.Convenience = score;
                                break;
                            case 'E':
                                scores.Others = score;
                                break;
                        }
                    }
                });

                // 在控制台輸出 scores 以檢查結果
                console.log("Scores 內容：", scores);

                // 發送 AJAX 請求到 Flask API
                $.ajax({
                    url: "https://myflaskapi-h5g9bxekhkathzac.canadacentral-01.azurewebsites.net/api/predict",  // Flask API 的路徑
                    type: "POST",
                    data: JSON.stringify([scores]),  // 包裝成陣列發送
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        const aiResult = `AI推薦的房型：${response.prediction}`;
                        $("#ai-selection-result").text(aiResult);  // 顯示結果
                    },
                    error: function (xhr, status, error) {
                        console.error("無法取得 AI 預測結果：", xhr.responseText);
                    }
                });
            });


            // 加載使用者資料
            $.ajax({
                url: '<%= ResolveUrl("~/registered_user/AccountManagement.aspx") %>',
                type: 'GET',
                dataType: 'json',
                success: function (response) {
                    fillUserForm(response);
                },
                error: function () {
                    alert("無法加載資料，請稍後再試！");
                }
            });

            // 填充使用者資料表單
            function fillUserForm(data) {
                $('#firstNameInput').val(data.firstName);
                $('#lastNameInput').val(data.lastName);
                $('#usernameInput').val(data.userId);
                $('#useremail').val(data.email);
                $('#usernamephone').val(data.phoneNumber);
                $('#useridcard').val(data.identityNumber);
            }

            // 圖片上傳功能
            $('#uploadBtn').click(function () {
                $('#fileUpload').click();
            });

            $('#fileUpload').change(function () {
                handleImageUpload();
            });

            // 上傳圖片的函式
            function handleImageUpload() {
                var fileInput = $('#fileUpload')[0];
                if (fileInput.files.length > 0) {
                    var formData = new FormData();
                    formData.append('profileImage', fileInput.files[0]);

                    $.ajax({
                        url: '<%= ResolveUrl("~/registered_user/UploadProfileImage.ashx") %>',
                        type: 'POST',
                        data: formData,
                        contentType: false,
                        processData: false,
                        success: function (response) {
                            if (response.success) {
                                $('#profileImage').attr('src', response.imageUrl);
                                alert("圖片上傳成功！");
                            } else {
                                alert("圖片上傳失敗：" + response.error);
                            }
                        },
                        error: function () {
                            alert("發生錯誤，請稍後再試！");
                        }
                    });
                } else {
                    alert("請選擇要上傳的圖片");
                }
            }

            // 移除圖片功能
            $('#removeBtn').click(function () {
                $.ajax({
                    url: '<%= ResolveUrl("~/registered_user/UploadProfileImage.ashx?action=remove") %>',
                    type: 'POST',
                    success: function (response) {
                        if (response.success) {
                            $('#profileImage').attr('src', '<%= ResolveUrl("~/Content/Images/airview1.jpg") %>');
                            alert("圖片已移除並設為預設圖片！");
                        } else {
                            alert("移除失敗：" + response.error);
                        }
                    },
                    error: function () {
                        alert("發生錯誤，請稍後再試！");
                    }
                });
            });

            // 請求使用者圖片
            $.ajax({
                url: '<%= ResolveUrl("~/registered_user/GetProfileImage.ashx") %>',
                type: 'GET',
                dataType: 'json',
                success: function (response) {
                    $('#profileImage').attr('src', response.imageUrl || '<%= ResolveUrl("~/Content/Images/airview1.jpg") %>');
                },
                error: function () {
                    $('#profileImage').attr('src', '<%= ResolveUrl("~/Content/Images/airview1.jpg") %>');
                    alert("無法加載圖片，請稍後再試！");
                }
            });

            // 表單提交與驗證
            $("form").on("submit", function (event) {
                event.preventDefault();
                const { isValid, formData } = validateForm();

                if (isValid) {
                    $.ajax({
                        url: '<%= ResolveUrl("~/registered_user/MotifyUserData.ashx") %>',
                        type: 'POST',
                        data: formData,
                        success: function (response) {
                            if (response === "Success") {
                                alert("更新成功！");
                                fillUserForm(formData);
                            } else {
                                alert("更新失敗：" + response);
                            }
                        },
                        error: function () {
                            alert("發生錯誤，請稍後再試！");
                        }
                    });
                }
            });

            // 表單驗證函式
            function validateForm() {
                let isValid = true;
                let formData = {
                    firstName: $("#firstNameInput").val().trim(),
                    lastName: $("#lastNameInput").val().trim(),
                    userid: $("#usernameInput").val().trim(),
                    email: $("#useremail").val().trim(),
                    phoneNumber: $("#usernamephone").val().trim(),
                    identityNumber: $("#useridcard").val().trim()
                };

                $("label.error").text("");

                if (!formData.firstName || !formData.lastName) {
                    $("#name_M_Error").html("請輸入名字與姓氏");
                    isValid = false;
                }
                if (!formData.userid) {
                    $("#userid_M_Error").html("請輸入使用者名稱");
                    isValid = false;
                }
                if (!validateIdentityNumber(formData.identityNumber)) {
                    isValid = false;
                }
                if (!validatePhoneNumber(formData.phoneNumber)) {
                    isValid = false;
                }
                if (!validateEmail(formData.email)) {
                    isValid = false;
                }

                return { isValid, formData };
            }

            // 驗證身份證號碼
            function validateIdentityNumber(identityNumber) {
                let errorMessage = "";
                if (!identityNumber) {
                    errorMessage = "請輸入身分證號";
                } else if (identityNumber.length !== 10 || !/^[A-Z][12]\d{8}$/.test(identityNumber)) {
                    errorMessage = "身分證號格式錯誤";
                }
                $("#idcard_M_Error").html(errorMessage);
                return !errorMessage;
            }

            // 驗證電話號碼
            function validatePhoneNumber(phoneNumber) {
                let errorMessage = "";
                if (!phoneNumber || !/^09\d{8}$/.test(phoneNumber)) {
                    errorMessage = "電話號碼必須為 09 開頭且為 10 位數字";
                }
                $("#phone_M_Error").html(errorMessage);
                return !errorMessage;
            }

            // 驗證電子郵件
            function validateEmail(email) {
                let errorMessage = "";
                if (!email.includes("@")) {
                    errorMessage = "信箱格式錯誤";
                }
                $("#email_M_Error").html(errorMessage);
                return !errorMessage;
            }

            function loadBookingHistory() {
                $.ajax({
                    url: '<%= ResolveUrl("~/registered_user/BookingHistory.ashx") %>',
                    type: 'GET',
                    dataType: 'json',
                    success: function (response) {
                        $('#bookingHistoryTableBody').empty();

                        if (response.length > 0) {
                            response.forEach((record, index) => {
                                const today = new Date();
                                const checkInDate = new Date(record.CheckInDate);
                                const daysDifference = Math.ceil(
                                    (checkInDate - today) / (1000 * 60 * 60 * 24)
                                );

                                const imagePath = daysDifference >= 10
                                    ? '<%= ResolveUrl("~/Content/Images/deleted.png") %>'
                                    : '<%= ResolveUrl("~/Content/Images/notdeleted.png") %>';

                                const cursorStyle = daysDifference >= 10
                                    ? 'cursor: pointer;'
                                    : 'cursor: not-allowed; opacity: 0.5;';

                                const imageElement = `
                                    <img 
                                        src="${imagePath}" 
                                        class="delete-image ${daysDifference >= 10 ? 'clickable' : 'disabled'}"
                                        data-booking-id="${record.BookingId}"
                                        style="${cursorStyle}"
                                    />`;

                                const row = `
                                    <tr>
                                        <td>${index + 1}</td> <!-- 用於顯示順序 -->
                                        <td>${record.FullName}</td>
                                        <td>${record.UserId}</td>
                                        <td>${record.PhoneNumber}</td>
                                        <td>${record.RoomDescription}</td>
                                        <td>${record.CheckInDate}</td>
                                        <td>${record.CheckOutDate}</td>
                                        <td>${imageElement}</td>
                                    </tr>`;

                                $('#bookingHistoryTableBody').append(row);
                            });

                            // 綁定刪除圖片的點擊事件
                            $('.delete-image.clickable').click(function () {
                                const bookingId = $(this).data('booking-id');
                                deleteBooking(bookingId);
                            });
                        } else {
                            $('#bookingHistoryTableBody').append('<tr><td colspan="8">無訂房紀錄</td></tr>');
                        }
                    },
                    error: function () {
                        alert("無法取得訂房紀錄，請稍後再試！");
                    }
                });
            }


              function deleteBooking(bookingId) {
                    if (confirm('確定要刪除此訂單嗎？')) {
                        $.ajax({
                            url: '<%= ResolveUrl("~/registered_user/DeleteBooking.ashx") %>',
                            type: 'POST',
                            data: { bookingId: bookingId },
                            success: function (response) {
                                if (response.success) {
                                    alert('訂單已成功刪除！');
                                    loadBookingHistory(); // 重新加載訂房紀錄
                                } else {
                                    alert('刪除失敗：' + response.error);
                                }
                            },
                      error: function () {
                              alert('發生錯誤，請稍後再試！');
                          }
                       });
                   }
                }
            });
    </script>
</asp:Content>