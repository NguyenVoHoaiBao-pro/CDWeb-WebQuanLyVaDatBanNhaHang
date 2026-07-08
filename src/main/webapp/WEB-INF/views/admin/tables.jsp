<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% List<RestaurantTable> list = (List<RestaurantTable>) request.getAttribute("list"); %>

<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
        <h1 class="admin-page-title mb-1"><i class="bi bi-grid"></i> Quản lý bàn</h1>
        <small class="text-muted">Tổng số bàn: <%= (list != null) ? list.size() : 0 %></small>
    </div>
    <a href="${pageContext.request.contextPath}/admin/add-table" class="btn btn-success">
        <i class="bi bi-plus-lg"></i> Thêm bàn mới
    </a>
</div>

<div class="card-box glass-card">
    <div class="table-responsive">
        <table id="tableTable" class="table table-bordered table-hover text-center align-middle">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên bàn</th>
                <th>Sức chứa</th>
                <th>Tầng</th>
                <th>Giá</th>
                <th>Vận hành</th>
                <th width="300">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (list != null) {
                for (RestaurantTable t : list) { %>
            <tr>
                <td><%= t.getId() %></td>
                <td class="fw-bold"><%= t.getName() %></td>
                <td><%= t.getCapacity() %> người</td>
                <td>
                    <%
                        if (t.getFloorNumber() == 0) {
                            out.print("Tầng trệt");
                        } else {
                            out.print("Tầng " + t.getFloorNumber());
                        }
                    %>
                </td>
                <td>
                    <fmt:formatNumber value="<%= t.getPrice() %>" type="currency" currencySymbol="₫"/>
                </td>
                <td>
                    <%
                        String st = t.getStatus();
                        String stLabel = "Hoạt động";
                        String stClass = "bg-success";
                        if ("MAINTENANCE".equals(st)) {
                            stLabel = "Bảo trì";
                            stClass = "bg-secondary";
                        } else if ("RESERVED".equals(st)) {
                            stLabel = "Legacy — nên đặt Hoạt động";
                            stClass = "bg-warning text-dark";
                        }
                    %>
                    <span class="badge <%= stClass %>"><%= stLabel %></span>
                </td>
                <td>
                    <div class="row g-2 justify-content-center" style="max-width: 240px; margin: 0 auto;">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/change-table/<%= t.getId() %>/AVAILABLE"
                               class="btn btn-success btn-sm w-100">Hoạt động</a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/change-table/<%= t.getId() %>/MAINTENANCE"
                               class="btn btn-secondary btn-sm w-100">Bảo trì</a>
                        </div>
                        <div class="col-6">
                            <button type="button" class="btn btn-primary btn-sm w-100"
                                    data-bs-toggle="modal"
                                    data-bs-target="#qrModal">
                                <i class="bi bi-qr-code"></i> Mã QR
                            </button>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/tables/delete/<%= t.getId() %>"
                               class="btn btn-danger btn-sm w-100"
                               onclick="return confirm('Bạn có chắc muốn xóa bàn này?')">
                                <i class="bi bi-trash"></i> Xóa
                            </a>
                        </div>
                    </div>
                </td>
            </tr>
            <% }
            } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Import QRious library for local client-side QR generation -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrious/4.0.2/qrious.min.js"></script>

<!-- Modal hiển thị & in QR Code -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-light border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="qrModalLabel"><i class="bi bi-qr-code"></i> Mã QR gọi món</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center" id="qrPrintArea">
                <h3 class="fw-bold mb-3" id="qrTableName" style="color: #ff6b35;">Bàn...</h3>
                <div class="p-3 bg-white d-inline-block rounded mb-3 shadow">
                    <!-- Canvas for local QR code generation -->
                    <canvas id="qrCanvas" style="display: none; margin: 0 auto;"></canvas>
                    <!-- Image fallback if CDN script is blocked -->
                    <img id="qrImage" src="" alt="QR Code" style="width: 250px; height: 250px; display: none; margin: 0 auto;">
                </div>
                <p class="text-muted small">Quét mã để chuyển hướng tới menu gọi món</p>
                <div class="text-center mt-3">
                    <a id="qrDirectLink" href="#" target="_blank" class="text-info text-decoration-none small text-break">
                        Link trực tiếp
                    </a>
                </div>
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-warning" onclick="printQrCode()">
                    <i class="bi bi-printer"></i> In mã QR
                </button>
            </div>
        </div>
    </div>
</div>

<script>
// Native vanilla JS event delegation to handle QR Modal population securely
document.addEventListener('click', function (event) {
    var button = event.target.closest('[data-bs-target="#qrModal"]');
    if (!button) return;
    
    try {
        var tr = button.closest('tr');
        var cells = tr.getElementsByTagName('td');
        var tableId = cells[0].textContent.trim();
        var tableName = cells[1].textContent.trim();
        
        var ctx = '<%= request.getContextPath() %>';
        var qrUrl = window.location.origin + ctx + "/qr-order?tableId=" + tableId;
        
        document.getElementById('qrTableName').textContent = tableName + ' (ID: ' + tableId + ')';
        
        var directLink = document.getElementById('qrDirectLink');
        directLink.setAttribute('href', qrUrl);
        directLink.textContent = qrUrl;
        
        var canvas = document.getElementById('qrCanvas');
        var img = document.getElementById('qrImage');
        
        if (typeof QRious !== 'undefined') {
            canvas.style.display = 'block';
            img.style.display = 'none';
            new QRious({
                element: canvas,
                value: qrUrl,
                size: 250,
                background: 'white',
                foreground: 'black'
            });
        } else {
            canvas.style.display = 'none';
            img.style.display = 'block';
            var apiQr = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=' + encodeURIComponent(qrUrl);
            img.setAttribute('src', apiQr);
        }
    } catch (err) {
        console.error("Vanilla QR Modal Error:", err);
    }
});

// Relocate modal to body to prevent Bootstrap backdrop overlay and stacking context bugs
document.addEventListener('DOMContentLoaded', function () {
    var modal = document.getElementById('qrModal');
    if (modal) {
        document.body.appendChild(modal);
    }
});

$(document).ready(function () {
    $('#tableTable').DataTable({
        language: { url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
        pageLength: 10,
        order: [[0, "asc"]]
    });
});

function printQrCode() {
    var printContents = document.getElementById('qrPrintArea').innerHTML;
    var printWindow = window.open('', '_blank', 'width=600,height=650');
    printWindow.document.write('<html><head><title>In mã QR gọi món</title>');
    printWindow.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">');
    printWindow.document.write('<style>');
    printWindow.document.write('body { text-align: center; padding: 40px; background: white; color: black; font-family: sans-serif; }');
    printWindow.document.write('canvas, #qrImage { width: 280px; height: 280px; margin: 20px auto; display: block; }');
    printWindow.document.write('h3 { font-size: 28px; font-weight: bold; margin-bottom: 5px; color: #ff6b35; }');
    printWindow.document.write('.small { font-size: 14px; color: #666; margin-top: 10px; }');
    printWindow.document.write('a { display: none; }'); // Hide link in printing sheet
    printWindow.document.write('</style></head><body>');
    printWindow.document.write(printContents);
    
    // If qrious generated a canvas, we draw it as an image in print window or keep canvas
    printWindow.document.write('<script>');
    printWindow.document.write('window.onload = function() { ');
    printWindow.document.write('  var cv = document.getElementById("qrCanvas");');
    printWindow.document.write('  if (cv && cv.style.display !== "none") {');
    printWindow.document.write('    var imgData = cv.toDataURL("image/png");');
    printWindow.document.write('    var printImg = document.createElement("img");');
    printWindow.document.write('    printImg.src = imgData;');
    printWindow.document.write('    printImg.style.width = "280px"; printImg.style.height = "280px";');
    printWindow.document.write('    cv.parentNode.replaceChild(printImg, cv);');
    printWindow.document.write('  }');
    printWindow.document.write('  window.print(); window.close(); ');
    printWindow.document.write('};');
    printWindow.document.write('<\/script>');
    printWindow.document.write('</body></html>');
    printWindow.document.close();
}
</script>
