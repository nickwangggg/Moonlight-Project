<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="RoomManager.aspx.cs" Inherits="Project.registered_user.RoomManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>訂房管理系統</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>

    <style>
        .datepicker {
            background-color: #fff;
            padding: 15px 20px; /* 減少內邊距 */
        }

        .datepicker-dropdown {
            top: 0;
            left: calc(50% - 161px);
        }

        .datepicker-dropdown.datepicker-orient-left:before {
            left: calc(50% - 6px);
        }

        .datepicker-dropdown.datepicker-orient-left:after {
            left: calc(50% - 5px);
        }

        .input-group-custom {
            height: 35px;
        }

        .input-group-text-custom {
            height: 35px;
            line-height: 1.2;
        }

        .form-control-custom {
            height: 35px;
            padding: 5px 10px;
        }

        .select-custom {
            height: 35px;
        }

        .form-control {
            height: 40px; /* 調整高度 */
            padding: 3px 8px; /* 適當減少內邊距 */
            font-size: 14px; /* 調整字體大小使其協調 */
        }

        .form-select, .form-control {
            height: 40px; /* 保持高度一致 */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="form1" runat="server">
        <h1 class="display-3 text-center mb-4">訂房管理系統</h1>

        <div class="row justify-content-center mb-3 align-items-center" style="display: flex;">
            <!-- 姓名或 UserID 輸入框 -->
            <div class="col-auto">
                <input type="text" id="txtUserIdOrName" class="form-control" placeholder="輸入姓名或 UserID">
            </div>

            <!-- 入住日期 -->
            <div class="col-auto">
                <input type="text" id="txtCheckIn" class="form-control datepicker" placeholder="入住日期" readonly>
            </div>

            <!-- 退房日期 -->
            <div class="col-auto">
                <input type="text" id="txtCheckOut" class="form-control datepicker" placeholder="退房日期" readonly>
            </div>

            <!-- 入住人數 -->
            <div class="col-auto">
                <select id="occupancySelect" class="form-select">
                    <option value="">全部</option>
                    <option value="2">2 人房</option>
                    <option value="3">3 人房</option>
                </select>
            </div>

            <!-- 查詢按鈕 -->
            <div class="col-auto">
                <button type="button" id="btnSearch" class="btn btn-danger" style="height: 38px; width: 120px; font-weight: bold;">
                查詢
                </button>
            </div>
        </div>

        <!-- 訂房紀錄表格 -->
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>訂房編號</th>
                        <th>入住時間</th>
                        <th>退房時間</th>
                        <th>訂房者姓名</th>
                        <th>使用者ID</th>
                        <th>身分證字號</th>
                        <th>連絡電話</th>
                        <th>E-Mail</th>
                        <th>訂購房型</th>
                        <th>價錢</th>
                    </tr>
                </thead>
                <tbody id="bookingHistoryTableBody">
                    <!-- 動態插入資料 -->
                </tbody>
            </table>
        </div>
    </form>

    <script type="text/javascript">
        $(document).ready(function () {
            // 初始化 Datepicker
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true,
                startDate: new Date()
            });

            // 查詢按鈕事件
            $('#btnSearch').click(function () {
                const userIdOrName = $('#txtUserIdOrName').val();
                const checkIn = $('#txtCheckIn').val();
                const checkOut = $('#txtCheckOut').val();
                const occupancy = $('#occupancySelect').val();
                const today = new Date(); // 當天日期

                $.ajax({
                    url: '<%= ResolveUrl("~/registered_user/RoomSearch.ashx") %>',
                    type: 'GET',
                    data: {
                        userIdOrName: userIdOrName,
                        checkIn: checkIn,
                        checkOut: checkOut,
                        occupancy: occupancy
                    },
                    dataType: 'json',
                    success: function (response) {
                        $('#bookingHistoryTableBody').empty();

                        if (response.length > 0) {
                            response.forEach((record, index) => {
                                const checkInDate = new Date(record.CheckInDate);
                                const daysDifference = Math.ceil((checkInDate - today) / (1000 * 60 * 60 * 24));
                                const textStyle = checkInDate < today ? 'color: gray;' : '';
                                const cursorStyle = daysDifference >= 10 ? 'cursor: pointer;' : 'cursor: not-allowed; opacity: 0.5;';
                                const imagePath = daysDifference >= 10
                                    ? '<%= ResolveUrl("~/Content/Images/deleted.png") %>'
                                    : '<%= ResolveUrl("~/Content/Images/notdeleted.png") %>';

                                const imageElement = `
                                    <img 
                                        src="${imagePath}" 
                                        class="delete-image ${daysDifference >= 10 ? 'clickable' : 'disabled'}"
                                        data-booking-id="${record.BookingId}"
                                        style="${cursorStyle}"
                                    />`;

                                const row = `
                                    <tr style="${textStyle}">
                                        <td>${index + 1}</td>
                                        <td>${record.BookingId}</td>
                                        <td>${record.CheckInDate}</td>
                                        <td>${record.CheckOutDate}</td>
                                        <td>${record.FullName}</td>
                                        <td>${record.UserId}</td>
                                        <td>${record.IdentityNumber}</td>
                                        <td>${record.PhoneNumber}</td>
                                        <td>${record.Email}</td>
                                        <td>${record.RoomDescription}</td>
                                        <td>${record.Price}</td>
                                        <td>${imageElement}</td>
                                    </tr>`;
                                $('#bookingHistoryTableBody').append(row);
                            });

                            // 綁定刪除按鈕事件
                            $('.delete-image.clickable').click(function () {
                                const bookingId = $(this).data('booking-id');
                                deleteBooking(bookingId);
                            });
                        } else {
                            $('#bookingHistoryTableBody').append('<tr><td colspan="12">無符合條件的訂房紀錄</td></tr>');
                        }
                    },
                    error: function () {
                        alert('查詢失敗，請稍後再試！');
                    }
                });
            });

            function deleteBooking(bookingId) {
                if (confirm('確定要刪除此訂單嗎？')) {
                    $.ajax({
                        url: '<%= ResolveUrl("~/registered_user/DeleteBooking.ashx") %>',
                        type: 'POST',
                        data: { bookingId: bookingId },
                        success: function (response) {
                            if (response.success) {
                                alert('訂單已成功刪除！');
                                $('#btnSearch').click();
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
