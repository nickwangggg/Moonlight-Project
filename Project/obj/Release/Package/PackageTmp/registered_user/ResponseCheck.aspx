<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ResponseCheck.aspx.cs" Inherits="Project.registered_user.ResponseCheck" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .container {
            width: 100% !important;
            max-width: none !important;
        }
    </style>
    <div style="text-align: center; font-size: 40px; font-weight: bold; margin-top: 20px; color: #004D42;">
        用戶評價和意見回饋區
    </div>
    <div style="margin: 20px;">
        <table id="data-table" style="width: 100%; border-collapse: collapse; text-align: center; font-family: Arial, sans-serif; font-size: 18px;">
            <thead>
                <tr style="background-color: #004D42; color: white; font-size: 20px;">
                    <th style="border: 1px solid #ddd; padding: 12px; white-space: nowrap; width: 5%;">用戶名稱</th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('cost_effectiveness', this)">
                        性價比 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('entertainment', this)">
                        娛樂性 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('convenience', this)">
                        便利性 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('others', this)">
                        其他設施 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('clean', this)">
                        乾淨程度 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('total_score', this)">
                        總評價 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; white-space: nowrap; width: 5%;">房型</th>
                    <th style="border: 1px solid #ddd; padding: 12px; white-space: nowrap; word-break: break-word; width: 40%;">回饋訊息</th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('initDate', this)">
                        回饋時間 <span class="sort-arrow">&#9650;</span>
                    </th>
                    <th style="border: 1px solid #ddd; padding: 12px; white-space: nowrap; width: 5%;">用戶電話</th>
                    <th style="border: 1px solid #ddd; padding: 12px; white-space: nowrap; width: 5%;">用戶Email</th>
                    <th style="border: 1px solid #ddd; padding: 12px; cursor: pointer; white-space: nowrap; width: 5%;" onclick="sortTable('percent_positive', this)">
                        AI_正面情緒分數 <span class="sort-arrow">&#9650;</span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <!-- Data will be dynamically inserted here -->
            </tbody>
        </table>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        let tableData = [];
        let sortOrder = {};

        $(document).ready(function () {
            $.ajax({
                url: 'ResponseCheck1.ashx',
                method: 'GET',
                success: function (data) {
                    tableData = data.map(item => {
                        // 計算總評價分數
                        item.total_score = (parseFloat(item.cost_effectiveness) || 0) +
                            (parseFloat(item.entertainment) || 0) +
                            (parseFloat(item.convenience) || 0) +
                            (parseFloat(item.others) || 0) +
                            (parseFloat(item.clean) || 0);
                        return item;
                    });
                    renderTable(tableData);
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                }
            });
        });

        function renderTable(data) {
            const tableBody = $('#data-table tbody');
            tableBody.empty();
            $.each(data, function (index, item) {
                const row = `<tr>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.custermerName}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.cost_effectiveness}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.entertainment}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.convenience}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.others}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.clean}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.total_score}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.RoomType}</td>
                    <td style="border: 1px solid #ddd; padding: 12px; word-break: break-word; white-space: normal;">${item.custermerMessage}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${new Date(parseInt(item.initDate.match(/\/Date\((\d+)\)\//)[1])).toLocaleDateString()}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.custermerPhone}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.custermerEmail}</td>
                    <td style="border: 1px solid #ddd; padding: 12px;">${item.percent_positive != null ? item.percent_positive : 'N/A'}</td>
                </tr>`;
                tableBody.append(row);
            });
        }

        function sortTable(column, element) {
            // 切換排序順序和箭頭方向
            sortOrder[column] = !sortOrder[column];
            $('.sort-arrow').html('&#9650;'); // 重設所有箭頭為上箭頭
            $(element).find('.sort-arrow').html(sortOrder[column] ? '&#9660;' : '&#9650;'); // 切換箭頭方向

            // 排序表格數據
            tableData.sort((a, b) => {
                if (column === 'initDate') {
                    // 解析並排序日期
                    const dateA = new Date(parseInt(a[column].match(/\/Date\((\d+)\)\//)[1]));
                    const dateB = new Date(parseInt(b[column].match(/\/Date\((\d+)\)\//)[1]));
                    return sortOrder[column] ? dateA - dateB : dateB - dateA;
                } else {
                    // 以數值進行排序
                    const valA = parseFloat(a[column]) || 0;
                    const valB = parseFloat(b[column]) || 0;
                    return sortOrder[column] ? valA - valB : valB - valA;
                }
            });

            renderTable(tableData);
        }
    </script>
</asp:Content>
