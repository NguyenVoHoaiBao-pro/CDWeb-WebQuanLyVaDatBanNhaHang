<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<Product> list = (List<Product>) request.getAttribute("list");
    if(list == null) list = new ArrayList<>();
%>

<style>
    .hero{
        height:300px;
        background:linear-gradient(rgba(0,0,0,.6),rgba(0,0,0,.6)),
        url('https://images.unsplash.com/photo-1504674900247-0877df9cc836') center/cover;
        display:flex;
        align-items:center;
        justify-content:center;
        color:white;
    }
    .card-food{
        border:none;
        border-radius:20px;
        overflow:hidden;
        box-shadow:0 10px 25px rgba(0,0,0,.1);
        transition:.3s;
    }
    .card-food:hover{
        transform:translateY(-10px);
    }
    .card-food img{
        height:200px;
        object-fit:cover;
    }
</style>

<section class="hero">
    <h1 class="fw-bold">🍽 THỰC ĐƠN NHÀ HÀNG</h1>
</section>

<div class="container py-5">
    <div class="row g-4">

        <%
            for(Product p : list){
        %>

        <div class="col-lg-4 col-md-6">
            <div class="card card-food">

                <img src="<%= p.getImage().startsWith("http") ? p.getImage() : request.getContextPath() + p.getImage() %>"
                     onerror="this.src='<%=request.getContextPath()%>/images/default.jpg'">

                <div class="p-3">

                    <h5 class="fw-bold"><%=p.getName()%></h5>

                    <p class="text-muted"><%=p.getDescription()%></p>

                    <div class="d-flex justify-content-between">

                        <span class="text-danger fw-bold">
                            <%=p.getPrice()%> đ
                        </span>

                        <a href="<%=request.getContextPath()%>/product/<%=p.getId()%>"
                           class="btn btn-dark btn-sm">
                            Xem
                        </a>

                    </div>

                </div>

            </div>
        </div>

        <%
            }
        %>

    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
