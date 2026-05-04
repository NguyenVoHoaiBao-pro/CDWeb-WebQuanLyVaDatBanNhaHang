<!-- FILE: /views/admin/products.jsp -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    List<Product> list = (List<Product>) request.getAttribute("list");
    if(list == null) list = new ArrayList<Product>();
%>

<jsp:include page="../layout/admin-header.jsp"/>

<style>
    .page-box{
        background:#fff;
        border-radius:20px;
        padding:30px;
        box-shadow:0 10px 30px rgba(0,0,0,.08);
    }
    .table img{
        width:80px;
        height:60px;
        object-fit:cover;
        border-radius:12px;
    }
    .table tbody tr{
        transition:.2s;
    }
    .table tbody tr:hover{
        background:#f8f9fa;
        transform:scale(1.01);
    }
    .badge-price{
        background:#e8fff0;
        color:#198754;
        padding:8px 12px;
        border-radius:20px;
        font-weight:700;
    }
</style>

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

            <table class="table table-bordered align-middle text-center">

                <thead class="table-dark">
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

<jsp:include page="../layout/admin-footer.jsp"/>