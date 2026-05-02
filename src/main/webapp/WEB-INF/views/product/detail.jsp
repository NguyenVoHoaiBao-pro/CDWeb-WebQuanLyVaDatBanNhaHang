<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.name}</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body{
            background:#f8f9fa;
        }

        .card{
            border-radius:15px;
        }

        .product-img{
            height:400px;
            object-fit:cover;
            width:100%;
        }
        .card-hover{
            border-radius:15px;
            overflow:hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        /* 🔥 Phóng to */
        .card-hover:hover{
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        /* ✨ Hiệu ứng lóa sáng */
        .card-hover::before{
            content:"";
            position:absolute;
            top:0;
            left:-100%;
            width:100%;
            height:100%;
            background:linear-gradient(
                    120deg,
                    transparent,
                    rgba(255,255,255,0.4),
                    transparent
            );
            transition:0.5s;
        }

        .card-hover:hover::before{
            left:100%;
        }
        .card-hover img{
            transition:0.3s;
        }

        .card-hover:hover img{
            transform: scale(1.1);
        }


    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container mt-5">

    <div class="row">

        <!-- IMAGE -->
        <div class="col-md-6">

            <c:choose>
                <c:when test="${product.image != null && product.image.startsWith('http')}">
                    <img src="${product.image}"
                         class="product-img rounded shadow"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.jpg'">
                </c:when>

                <c:otherwise>
                    <img src="${pageContext.request.contextPath}${product.image}"
                         class="product-img rounded shadow"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.jpg'">
                </c:otherwise>
            </c:choose>

        </div>

        <!-- INFO -->
        <div class="col-md-6">

            <h2 class="fw-bold">${product.name}</h2>

            <h3 class="text-danger">${product.price} đ</h3>

            <p class="text-muted">${product.description}</p>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/cart/add/${product.id}"
                   class="btn btn-success me-2">
                    🛒 Đặt món
                </a>

                <button class="btn btn-warning">⭐ Đánh giá</button>
            </div>

            <hr>

            <!-- ĐẶT BÀN -->
            <form action="${pageContext.request.contextPath}/reserve" method="post">

                <input name="tableId" class="form-control mb-2" placeholder="ID bàn">

                <input name="time" type="datetime-local" class="form-control mb-2">

                <input name="people" type="number" class="form-control mb-2" placeholder="Số người">

                <button class="btn btn-primary w-100">
                    📅 Đặt bàn
                </button>

            </form>

        </div>
    </div>

    <!-- GỢI Ý -->
    <h4 class="mt-5">🔥 Món gợi ý</h4>

    <div class="row">

        <c:forEach var="p" items="${suggest}">

            <c:if test="${p.id != product.id}">

                <div class="col-md-3 mb-3">
                    <div class="card card-hover p-2 shadow-sm">

                    <c:choose>
                            <c:when test="${p.image != null && p.image.startsWith('http')}">
                                <img src="${p.image}"
                                     class="w-100"
                                     style="height:150px; object-fit:cover;"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:when>

                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}${p.image}"
                                     class="w-100"
                                     style="height:150px; object-fit:cover;"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:otherwise>
                        </c:choose>

                        <h6 class="mt-2">${p.name}</h6>

                        <div class="d-flex justify-content-between align-items-center mt-2">

                            <span class="text-danger fw-bold">
                                ${p.price} đ
                            </span>

                            <a href="${pageContext.request.contextPath}/product/${p.id}"
                               class="btn btn-sm btn-dark">
                                Xem
                            </a>

                        </div>


                    </div>
                </div>

            </c:if>

        </c:forEach>

    </div>

</div>

<!-- FOOTER -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

</body>
</html>
