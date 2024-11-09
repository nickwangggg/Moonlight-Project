<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="Project.homepage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/homepage.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form runat="server">
        <div style="position: relative; text-align: center;">
            <!-- 圖片 -->
            <asp:Image runat="server" ImageUrl="~/Content/Images/airview1.jpg" AlternateText="bar" 
                       style="width: 100%; height: auto;" CssClass="image-class1" />

            <!-- 在圖片上添加的文字 -->
            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
                        color: white; font-size: 24px; font-weight: bold; 
                        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);">
                <h1>日光綠築</h1>
                <h5>宜蘭渡假村</h5>
            </div>
        </div>

        <!-- 排序區域 -->
        <div class="content-wrapper">
            <h5 class="sorting-title">請依照您對房間的需求排行 (拖拉移動的方式)：</h5>

            <div class="sorting-container">
                <ul class="dropzone list-unstyled">
                    <li class="drop-box" id="box-1">1</li>
                    <li class="drop-box" id="box-2">2</li>
                    <li class="drop-box" id="box-3">3</li>
                    <li class="drop-box" id="box-4">4</li>
                    <li class="drop-box" id="box-5">5</li>
                </ul>

                <ul id="sortable-list" class="list-unstyled">
                    <li class="sortable-item" id="item-A" data-value="CostEffectiveness">性價比</li>
                    <li class="sortable-item" id="item-B" data-value="Clean">乾淨程度</li>
                    <li class="sortable-item" id="item-C" data-value="Entertainment">娛樂性</li>
                    <li class="sortable-item" id="item-D" data-value="Convenience">便利性</li>
                    <li class="sortable-item" id="item-E" data-value="Others">其他設施</li>
                </ul>
            </div>

            <div class="text-center button-container">
                <button id="get-order" class="btn btn-primary mt-3" type="button">提交排序結果</button>
                <button id="ai-selection" class="btn btn-success mt-3 ms-3" type="button">AI 智慧選房</button>
            </div>

            <div class="text-center">
                <label id="ai-selection-result" class="d-block mt-2" 
                       style="font-weight: bold; color: orangered; font-size: 24px;"></label>

                <div id="ai-image-container" class="mt-3" style="display: none;">
                    <a href="<%= ResolveUrl("~/registered_user/booking.aspx") %>" title="可點擊進行訂房服務">
                        <img id="ai-image" src="" alt="AI推薦的房型" style="max-width: 40%; height: auto; cursor: pointer;">
                    </a>
                </div>
            </div>
        </div>

        <br />
        <img src='<%= ResolveUrl("~/Content/Images/living1.jpg") %>' alt="living1" 
             style="width: 100%; height: auto; text-align: center; margin-bottom: 30px;" />
        
        <h2 style="color: green; text-align: center;">只要一顆期待的心便能展開旅程</h2>
        <div style="display: flex; justify-content: center; align-items: center;">
            <img src='<%= ResolveUrl("~/Content/Images/leave.jpg") %>' alt="leave" style="width: 3%; height: 1%;" />
        </div>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">日光綠築為您準備好旅程所需。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">無論軟硬枕頭、沐浴備品、冷暖氣機應有盡有。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">我們還有親子、銀髮、無障礙及素食友善。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">來日光，只要一顆期待的心，輕鬆無負擔，拎起行囊即刻成行</h5>
        <br />
        <br />
        <!-- 修改後的圖片路徑 -->
        <img src='<%= ResolveUrl("~/Content/Images/topfloor.jpg") %>' alt="topfloor" style="width: 100%; height: auto; margin-bottom: 30px;" />

        <h2 style="color: green; text-align: center;">無論寒暑假都能在渡假村悠然慢活</h2>

        <div style="display: flex; justify-content: center; align-items: center;">
            <img src='<%= ResolveUrl("~/Content/Images/leave.jpg") %>' alt="leave" style="width: 3%; height: 1%;" />
        </div>

        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">在日光有園區內專屬車位、免費腳踏車景點漫遊、空中花園觀星、水榭大道</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">戲水、家庭劇院看電影。還有光合農場、沐棧碼頭、日光之夜、文創小舖、</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">時刻午茶、私廚高餐等各式設施活動。</h5>
        <br />
        <br />
        <script>
            $(document).ready(function () {
                console.log("JavaScript 已加載"); // 確認 JS 加載

                // 確保排序區域和按鈕可見
                $(".sorting-container, .button-container, .sorting-title").show();

                // 初始化可拖曳項目
                $(".sortable-item").draggable({
                    helper: "original",
                    revert: function (isValidDrop) {
                        if (!isValidDrop) {
                            $("#sortable-list").append($(this).css({ top: 0, left: 0 }));
                            return false;
                        }
                        return false;
                    }
                });

                // 初始化 Drop Box
                $(".drop-box").droppable({
                    accept: ".sortable-item",
                    drop: function (event, ui) {
                        $(this).empty().append(ui.draggable.css({ top: 0, left: 0 }));
                    }
                });

                let isSubmitted = localStorage.getItem("isSubmitted") === "true";

                $("#get-order").click(function () {
                    const scores = {};
                    $(".drop-box").each(function (index) {
                        const value = $(this).find(".sortable-item").data("value");
                        if (value) {
                            scores[value] = 5 - index;
                        }
                    });

                    console.log("送出的資料：", JSON.stringify(scores));
                    $.ajax({
                        url: "/RoomAPI.ashx",
                        type: "POST",
                        data: JSON.stringify(scores),
                        contentType: "application/json; charset=utf-8",
                        success: function () {
                            alert("資料已成功提交！");
                            $(".sortable-item").draggable("disable");
                            $(".drop-box").droppable("disable");
                            isSubmitted = true;
                            localStorage.setItem("isSubmitted", "true");
                        },
                        error: function (xhr) {
                            console.error("提交失敗：", xhr.responseText);
                        }
                    });
                });

                $("#ai-selection").click(function (event) {
                    event.preventDefault();
                    if (!isSubmitted) {
                        alert("請先提交排序結果！");
                        return;
                    }

                    const scores = {};
                    $(".drop-box").each(function (index) {
                        const value = $(this).find(".sortable-item").data("value");
                        if (value) {
                            scores[value] = 5 - index;
                        }
                    });

                    $.ajax({
                        url: "https://myflaskapi-h5g9bxekhkathzac.canadacentral-01.azurewebsites.net/api/predict",
                        type: "POST",
                        data: JSON.stringify([scores]),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            const prediction = response.prediction;
                            $("#ai-selection-result").text(`AI推薦的房型：${prediction}`);

                            let imageUrl = "";
                            switch (prediction) {
                                case "香水百合":
                                    imageUrl = '<%= ResolveUrl("~/Content/Images/rooma1.jpg") %>';
                                    break;
                                case "天使薔薇":
                                    imageUrl = '<%= ResolveUrl("~/Content/Images/roomc2.jpg") %>';
                                    break;
                                case "向日葵":
                                    imageUrl = '<%= ResolveUrl("~/Content/Images/roomb1.jpg") %>';
                                    break;
                                case "蝴蝶蘭":
                                    imageUrl = '<%= ResolveUrl("~/Content/Images/roomd1.jpg") %>';
                                    break;
                                default:
                                    imageUrl = '<%= ResolveUrl("~/Content/Images/default_room.jpg") %>';
                                    break;
                            }
                            $("#ai-image").attr("src", imageUrl);
                            $("#ai-image-container").fadeIn();
                            $(".sorting-container, .button-container, .sorting-title").hide();
                        },
                        error: function (xhr) {
                            console.error("無法取得 AI 預測結果：", xhr.responseText);
                        }
                    });
                });
            });
        </script>
    </form>
</asp:Content>
