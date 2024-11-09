<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="TypeA.aspx.cs" Inherits="Project.TypeA" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>價目表</title>
    <style>
        /* 背景顏色設置 */
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
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }

        table {
            width: 50%;
            margin: 0 auto;
            border-collapse: collapse;
        }

        th {
            background-color: #005F40;
            color: white;
            padding: 10px;
            font-size: 18px;
        }

        td {
            padding: 10px;
            color: #005F40;
            font-size: 16px;
        }

        tr:nth-child(even) td {
            background-color: #f2f2f2;
        }
        /* 調整房間設施的標題 */
        h2 {
            color: rgba(9, 66, 56, 255);
            text-align: center;
            margin-bottom: 20px;
        }

        /* 使用 flex 布局將列表分為兩列，並靠中對齊 */
        ul {
            list-style-type: none;
            color: rgba(9, 66, 56, 255); /* 設置文字顏色 */
            display: flex;
            justify-content: space-around; /* 兩列項目均勻分佈，靠中間 */
            flex-wrap: wrap; /* 允許項目換行 */
            width: 30%; /* 調整列表的寬度，使兩列更靠中間 */
            margin: 0 auto; /* 列表居中 */
            padding: 0;
        }

        /* 每列設置為 45% 寬度，保持兩列佈局 */
        ul li {
            font-size: 16px;
            margin: 10px 0;
            display: flex;
            align-items: center;
            width: 30%; /* 控制每列的寬度，保持兩列佈局 */
        }

        /* 調整圖標的大小並且與文字之間保持間距 */
        ul li i {
            font-size: 20px;
            margin-right: 10px;
            color: rgba(9, 66, 56, 255); /* 設置圖標顏色 */
        }
        h5 {
            color: green;
            text-align: center;
        }
        /* 調整圖片樣式 */
        .image-class1 {
            margin-top: -24px; /* 移除圖片上方的間距 */
            padding-top: 0; /* 移除圖片上方的內邊距 */
            display: block; /* 保證圖片為塊狀元素 */
            /* 其他自定義樣式 */
        }

        .image-class {
            margin-top: 0; /* 移除圖片上方的間距 */
            padding-top: 0; /* 移除圖片上方的內邊距 */
            display: block; /* 保證圖片為塊狀元素 */
            /* 其他自定義樣式 */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Image runat="server" ImageUrl="~/Content/Images/roomd1.jpg" AlternateText="roomd1" style="width: 100%; height: auto; text-align: center;" CssClass="image-class1" />
    <div class="content-area">
        <h2>蝴蝶蘭豪華套房</h2>
        <span style="display: inline-block; margin-bottom: 5px;">
            <svg xmlns="http://www.w3.org/2000/svg" height="16px" viewBox="0 0 23.02 15.87">
                <path fill="#0a7150" fill-rule="evenodd" d="M9.35 9a14 14 0 0 1 4.78-3.57c1.92-1 4.33-1.44 6.36-2.33.61-1.1 1.18-2 1.79-3.1l.72.13A21.08 21.08 0 0 1 19.7 5a29.16 29.16 0 0 1-9.19 6.06L9.35 9zm11.93-4.62a23.72 23.72 0 0 1-10.73 6.74l.84 1.46 4.22 1.84c3.92-2.26 5.91-3.7 5.79-8.77z"></path>
                <path fill="#084137" fill-rule="evenodd" d="M19.79 11.38c-3.52 3.84-6.32.33-8.63-2.46a15.28 15.28 0 0 0-4.94-4.44 19.41 19.41 0 0 0-5.94-2.1 11.7 11.7 0 0 0 3.14 10.74 10.74 10.74 0 0 0 11.22 2C9 14.75 5.12 11 2.43 6c2.46 3.57 7.63 9.19 13.66 8.5a10.15 10.15 0 0 0 3.7-3.12z"></path>
            </svg>
        </span>
        <h5 style="margin-top: 20px;">精緻三人房中以「華」、「山」、「町」三個中文字元素，打造出獨創的家具陳列，</h5>
        <h5>不論是與閨密好友或家人出遊，貼心滿足每個人的休憩需求。</h5>
    </div>
    
    <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel" style="margin-top: 30px;">
        <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3" aria-label="Slide 4"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="4" aria-label="Slide 5"></button>

  </div>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="/Content/Images/roomd1.jpg" class="d-block w-75" alt="..." style="display: block; margin: 0 auto;">
    </div>
    <div class="carousel-item">
      <img src="/Content/Images/roomd2.jpg" class="d-block w-75" alt="..." style="display: block; margin: 0 auto;">
    </div>
    <div class="carousel-item">
      <img src="/Content/Images/roomd3.jpg" class="d-block w-75" alt="..." style="display: block; margin: 0 auto;">
    </div>
    <div class="carousel-item">
      <img src="/Content/Images/roomd4.jpg" class="d-block w-75" alt="..." style="display: block; margin: 0 auto;">
    </div>
    <div class="carousel-item">
      <img src="/Content/Images/roomd5.jpg" class="d-block w-75" alt="..." style="display: block; margin: 0 auto;">
    </div>
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Previous</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Next</span>
  </button>
</div>
<br>

    <h2>房間設施</h2>
    <ul>
        <li><i class="fas fa-credit-card"></i>可使用信用卡</li>
        <li><i class="fas fa-theater-masks"></i>家庭劇院</li>
        <li><i class="fas fa-shower"></i>大小毛巾</li>
        <li><i class="fas fa-coffee"></i>免費下午茶</li>
        <li><i class="fas fa-bed"></i>超大尺寸雙人床</li>
        <li><i class="fas fa-tree"></i>空中花園</li>
        <li><i class="fas fa-wifi"></i>免費無線網路</li>
        <li><i class="fas fa-bicycle"></i>免費腳踏車</li>
        <li><i class="fas fa-utensils"></i>餐廳</li>
        <li><i class="fas fa-thermometer-half"></i>冷暖氣機</li>
        <li><i class="fas fa-coffee"></i>免費早餐</li>
        <li><i class="fas fa-bath"></i>豪華浴缸</li>
        <li><i class="fas fa-concierge-bell"></i>客房服務</li>
        <li><i class="fas fa-print"></i>影印列印服務</li>
        <li><i class="fas fa-smoking-ban"></i>禁菸房</li>
        <li><i class="fas fa-parking"></i>免費停車場</li>
        <li><i class="fas fa-sun"></i>戶外陽台</li>
        <li><i class="fas fa-taxi"></i>計程車服務</li>
    </ul>
    <h2 style="margin-top: 60px;">價格</h2>
    <h5 style="margin-top: 30px; margin-bottom:30px; font-style: italic;">均以台幣計價</h5> 

    <table border="1" style="margin-bottom: 60px;" >
        <thead>
            <tr>
                <th>時間</th>
                <th>雙人定價</th>
                <th>三人定價</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>平日</td>
                <td>3800</td>
                <td>4800</td>
            </tr>
            <tr>
                <td>暑期 & 週五 & 週日</td>
                <td>4300</td>
                <td>5300</td>
            </tr>
            <tr>
                <td>假日 & 週六</td>
                <td>4800</td>
                <td>5800</td>
            </tr>
            <tr>
                <td>過年</td>
                <td>7000</td>
                <td>8000</td>
            </tr>
        </tbody>
    </table>
    <div class="content-area">
        <h2>注意事項</h2>
        <h5>入住時間15:00 ~ 20:00</h5>
        <h5>退房時間08:00 ~ 11:00</h5>
        <h5>早餐時間08:00 ~ 10:00</h5>
        <h5 style="margin-bottom: 30px;">午茶時間14:00 ~ 16:00</h5>
        <h5>超過20:00入住務必事先聯繫</h5>
        <h5>室內禁菸 & 非法藥品 & 寵物勿入</h5>
        <h5>22:00後請降低音量</h5>
        <h5>入住時請出示身分證件</h5>
        <h5 style="margin-bottom: 30px;">退房後遺留物不負管理責任</h5>
        <h5>加1人*$1,000</h5>
        <h5>加1床$500</h5>
        <h5>嬰兒床$300</h5>
        <h5>棉被$100</h5>
        <h5 style="margin-bottom: 30px;">*2歲以上需加人/含床及早餐下午茶</h5>
        <h5><a href="<%= ResolveUrl("~/registered_user/booking.aspx") %>" style="color: #FF8C00; text-decoration: none; font-weight: bold;">預約旅程</a></h5>
    </div>
</asp:Content>


