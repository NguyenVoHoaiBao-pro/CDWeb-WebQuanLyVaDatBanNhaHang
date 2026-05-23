<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    List<Product> list = (List<Product>) request.getAttribute("list");
    if (list == null) list = new ArrayList<Product>();
%>

<div class="page-box glass-card">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h1 class="admin-page-title mb-1"><i class="bi bi-basket"></i> Quản lý sản phẩm</h1>
            <small class="text-muted">Tổng món ăn: <%= list.size() %></small>
        </div>
        <a href="<%= request.getContextPath() %>/admin/add-product" class="btn btn-success">
            <i class="bi bi-plus-lg"></i> Thêm món mới
        </a>
    </div>

    <div class="table-responsive">
        <table id="productTable" class="table table-bordered align-middle text-center">
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên món</th>
                <th>Danh mục</th>
                <th>Giá</th>
                <th width="180">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (list.isEmpty()) { %>
            <tr>
                <td colspan="6" class="py-4 text-muted">Chưa có sản phẩm nào</td>
            </tr>
            <% } else {
                for (Product p : list) {
            %>
            <tr>
                <td><%= p.getId() %></td>
                <td>
                    <img src="<%= p.getImage() %>"
                         onerror="this.src='<%= request.getContextPath() %>/images/default.jpg'">
                </td>
                <td class="fw-bold"><%= p.getName() %></td>
                <td><span class="badge-cat"><%= p.getCategory() %></span></td>
                <td><span class="badge-price"><%= String.format("%,.0f", p.getPrice()) %> đ</span></td>
                <td>
                    <div class="d-flex gap-2 justify-content-center flex-wrap">
                        <a href="<%= request.getContextPath() %>/admin/edit-product/<%= p.getId() %>"
                           class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil"></i> Sửa
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/delete-product/<%= p.getId() %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn muốn xóa món này?')">
                            <i class="bi bi-trash"></i> Xóa
                        </a>
                    </div>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function () {
    $('#productTable').DataTable({
        language: { url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
        pageLength: 10,
        order: [[0, "asc"]]
    });
});
</script>
