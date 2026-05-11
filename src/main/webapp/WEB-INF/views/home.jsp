<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>
<%--<%@ page import="vn.edu.hcmuaf.fit.dao.ProductDAO" %>--%>
<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>
<%--<%@ page import="java.util.*" %>--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%
    User u = (User) session.getAttribute("user");
    String ctx = request.getContextPath();

//    List<Product> list = (List<Product>) request.getAttribute("list");
//    int total = (Integer) request.getAttribute("total");
%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Restaurant Luxury</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="<%=ctx%>/css/style.css">
<%--    <style>--%>

<%--        :root{--%>
<%--            --dark:#0f172a;--%>
<%--            --gold:#f59e0b;--%>
<%--            --white:#ffffff;--%>
<%--            --gray:#f8fafc;--%>
<%--            --red:#ef4444;--%>
<%--            --shadow:0 20px 40px rgba(0,0,0,.12);--%>
<%--        }--%>

<%--        *{--%>
<%--            margin:0;--%>
<%--            padding:0;--%>
<%--            box-sizing:border-box;--%>
<%--            scroll-behavior:smooth;--%>
<%--        }--%>

<%--        body{--%>
<%--            font-family:Segoe UI;--%>
<%--            background:var(--gray);--%>
<%--            overflow-x:hidden;--%>
<%--        }--%>

<%--        /* NAVBAR */--%>

<%--        .navbar{--%>
<%--            height:82px;--%>
<%--            background:rgba(15,23,42,.85)!important;--%>
<%--            backdrop-filter:blur(12px);--%>
<%--            transition:.35s;--%>
<%--            padding:0;--%>
<%--        }--%>

<%--        .navbar.scrolled{--%>
<%--            height:68px;--%>
<%--            box-shadow:0 10px 30px rgba(0,0,0,.18);--%>
<%--        }--%>

<%--        .navbar-brand{--%>
<%--            font-size:30px;--%>
<%--            font-weight:900;--%>
<%--            letter-spacing:1px;--%>
<%--            color:#fff!important;--%>
<%--        }--%>

<%--        .nav-link{--%>
<%--            color:#fff!important;--%>
<%--            font-weight:600;--%>
<%--            margin:0 10px;--%>
<%--            position:relative;--%>
<%--        }--%>

<%--        .nav-link::after{--%>
<%--            content:'';--%>
<%--            position:absolute;--%>
<%--            left:0;--%>
<%--            bottom:-6px;--%>
<%--            width:0;--%>
<%--            height:2px;--%>
<%--            background:var(--gold);--%>
<%--            transition:.35s;--%>
<%--        }--%>

<%--        .nav-link:hover::after{--%>
<%--            width:100%;--%>
<%--        }--%>

<%--        .btn-nav{--%>
<%--            border-radius:50px;--%>
<%--            padding:10px 22px;--%>
<%--            font-weight:700;--%>
<%--        }--%>

<%--        .user-badge{--%>
<%--            background:rgba(255,255,255,.12);--%>
<%--            padding:8px 16px;--%>
<%--            border-radius:30px;--%>
<%--            color:white;--%>
<%--            font-weight:600;--%>
<%--        }--%>

<%--        /* HERO */--%>

<%--        .hero{--%>
<%--            height:100vh;--%>
<%--            background:--%>
<%--                    linear-gradient(rgba(0,0,0,.58),rgba(0,0,0,.65)),--%>
<%--                    url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4') center/cover;--%>
<%--            display:flex;--%>
<%--            align-items:center;--%>
<%--            justify-content:center;--%>
<%--            text-align:center;--%>
<%--            color:white;--%>
<%--            position:relative;--%>
<%--        }--%>

<%--        .hero h1{--%>
<%--            font-size:74px;--%>
<%--            font-weight:900;--%>
<%--            line-height:1.1;--%>
<%--            animation:fadeDown 1.2s ease;--%>
<%--        }--%>

<%--        .hero p{--%>
<%--            font-size:22px;--%>
<%--            margin-top:18px;--%>
<%--            opacity:.95;--%>
<%--            animation:fadeUp 1.3s ease;--%>
<%--        }--%>

<%--        .hero-buttons{--%>
<%--            margin-top:28px;--%>
<%--            animation:fadeUp 1.5s ease;--%>
<%--        }--%>

<%--        .hero-buttons .btn{--%>
<%--            padding:14px 34px;--%>
<%--            border-radius:50px;--%>
<%--            font-weight:800;--%>
<%--            margin:8px;--%>
<%--        }--%>

<%--        .scroll-down{--%>
<%--            position:absolute;--%>
<%--            bottom:20px;--%>
<%--            font-size:28px;--%>
<%--            animation:bounce 1.6s infinite;--%>
<%--        }--%>

<%--        /* SECTION */--%>

<%--        .section-title{--%>
<%--            font-size:48px;--%>
<%--            font-weight:900;--%>
<%--            text-align:center;--%>
<%--            margin-bottom:14px;--%>
<%--            color:var(--dark);--%>
<%--        }--%>

<%--        .section-sub{--%>
<%--            text-align:center;--%>
<%--            color:#64748b;--%>
<%--            margin-bottom:45px;--%>
<%--            font-size:18px;--%>
<%--        }--%>

<%--        /* PRODUCT */--%>

<%--        .product-card{--%>
<%--            border:none;--%>
<%--            border-radius:24px;--%>
<%--            overflow:hidden;--%>
<%--            background:white;--%>
<%--            box-shadow:var(--shadow);--%>
<%--            transition:.35s;--%>
<%--            height:100%;--%>
<%--        }--%>

<%--        .product-card:hover{--%>
<%--            transform:translateY(-12px) scale(1.02);--%>
<%--        }--%>

<%--        .product-card img{--%>
<%--            height:240px;--%>
<%--            width:100%;--%>
<%--            object-fit:cover;--%>
<%--        }--%>

<%--        .product-body{--%>
<%--            padding:24px;--%>
<%--        }--%>

<%--        .price{--%>
<%--            font-size:28px;--%>
<%--            font-weight:900;--%>
<%--            color:var(--red);--%>
<%--        }--%>

<%--        .badge-cat{--%>
<%--            background:#fff7ed;--%>
<%--            color:#ea580c;--%>
<%--            padding:8px 16px;--%>
<%--            border-radius:30px;--%>
<%--            font-weight:700;--%>
<%--            display:inline-block;--%>
<%--            margin-bottom:12px;--%>
<%--        }--%>

<%--        /* STATS */--%>

<%--        .stats{--%>
<%--            background:linear-gradient(135deg,#111827,#1e293b);--%>
<%--            color:white;--%>
<%--            padding:90px 0;--%>
<%--            margin-top:90px;--%>
<%--        }--%>

<%--        .counter{--%>
<%--            font-size:58px;--%>
<%--            font-weight:900;--%>
<%--        }--%>

<%--        .counter-box{--%>
<%--            padding:25px;--%>
<%--        }--%>

<%--        /* ABOUT */--%>

<%--        .feature{--%>
<%--            background:white;--%>
<%--            border-radius:24px;--%>
<%--            padding:35px;--%>
<%--            box-shadow:var(--shadow);--%>
<%--            height:100%;--%>
<%--            transition:.3s;--%>
<%--        }--%>

<%--        .feature:hover{--%>
<%--            transform:translateY(-8px);--%>
<%--        }--%>

<%--        .feature-icon{--%>
<%--            font-size:48px;--%>
<%--            margin-bottom:16px;--%>
<%--        }--%>

<%--        /* REVIEW */--%>

<%--        .review{--%>
<%--            background:white;--%>
<%--            padding:30px;--%>
<%--            border-radius:24px;--%>
<%--            box-shadow:var(--shadow);--%>
<%--            height:100%;--%>
<%--        }--%>

<%--        /* CTA */--%>

<%--        .cta{--%>
<%--            background:--%>
<%--                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),--%>
<%--                    url('https://images.unsplash.com/photo-1559339352-11d035aa65de') center/cover;--%>
<%--            padding:120px 0;--%>
<%--            color:white;--%>
<%--            text-align:center;--%>
<%--            margin-top:80px;--%>
<%--        }--%>

<%--        /* FOOTER */--%>

<%--        footer{--%>
<%--            background:#0f172a;--%>
<%--            color:white;--%>
<%--            padding:45px 0;--%>
<%--            margin-top:0;--%>
<%--        }--%>

<%--        /* FLOAT */--%>

<%--        .toTop{--%>
<%--            position:fixed;--%>
<%--            right:20px;--%>
<%--            bottom:20px;--%>
<%--            width:52px;--%>
<%--            height:52px;--%>
<%--            border:none;--%>
<%--            border-radius:50%;--%>
<%--            background:var(--gold);--%>
<%--            font-size:22px;--%>
<%--            font-weight:900;--%>
<%--            display:none;--%>
<%--            z-index:999;--%>
<%--        }--%>

<%--        /* ANIM */--%>

<%--        @keyframes fadeDown{--%>
<%--            from{opacity:0;transform:translateY(-40px)}--%>
<%--            to{opacity:1;transform:translateY(0)}--%>
<%--        }--%>

<%--        @keyframes fadeUp{--%>
<%--            from{opacity:0;transform:translateY(40px)}--%>
<%--            to{opacity:1;transform:translateY(0)}--%>
<%--        }--%>

<%--        @keyframes bounce{--%>
<%--            0%,100%{transform:translateY(0)}--%>
<%--            50%{transform:translateY(-12px)}--%>
<%--        }--%>

<%--        /* MOBILE */--%>

<%--        @media(max-width:992px){--%>

<%--            .hero h1{--%>
<%--                font-size:52px;--%>
<%--            }--%>

<%--            .section-title{--%>
<%--                font-size:38px;--%>
<%--            }--%>

<%--            .navbar{--%>
<%--                height:auto;--%>
<%--                padding:10px 0;--%>
<%--            }--%>

<%--        }--%>

<%--        @media(max-width:768px){--%>

<%--            .hero h1{--%>
<%--                font-size:40px;--%>
<%--            }--%>

<%--            .hero p{--%>
<%--                font-size:18px;--%>
<%--            }--%>

<%--        }--%>

<%--    </style>--%>
</head>

<body>
<jsp:include page="layout/header.jsp"/>
<!-- HERO -->

<section class="hero" id="home">
    <div class="container">
        <h1>TRẢI NGHIỆM<br>ẨM THỰC THƯỢNG HẠNG</h1>
        <p>Nơi hương vị tinh tế gặp không gian sang trọng</p>

        <div class="hero-buttons">
            <a href="<%=ctx%>/tables" class="btn btn-warning">Đặt Bàn Ngay</a>
            <a href="<%=ctx%>/menu" class="btn btn-outline-light">Xem Menu</a>
        </div>
    </div>

    <div class="scroll-down">⌄</div>
</section>
<!-- PRODUCTS -->

<section class="container py-5" id="menu">

    <h2 class="section-title">MÓN ĂN NỔI BẬT</h2>
    <p class="section-sub">Danh sách món ăn lấy trực tiếp từ database</p>

    <div class="row g-4">

        <c:if test="${not empty list}">
            <c:forEach var="p" items="${list}" begin="0" end="${total - 1}">

            <div class="col-lg-4 col-md-6">
                    <div class="product-card">

                        <img src="${p.image}" alt="${p.name}">

                        <div class="product-body">

                            <div class="badge-cat">${p.category}</div>

                            <h4 class="fw-bold">${p.name}</h4>

                            <p class="text-muted" style="min-height:48px;">
                                    ${p.description}
                            </p>

                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <div class="price">${p.price}đ</div>
                                <a href="${pageContext.request.contextPath}/product/${p.id}"
                                   class="btn btn-dark rounded-pill px-4">
                                    Xem
                                </a>
                            </div>

                        </div>

                    </div>
                </div>
            </c:forEach>
        </c:if>

    </div>

</section>

<!-- STATS -->

<section class="stats">
    <div class="container">
        <div class="row text-center">

            <div class="col-md-3 counter-box">
                <div class="counter" data-target="5000">0</div>
                <p>Khách hàng</p>
            </div>

            <div class="col-md-3 counter-box">
                <div class="counter" data-target="180">0</div>
                <p>Món ăn</p>
            </div>

            <div class="col-md-3 counter-box">
                <div class="counter" data-target="25">0</div>
                <p>Đầu bếp</p>
            </div>

            <div class="col-md-3 counter-box">
                <div class="counter" data-target="12">0</div>
                <p>Năm kinh nghiệm</p>
            </div>

        </div>
    </div>
</section>

<!-- SERVICES -->

<section class="container py-5" id="service">

    <h2 class="section-title">DỊCH VỤ VIP</h2>
    <p class="section-sub">Đẳng cấp phục vụ chuyên nghiệp</p>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="feature text-center">
                <div class="feature-icon">🍽</div>
                <h4>Ẩm Thực Cao Cấp</h4>
                <p>Nguyên liệu tuyển chọn mỗi ngày.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature text-center">
                <div class="feature-icon">🚀</div>
                <h4>Phục Vụ Nhanh</h4>
                <p>Chuẩn nhà hàng 5 sao.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature text-center">
                <div class="feature-icon">🎵</div>
                <h4>Không Gian Chill</h4>
                <p>Âm nhạc và ánh sáng sang trọng.</p>
            </div>
        </div>

    </div>

</section>

<!-- REVIEW -->

<section class="container py-5" id="review">

    <h2 class="section-title">KHÁCH HÀNG NÓI GÌ</h2>
    <p class="section-sub">Hơn 5000 khách hàng hài lòng</p>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="review">
                <h5>⭐⭐⭐⭐⭐</h5>
                <p>Món ăn tuyệt vời, không gian quá đẹp.</p>
                <b>- Minh Anh</b>
            </div>
        </div>

        <div class="col-md-4">
            <div class="review">
                <h5>⭐⭐⭐⭐⭐</h5>
                <p>Nhân viên cực kỳ thân thiện và chuyên nghiệp.</p>
                <b>- Quốc Bảo</b>
            </div>
        </div>

        <div class="col-md-4">
            <div class="review">
                <h5>⭐⭐⭐⭐⭐</h5>
                <p>Tôi sẽ quay lại mỗi tuần.</p>
                <b>- Nhật Nam</b>
            </div>
        </div>

    </div>

</section>

<!-- CTA -->

<section class="cta" id="contact">
    <div class="container">

        <h2 class="display-4 fw-bold">Đặt Bàn Ngay Hôm Nay</h2>
        <p class="lead mt-3">Trải nghiệm bữa ăn đẳng cấp cùng gia đình</p>

        <a href="<%=ctx%>/tables" class="btn btn-warning btn-lg rounded-pill px-5 mt-3">
            ĐẶT BÀN
        </a>

    </div>
</section>

<%--<footer class="text-center">--%>
<%--    <div class="container">--%>
<%--        <h4>🍽 LUXURY FOOD</h4>--%>
<%--        <p>© 2026 All Rights Reserved</p>--%>
<%--    </div>--%>
<%--</footer>--%>

<button class="toTop" id="toTop">↑</button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>

    /* NAVBAR SCROLL */

    window.addEventListener("scroll",function(){
        const nav=document.querySelector(".navbar");
        if(window.scrollY>50){
            nav.classList.add("scrolled");
        }else{
            nav.classList.remove("scrolled");
        }
    });

    /* COUNTER */

    document.querySelectorAll(".counter").forEach(counter=>{
        const update=()=>{
            const target=+counter.dataset.target;
            const c=+counter.innerText;
            const inc=target/100;

            if(c<target){
                counter.innerText=Math.ceil(c+inc);
                setTimeout(update,18);
            }else{
                counter.innerText=target;
            }
        };
        update();
    });

    /* TOP BUTTON */

    const topBtn=document.getElementById("toTop");

    window.addEventListener("scroll",()=>{
        if(window.scrollY>400){
            topBtn.style.display="block";
        }else{
            topBtn.style.display="none";
        }
    });

    topBtn.onclick=()=>{
        window.scrollTo({
            top:0,
            behavior:"smooth"
        });
    };

    /* REVEAL */

    const observer=new IntersectionObserver(entries=>{
        entries.forEach(entry=>{
            if(entry.isIntersecting){
                entry.target.style.opacity=1;
                entry.target.style.transform="translateY(0)";
            }
        });
    });

    document.querySelectorAll(".product-card,.feature,.review").forEach(el=>{
        el.style.opacity=0;
        el.style.transform="translateY(50px)";
        el.style.transition=".8s";
        observer.observe(el);
    });

</script>
<jsp:include page="layout/footer.jsp"/>
</body>


</html>