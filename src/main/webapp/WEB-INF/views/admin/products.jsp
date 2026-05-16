<!-- FILE: /views/admin/products.jsp -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    List<Product> list = (List<Product>) request.getAttribute("list");
    if(list == null) list = new ArrayList<Product>();
%>


<div class="container py-5">

    <div class="page-box">

        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">

            <div>
                <h2 class="fw-bold mb-1">🍽 Quản Lý Sản Phẩm</h2>
                <small class="text-muted">
                    Tổng món ăn: <%=list.size()%>
                </small>
            </div>

            <a href="<%=request.getContextPath()%>/admin/add-product"
               class="btn btn-success">
                + Thêm món mới
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

                <% if(list.isEmpty()){ %>

                <tr>
                    <td colspan="6" class="py-4 text-muted">
                        Chưa có sản phẩm nào
                    </td>
                </tr>

                <% } else {
                    for(Product p : list){
                %>

                <tr>

                    <td><%=p.getId()%></td>

                    <td>
                        <img src="<%=p.getImage()%>"
                             onerror="this.src='<%=request.getContextPath()%>/images/default.jpg'">
                    </td>

                    <td class="fw-bold">
                        <%=p.getName()%>
                    </td>

                    <td>
                        <%=p.getCategory()%>
                    </td>

                    <td>
                        <span class="badge-price">
                            <%=String.format("%,.0f",p.getPrice())%> đ
                        </span>
                    </td>

                    <td>

                        <div class="d-flex gap-2 justify-content-center">

                            <a href="<%=request.getContextPath()%>/admin/edit-product/<%=p.getId()%>"
                               class="btn btn-warning btn-sm">
                                Sửa
                            </a>

                            <a href="<%=request.getContextPath()%>/admin/delete-product/<%=p.getId()%>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn muốn xóa món này?')">
                                Xóa
                            </a>

                        </div>

                    </td>

                </tr>

                <% }} %>

                </tbody>

            </table>

        </div>

    </div>

</div>

<script>
    $(document).ready(function() {
        $('#productTable').DataTable({
            "language": {
                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
            },
            "pageLength": 10,
            "order": [[0, "asc"]]
        });
    });
</script>

