<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="booking.aspx.cs" Inherits="Project.registered_user.booking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>訂房系統</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Datepicker CSS 與 JS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>

    <style>
        .datepicker {
            background-color: #fff;
            padding: 15px 20px;
            align-content: center;
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

        .day,
        .old,
        .new {
            width: 40px;
            height: 40px;
            border: 1px solid lightgrey;
        }

        .active {
            background-image: linear-gradient(#90CAF9, #64B5F6);
            color: #fff;
        }

        .range-start,
        .range-end {
            background-image: linear-gradient(#4CAF50, #4CAF50);
            color: white;
        }

        .prev,
        .next,
        .datepicker-switch {
            font-size: 18px;
            opacity: 0.7;
            color: #4CAF50;
        }

        .input-group-custom {
            height: 35px; /* 調整高度 */
        }

        .input-group-text-custom {
            height: 35px; /* 保持與輸入框高度一致 */
            line-height: 1.2; /* 調整文字的垂直對齊 */
        }

        .form-control-custom {
            height: 35px; /* 調整輸入框的高度 */
            padding: 5px 10px; /* 適當調整內邊距 */
        }

        .select-custom {
            height: 35px; /* 調整下拉選單高度 */
        }

        /* 月曆日期格樣式 */
       .calendar-date {
            padding: 10px;
            text-align: center;
            transition: background-color 0.2s ease;
            border: 1px solid #ddd;
            position: relative;
            height: 80px;
       }

        /* 過去日期的樣式 */
        .calendar-date.past-date {
            color: #b0b0b0 !important;
            pointer-events: none; /* 禁止選擇這些日期 */
        }

        /* 可選日期格樣式 */
        .selectable-date {
            cursor: pointer;
        }

        /* 顯示在日期下方的剩餘房間數 */
        .availability {
            display: block;
            font-size: 0.85em;
            color: #4CAF50;
            position: relative;
            margin-top: 1px;
            width: 100%;
            text-align: center;
            left: 0;
        }

        .date-text {
            display: block;
            font-size: 1.2em;
        }

        /* 滑鼠移動到日期格時顯示淺綠色背景 */
        .calendar-date.selectable-date:hover {
            background-color: #d9f2d9 !important;
        }

        #calendar table {
            table-layout: fixed;
            width: 100%;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="form1" runat="server">
        <h1 class="display-3 text-center" style="margin-bottom: -7px;">日光綠築訂房系統</h1>
        <div style="width: 100%; display: flex; justify-content: center;">
            <div style="background-color: rgb(37, 150, 190); height: 2px; width: 40%; margin-bottom: 15px;"></div>
        </div>

        <div class="row justify-content-center mb-3">
            <!-- 入住日期 -->
            <div class="col-auto">
                <div class="input-group input-group-custom" style="width: 180px;">
                    <span class="input-group-text input-group-text-custom">入住</span>
                    <input type="text" id="txtCheckIn"
                        class="form-control form-control-custom datepicker"
                        placeholder="入住日期" readonly>
                </div>
            </div>

            <!-- 退房日期 -->
            <div class="col-auto">
                <div class="input-group input-group-custom" style="width: 180px;">
                    <span class="input-group-text input-group-text-custom">退房</span>
                    <input type="text" id="txtCheckOut"
                        class="form-control form-control-custom datepicker"
                        placeholder="退房日期" readonly>
                </div>
            </div>

            <!-- 入住人數 -->
            <div class="col-auto">
                <div class="input-group input-group-custom" style="width: 150px;">
                    <span class="input-group-text input-group-text-custom">入住人數</span>
                    <select id="occupancySelect" class="form-select select-custom">
                        <option value="2">2 人</option>
                        <option value="3">3 人</option>
                    </select>
                </div>
            </div>
        </div>

        <div id="calendarContainer">
            <!-- 年份和月份選單 -->
            <select id="yearSelect"></select>
            <select id="monthSelect"></select>
            <!-- 月曆顯示 -->
            <div id="calendar"></div>
        </div>

        <div class="d-flex flex-column align-items-center mt-3" style="gap: 10px;">
            <button type="button" id="btnCheckRoom" class="btn btn-primary mt-2">查詢空房</button>
            <div id="availableRooms" class="mt-3" style="width: 80%; margin: 0 auto;"></div>
            <div id="dynamicButton" class="mt-1"></div>
            <div id="bookingResult" class="mt-3"></div>
        </div>
    </form>
    <script type="text/javascript">
        let checkInDate = null;
        let checkOutDate = null;

        $(document).ready(function () {
            // 初始化 Datepicker
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true,
                startDate: new Date()
            });

            // 初始化日曆
            initCalendar();

            // 查詢空房按鈕點擊事件
            $('#btnCheckRoom').click(function () {
                const checkIn = $('#txtCheckIn').val();
                const checkOut = $('#txtCheckOut').val();
                const occupancy = $('#occupancySelect').val();

                if (new Date(checkIn) >= new Date(checkOut)) {
                    alert("退房日期不得早於入住日期或同天！");
                    return;
                }

                if (!checkIn || !checkOut) {
                    alert("請確認入住和退房日期格式正確。");
                    return;
                }

                fetchAvailableRooms(checkIn, false); // 查詢具體房型訊息

                $.ajax({
                    type: "POST",
                    url: './Booking.ashx',
                    data: {
                        actionCheck: "actionCheck",
                        checkIn: checkIn,
                        checkOut: checkOut,
                        occupancy: occupancy
                    },
                    success: function (response) {
                        $('#availableRooms').html(response);

                        // 動態生成確認訂房按鈕
                        $('#dynamicButton').html(`
                            <button type="button" id="btnBookRoom" 
                                class="btn mt-1" 
                                style="background-color: #ff5424; color: white;">
                                確認訂房
                            </button>
                        `);

                        bindBookRoomEvent(); // 綁定確認訂房按鈕事件
                    },
                    error: function (err) {
                        alert("錯誤: " + err.responseText);
                    }
                });
            });

            function bindBookRoomEvent() {
                $('#btnBookRoom').click(function () {
                    const selectedRooms = [];
                    $('input[name="roomCheckbox"]:checked').each(function () {
                        selectedRooms.push($(this).val());
                    });

                    if (selectedRooms.length === 0) {
                        alert("請至少選擇一個房間！");
                        return;
                    }

                    const checkIn = $('#txtCheckIn').val();
                    const checkOut = $('#txtCheckOut').val();
                    const occupancy = $('#occupancySelect').val();

                    $.ajax({
                        type: "POST",
                        url: './Booking.ashx',
                        data: {
                            actionBooking: "actionBooking",
                            checkIn: checkIn,
                            checkOut: checkOut,
                            rooms: selectedRooms.join(','),
                            occupancy: occupancy
                        },
                        success: function (response) {
                            if (response.includes("訂房成功")) {
                                window.location.href = './Payment.aspx';
                            } else {
                                alert(response);
                            }
                        },
                        error: function (err) {
                            alert("錯誤: " + err.responseText);
                        }
                    });
                });
            }

            function resetForm() {
                $('#txtCheckIn').val('');
                $('#txtCheckOut').val('');
                $('#occupancySelect').prop('selectedIndex', 0);
                $('#availableRooms').html('');
                $('#dynamicButton').html('');
                $('#bookingResult').html('');
            }

            function initCalendar() {
                const today = new Date();
                const currentYear = today.getFullYear();
                const currentMonth = today.getMonth();

                populateYearAndMonthSelectors(currentYear, currentMonth);
                generateCalendar(currentYear, currentMonth);

                // 改變年份或月份時，更新日曆和可訂房間數量
                $('#yearSelect, #monthSelect').on('change', function () {
                    const selectedYear = parseInt($('#yearSelect').val());
                    const selectedMonth = parseInt($('#monthSelect').val());

                    generateCalendar(selectedYear, selectedMonth);

                    // 判斷所選月份是否在今天之前，如果是今天之前則不進行查詢
                    const today = new Date();
                    if (selectedYear < today.getFullYear() ||
                        (selectedYear === today.getFullYear() && selectedMonth < today.getMonth())) {
                        return; // 如果是過去月份，則不查詢
                    }

                    // 查詢新的月份內所有日期的可訂房間數量
                    const checkInDate = new Date(selectedYear, selectedMonth, 1);
                    fetchAvailableRooms(checkInDate.toISOString().split('T')[0], true);
                });

                // 如果已選擇入住日期，則更新顯示剩餘房間數量
                if (checkInDate) {
                    fetchAvailableRooms(checkInDate, true);
                }
            }

            // 製造年和月選單
            function populateYearAndMonthSelectors(year, month) {
                // 清空之前的選項
                $('#yearSelect').empty();
                $('#monthSelect').empty();

                for (let i = year; i <= year + 1; i++) {
                    $('#yearSelect').append(`<option value="${i}">${i}</option>`);
                }

                for (let i = 0; i < 12; i++) {
                    const monthName = new Date(0, i).toLocaleString("zh-TW", { month: "long" });
                    $('#monthSelect').append(`<option value="${i}">${monthName}</option>`);
                }

                // 設定選中的年份和月份
                $('#yearSelect').val(year);
                $('#monthSelect').val(month);
            }

            // 產生月曆
            function generateCalendar(year, month) {
                $('#calendar').empty();
                const today = new Date();
                today.setHours(0, 0, 0, 0); // 將今天的時間設定為晚上12點，方便比較
                const firstDay = new Date(year, month, 1).getDay();
                const daysInMonth = new Date(year, month + 1, 0).getDate();

                let html = "<table class='table table-bordered'><tr>";

                // 填充第一週前面的空白格子
                for (let i = 0; i < firstDay; i++) {
                    html += "<td></td>";
                }

                // 產生每個日期格
                for (let day = 1; day <= daysInMonth; day++) {
                    const currentDate = new Date(year, month, day);
                    const formattedDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
                    const isPastDate = currentDate < today;

                    if ((day + firstDay - 1) % 7 === 0 && day !== 1) {
                        html += "</tr><tr>"; // 每七天換行
                    }

                    // 如果日期在今天之前就產生樣式不同的日期格子
                    if (isPastDate) {
                        html += `<td class="calendar-date past-date" data-date="${formattedDate}">
                        <span class="date-text">${day}</span>
                        </td>`;
                    } else {
                        html += `<td class="calendar-date selectable-date" data-date="${formattedDate}"
                        onclick="selectDate('${formattedDate}')"
                        onmouseenter="handleMouseEnter(this)"
                        onmouseleave="handleMouseLeave(this)">
                        <span class="date-text">${day}</span>
                        </td>`;
                    }
                }

                // 填充最後一週後面的空白格子
                const remainingCells = (firstDay + daysInMonth) % 7;
                if (remainingCells !== 0) {
                    for (let i = remainingCells; i < 7; i++) {
                        html += "<td></td>";
                    }
                }

                html += "</tr></table>";

                $('#calendar').html(html);

                // 重新更新日曆格子的可訂房間數量
                if (checkInDate) {
                    fetchAvailableRooms(checkInDate, true);
                }
            }

            // 滑鼠事件處理方法
            window.handleMouseEnter = function (element) {
                if (element.classList.contains('selectable-date')) {
                    element.classList.add('hovered-date');
                }
            }

            window.handleMouseLeave = function (element) {
                if (element.classList.contains('selectable-date')) {
                    element.classList.remove('hovered-date');
                }
            }

            // 日期選擇事件
            window.selectDate = function (date) {
                if (!checkInDate || (checkInDate && checkOutDate)) {
                    checkInDate = date;
                    checkOutDate = null;
                    $('#txtCheckIn').val(date);
                    $('#txtCheckOut').val('');
                    alert("您選擇的入住日期為：" + date);

                    fetchAvailableRooms(date, true); // 查詢可訂房間數量(在月曆上)
                }
                else {
                    if (new Date(date) <= new Date(checkInDate)) {
                        alert("退房日期不能早於入住日期或同天，請重新選擇！");
                        return;
                    }
                    checkOutDate = date;
                    $('#txtCheckOut').val(date);
                    alert("您選擇的退房日期為：" + date);
                }
            }

            // 查詢可訂房間數量(在月曆上)
            function fetchAvailableRooms(checkInDate, isCalendarCheck = false) {
                $.ajax({
                    type: "POST",
                    url: './Booking.ashx',
                    data: {
                        actionCheck: "actionCheck",
                        checkIn: checkInDate,
                        calendarCheck: isCalendarCheck ? "true" : "false",
                        occupancy: $('#occupancySelect').val(),
                        checkOut: isCalendarCheck ? "" : $('#txtCheckOut').val() // 月曆查詢不需要退房日期
                    },
                    success: function (response) {
                        console.log("Server Response:", response);

                        if (isCalendarCheck) {
                            let data;
                            // 如果 response 已經是 JavaScript 對象，則不需要解析
                            if (typeof response === "string") {
                                try {
                                    data = JSON.parse(response);
                                    updateCalendarWithAvailability(data, checkInDate);
                                } catch (error) {
                                    console.error("JSON 解析錯誤:", error, "Response:", response);
                                    alert("查詢可訂房間數量時出現錯誤，請稍後再試。");
                                    return;
                                }
                            } else {
                                data = response;
                            }
                            console.log("Parsed JSON Data:", data);
                            updateCalendarWithAvailability(data, checkInDate);
                        } else {
                            // 顯示具體的房型
                            $('#availableRooms').html(response);

                            // 動態產生確認訂房按鈕
                            $('#dynamicButton').html(`
                                <button type="button" id="btnBookRoom" 
                                class="btn mt-1" 
                                style="background-color: #ff5424; color: white;">
                                確認訂房
                                </button>
                            `);

                            bindBookRoomEvent(); // 關聯確認訂房按鈕事件
                        }
                    },
                    error: function (err) {
                        console.error("錯誤:", err);
                        alert("查詢可訂房間數量時出現錯誤，請稍後再試。");
                    }
                });
            }

            // 在月曆日期格上顯示可訂房間數
            function updateCalendarWithAvailability(data, checkInDate) {
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                data.forEach(dayData => {
                    const currentDate = new Date(dayData.Date);
                    currentDate.setHours(0, 0, 0, 0);

                    // 判斷如果日期在今天或之後，才顯示剩餘房間數量
                    if (currentDate >= today) {
                        const cell = $(`[data-date='${dayData.Date}']`);
                        if (cell.length > 0) {
                            cell.find('.availability').remove(); // 清除舊的可訂房訊息
                            cell.append(`
                                <div class="availability">雙人房可訂：${dayData.TwoPersonRoomsAvailable} 間</div>
                                <div class="availability">三人房可訂：${dayData.ThreePersonRoomsAvailable} 間</div>
                            `);
                        }
                    } else {
                        // 如果是過去的日期，清除任何已經顯示的可訂房間數量
                        const cell = $(`[data-date='${dayData.Date}']`);
                        if (cell.length > 0) {
                            cell.find('.availability').remove();
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>
