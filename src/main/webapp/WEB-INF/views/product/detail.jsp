<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    request.setAttribute("pageTitle", "Chi tiết món — Nhà Hàng Của Chúng Ta");
%>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container py-5">

    <c:choose>
        <c:when test="${product == null}">
            <div class="text-center py-5 glass-card">
                <i class="bi bi-exclamation-circle display-1 text-muted"></i>
                <h2 class="mt-3">Không tìm thấy món ăn</h2>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom mt-3">
                    Quay lại thực đơn
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="detail-box glass-card">
                <div class="row g-0">
                    <div class="col-lg-6">
                        <c:choose>
                            <c:when test="${product.image != null && product.image.startsWith('http')}">
                                <img src="${product.image}" class="product-img" alt="${product.name}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${product.image}" class="product-img" alt="${product.name}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="col-lg-6 p-4 p-lg-5">
                        <div class="tag mb-3">${product.category}</div>
                        <h1 class="fw-bold mb-3">${product.name}</h1>
                        <div class="price mb-4">${product.price} đ</div>
                        <p class="text-muted mb-4" style="line-height:1.8">${product.description}</p>

                        <div class="d-grid gap-3">
                            <button type="button"
                                    class="btn btn-primary-custom btn-lg"
                                    data-add-cart="${product.id}">
                                <i class="bi bi-cart-plus"></i> Thêm vào giỏ hàng
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-custom">
                                <i class="bi bi-arrow-left"></i> Quay lại thực đơn
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <h3 class="fw-bold mt-5 mb-4 section-title" style="text-align:left;font-size:1.5rem;">🔥 Món gợi ý</h3>

            <div class="suggest-grid">
                <c:forEach var="p" items="${suggest}">
                    <c:if test="${p.id != product.id}">
                        <div class="card-hover glass-card">
                            <c:choose>
                                <c:when test="${p.image != null && p.image.startsWith('http')}">
                                    <img src="${p.image}" alt="${p.name}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body d-flex flex-column">
                                <h6 class="fw-bold">${p.name}</h6>
                                <div class="price mb-3" style="font-size:1rem;">${p.price} đ</div>
                                <div class="d-grid gap-2 mt-auto">
                                    <a href="${pageContext.request.contextPath}/product/${p.id}" class="btn btn-dark btn-sm">Xem</a>
                                    <button type="button" class="btn btn-primary-custom btn-sm" data-add-cart="${p.id}">Thêm</button>
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
