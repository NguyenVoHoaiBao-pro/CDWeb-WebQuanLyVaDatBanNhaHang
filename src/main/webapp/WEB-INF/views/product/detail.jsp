<!-- FILE: WEB-INF/views/product/detail.jsp -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.name}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container py-5">

    <c:choose>

        <c:when test="${product == null}">

            <div class="text-center py-5">
                <h2>Không tìm thấy món ăn</h2>

                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-dark mt-3">
                    Quay lại thực đơn
                </a>
            </div>

        </c:when>

        <c:otherwise>

            <div class="detail-box">

                <div class="row g-0">

                    <!-- IMAGE -->
                    <div class="col-lg-6">

                        <c:choose>

                            <c:when test="${product.image != null && product.image.startsWith('http')}">
                                <img src="${product.image}"
                                     class="product-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default.jpg'">
                            </c:when>

                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}${product.image}"
                                     class="product-img"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default.jpg'">
                            </c:otherwise>

                        </c:choose>

                    </div>

                    <!-- INFO -->
                    <div class="col-lg-6 p-5">

                        <div class="tag mb-3">
                                ${product.category}
                        </div>

                        <h1 class="fw-bold mb-3">
                                ${product.name}
                        </h1>

                        <div class="price mb-4">
                                ${product.price} đ
                        </div>

                        <p class="text-muted mb-4" style="line-height:1.8">
                                ${product.description}
                        </p>

                        <div class="d-grid gap-3">

                            <a href="${pageContext.request.contextPath}/cart/add?id=${product.id}"
                               class="btn btn-danger btn-lg">
                                🛒 Thêm vào giỏ hàng
                            </a>

                            <a href="${pageContext.request.contextPath}/products"
                               class="btn btn-outline-dark">
                                ← Quay lại thực đơn
                            </a>

                        </div>

                    </div>

                </div>

            </div>

            <!-- GỢI Ý -->
            <h3 class="fw-bold mt-5 mb-4">🔥 Món gợi ý</h3>

            <div class="suggest-grid">

                <c:forEach var="p" items="${suggest}">

                    <c:if test="${p.id != product.id}">

                        <div>

                            <div class="card card-hover">

                                <c:choose>

                                    <c:when test="${p.image != null && p.image.startsWith('http')}">
                                        <img src="${p.image}"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/default.jpg'">
                                    </c:when>

                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}${p.image}"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/default.jpg'">
                                    </c:otherwise>

                                </c:choose>

                                <div class="card-body d-flex flex-column">

                                    <h6 class="fw-bold">${p.name}</h6>

                                    <div class="text-danger fw-bold mb-3">
                                            ${p.price} đ
                                    </div>

                                    <div class="d-grid gap-2">

                                        <a href="${pageContext.request.contextPath}/product/${p.id}"
                                           class="btn btn-dark btn-sm">
                                            Xem
                                        </a>

                                        <a href="${pageContext.request.contextPath}/cart/add?id=${p.id}"
                                           class="btn btn-danger btn-sm">
                                            Thêm
                                        </a>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </c:if>

                </c:forEach>

            </div>

        </c:otherwise>

    </c:choose>

</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

</body>
</html>