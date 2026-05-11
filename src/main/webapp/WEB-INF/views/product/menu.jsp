<!-- FILE: WEB-INF/views/product/menu.jsp -->
<!-- FIX FULL theo controller hiện tại của bạn -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<Product> list =
            (List<Product>) request.getAttribute("list");

    if(list == null){
        list = new ArrayList<Product>();
    }
%>

<!-- HERO -->
<section class="hero">
    <div>
        <h1>🍽 THỰC ĐƠN NHÀ HÀNG</h1>
        <p>Chọn món ngon cho bữa ăn tuyệt vời của bạn</p>
    </div>
</section>

<div class="container py-5">

    <!-- SEARCH / FILTER -->
    <div class="filter-box mb-5">

        <form action="<%=request.getContextPath()%>/menu" method="get">

            <div class="row g-3">

                <div class="col-md-5">
                    <input type="text"
                           name="keyword"
                           class="form-control"
                           placeholder="Tìm món ăn...">
                </div>

                <div class="col-md-4">
                    <select name="category" class="form-select">

                        <option value="">Tất cả danh mục</option>
                        <option value="MÓN KHAI VỊ">Món khai vị</option>
                        <option value="MÓN CHÍNH">Món chính</option>
                        <option value="MÓN NƯỚC">Món nước</option>
                        <option value="MÓN ĂN NHẸ">Món ăn nhẹ</option>
                        <option value="MÓN TRÁNG MIÊNG & ĐỒ UỐNG">Tráng miệng</option>

                    </select>
                </div>

                <div class="col-md-3 d-grid">
                    <button class="btn btn-dark">
                        Tìm kiếm
                    </button>
                </div>

            </div>

        </form>

    </div>

    <!-- TOP BAR -->
    <div class="d-flex justify-content-between align-items-center mb-4">

        <h2 class="fw-bold">Danh sách món ăn</h2>

        <a href="<%=request.getContextPath()%>/cart"
           class="btn btn-danger">
            🛒 Giỏ hàng
        </a>

    </div>

    <!-- PRODUCT LIST -->
    <div class="row g-4">

        <% if(list.isEmpty()){ %>

        <div class="col-12 text-center py-5">
            <h4>Không có món ăn phù hợp</h4>
        </div>

        <% } %>

        <% for(Product p : list){ %>

<%--        <div class="col-lg-4 col-md-6">--%>
        <div class="col-custom-5 col-md-6 col-sm-12">
            <div class="food-card">

                <img src="<%=p.getImage()%>"
                     onerror="this.src='<%=request.getContextPath()%>/images/default.jpg'">

                <div class="card-body d-flex flex-column">

                    <h5 class="fw-bold"><%=p.getName()%></h5>

                    <p class="desc"><%=p.getDescription()%></p>

                    <div class="mt-auto">

                        <div class="price mb-3">
                            <%=String.format("%,.0f",p.getPrice())%> đ
                        </div>

                        <div class="d-grid gap-2">

                            <a href="<%=request.getContextPath()%>/product/<%=p.getId()%>"
                               class="btn btn-dark">
                                Xem chi tiết
                            </a>

                            <!-- FIX ĐÚNG ROUTE -->
                            <a href="<%=request.getContextPath()%>/cart/add/<%=p.getId()%>"
                               class="btn btn-danger">
                                🛒 Thêm vào giỏ
                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </div>

        <% } %>

    </div>

</div>

<jsp:include page="../layout/footer.jsp"/>