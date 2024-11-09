<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="introduction.aspx.cs" Inherits="Project.introduction" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

       /* 調整文字樣式 */
       h5 {
           margin: 0; /* 移除上下外邊距，避免產生多餘空隙 */
           padding: 10px 0; /* 設置內邊距，使文字有上下間距 */
           color: green; 
           text-align: center;
           line-height: 1.6; /* 調整行高，使文字間距更舒適 */
           /*font-weight: bold;*/ /* 加粗文字 */
       }

        /* TextBox 樣式 */
        .textbox-style {
            padding: 10px;
            font-size: 16px;
            width: 80%; /* 設置 TextBox 寬度 */
            height: 100px; /* 設置高度，適合長文本顯示 */
            background-color: transparent; /* 移除背景色 */
            border: none; /* 移除邊框 */
            outline: none; /* 移除點擊時的邊框高亮 */
            resize: none; /* 禁止手動調整大小 */
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
        .parent-container {
            margin: 0;
            padding: 0;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
   </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Image runat="server" ImageUrl="~/Content/Images/first1.jpg" AlternateText="first" style="width: 100%; height: auto;" CssClass="image-class1" />
    <div class="content-area">
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">享受生活，每一天。為了實現夢想，我們於2013年成立日光生活，2015年打造旅宿品牌日光綠築，</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">2016年成立餐飲品牌日光私廚，2018年整合日光物業，2019年創立活動派對品牌日光時刻，</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">2022年獨立設計部門與婚禮宴席部門，分別成立日光文創、日光婚禮。</h5>
    </div>
    <asp:Image runat="server" ImageUrl="~/Content/Images/bar.jpg" AlternateText="bar" style="width: 100%; height: auto;" CssClass="image-class"/>
    <asp:Image runat="server" ImageUrl="~/Content/Images/far1.jpg" AlternateText="far" style="width: 100%; height: auto;" CssClass="image-class"/>


    <div class="content-area">
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">在日光有住宿、饗食、婚禮、活動、文創全方位體驗。希冀，透過日光，為人與自然搭起橋樑。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">讓日光生活理念在更多地方發芽。誠摯邀請您參與日光，讓我們一同寫下更多的故事......</h5>
    </div>

    <asp:Image runat="server" ImageUrl="~/Content/Images/love.jpg" AlternateText="far" style="width: 100%; height: auto;" CssClass="image-class"/>

    <div class="content-area">
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">以善待家人的心情珍惜來訪旅人與生活土地。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">在日光綠築我們客製化服務每個旅人需求，在相同如家溫暖裡留下不一樣新鮮回憶。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">如同健康生活初衷，我們謙卑與自然學習共生的方式，打造日光綠築成為一間有生命隨四季變化的綠建築。</h5>
    </div>

    <asp:Image runat="server" ImageUrl="~/Content/Images/living.jpg" AlternateText="far" style="width: 100%; height: auto;" CssClass="image-class"/>

    <div class="content-area">
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">日光綠築融合生態工法綠建築，使用隔熱玻璃，種植親水落羽松引入冬山河水。</h5>
        <h5 style="color: green; text-align: center; margin-top: 5px; margin-bottom: 5px;">在日光綠築可以感受萬物生命四季更迭，在這裏每刻光景都不一樣。</h5>
    </div>

    <!-- 表單內容 -->
    <form action="Contact.aspx" method="post">
    </form>
</asp:Content>
