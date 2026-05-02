<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<Product> list =
            (List<Product>) request.getAttribute("list");

    if(list == null){
        list = new java.util.ArrayList<>();
    }
%>

<div class="card-box">

    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-2">
        <h3 class="m-0">🍽 Danh sách món</h3>

        <a href="${pageContext.request.contextPath}/admin/add-product"
           class="btn btn-success">
            + Thêm
        </a>
    </div>

    <!-- TABLE -->
    <div class="table-responsive">

        <table class="table table-hover align-middle text-center">

            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên</th>
                <th>Giá</th>
                <th width="120">Thao tác</th>
            </tr>
            </thead>

            <tbody>

            <% if(list.isEmpty()){ %>

            <tr>
                <td colspan="5" class="text-muted py-4">
                    🚫 Chưa có sản phẩm
                </td>
            </tr>

            <% } else {

                for(Product p : list){
            %>

            <tr class="hover-row">

                <td><%=p.getId()%></td>

                <td>
                    <img src="<%=p.getImage()%>"
                         style="width:70px;height:55px;object-fit:cover;border-radius:10px">
                </td>

                <td class="fw-semibold"><%=p.getName()%></td>

                <td class="text-success fw-bold">
                    <%=String.format("%,.0f", p.getPrice())%> đ
                </td>

                <td>

                    <a href="${pageContext.request.contextPath}/admin/delete-product/<%=p.getId()%>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Xóa món này?')">
                        <i class="bi bi-trash"></i>
                    </a>

                </td>

            </tr>

            <% } } %>

            </tbody>

        </table>

    </div>

</div>

<!-- EFFECT -->
<style>

    .hover-row{
        transition:.2s;
    }

    .hover-row:hover{
        background:#f1f5f9;
        transform:scale(1.01);
    }

    @media(max-width:768px){

        h3{
            font-size:20px;
        }

        table{
            font-size:13px;
        }

        img{
            width:50px !important;
            height:40px !important;
        }
    }

</style>