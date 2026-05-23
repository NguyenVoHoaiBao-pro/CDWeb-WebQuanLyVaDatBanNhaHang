<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Trang chủ — Nhà Hàng Của Chúng Ta");
%>

<jsp:include page="layout/header.jsp"/>

<!-- HERO -->
<section class="hero" id="home">
    <div class="container">
        <h1>TRẢI NGHIỆM<br>ẨM THỰC THƯỢNG HẠNG</h1>
        <p>Nơi hương vị tinh tế gặp không gian sang trọng</p>
        <div class="hero-buttons">
            <a href="<%= ctx %>/tables" class="btn btn-primary-custom btn-lg">Đặt bàn ngay</a>
            <a href="<%= ctx %>/menu" class="btn btn-outline-custom btn-lg">Xem thực đơn</a>
        </div>
    </div>
    <div class="scroll-down" aria-hidden="true">⌄</div>
</section>

<!-- CHATBOT -->
<div id="chat-toggle" onclick="toggleChat()" role="button" aria-label="Mở chat">💬</div>

<div id="chat-box">
    <div id="chat-header">
        <div>🍽️ Luxury AI</div>
        <button type="button" onclick="toggleChat()" aria-label="Đóng">✕</button>
    </div>
    <div id="chat-messages">
        <div class="ai-msg">
            Xin chào 👋<br>
            Tôi có thể giúp gì cho bạn hôm nay?
        </div>
    </div>
    <div id="chat-input-area">
        <input type="text" id="chat-input" placeholder="Nhập tin nhắn...">
        <button type="button" onclick="sendMessage()">Gửi</button>
    </div>
</div>

<!-- PRODUCTS -->
<section class="container py-5" id="menu">
    <h2 class="section-title">MÓN ĂN NỔI BẬT</h2>
    <p class="section-sub">Danh sách món ăn lấy trực tiếp từ database</p>

    <div class="row g-4">
        <c:if test="${not empty list}">
            <c:forEach var="p" items="${list}" begin="0" end="${total - 1}">
                <div class="col-lg-4 col-md-6">
                    <div class="product-card glass-card">
                        <c:choose>
                            <c:when test="${p.image != null && p.image.startsWith('http')}">
                                <img src="${p.image}" alt="${p.name}" onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}" onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </c:otherwise>
                        </c:choose>
                        <div class="product-body">
                            <div class="badge-cat">${p.category}</div>
                            <h4 class="fw-bold mt-2">${p.name}</h4>
                            <p class="text-muted" style="min-height:48px;">${p.description}</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <div class="price">${p.price}đ</div>
                                <a href="${pageContext.request.contextPath}/product/${p.id}"
                                   class="btn btn-primary-custom btn-sm">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <div class="text-center mt-5">
        <a href="<%= ctx %>/menu" class="btn btn-outline-custom">Xem toàn bộ thực đơn</a>
    </div>
</section>

<!-- STATS -->
<section class="stats">
    <div class="container">
        <div class="row text-center g-4">
            <div class="col-6 col-md-3 counter-box">
                <div class="counter" data-target="5000">0</div>
                <p>Khách hàng</p>
            </div>
            <div class="col-6 col-md-3 counter-box">
                <div class="counter" data-target="180">0</div>
                <p>Món ăn</p>
            </div>
            <div class="col-6 col-md-3 counter-box">
                <div class="counter" data-target="25">0</div>
                <p>Đầu bếp</p>
            </div>
            <div class="col-6 col-md-3 counter-box">
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
            <div class="feature glass-card text-center p-4">
                <div class="feature-icon">🍽</div>
                <h4>Ẩm thực cao cấp</h4>
                <p class="text-muted">Nguyên liệu tuyển chọn mỗi ngày.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature glass-card text-center p-4">
                <div class="feature-icon">🚀</div>
                <h4>Phục vụ nhanh</h4>
                <p class="text-muted">Chuẩn nhà hàng 5 sao.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature glass-card text-center p-4">
                <div class="feature-icon">🎵</div>
                <h4>Không gian chill</h4>
                <p class="text-muted">Âm nhạc và ánh sáng sang trọng.</p>
            </div>
        </div>
    </div>
</section>

<!-- REVIEWS -->
<section class="container py-5" id="review">
    <h2 class="section-title">KHÁCH HÀNG NÓI GÌ</h2>
    <p class="section-sub">Hơn 5000 khách hàng hài lòng</p>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="review glass-card">
                <h5 class="text-warning">⭐⭐⭐⭐⭐</h5>
                <p class="text-muted">Món ăn tuyệt vời, không gian quá đẹp.</p>
                <b>— Minh Anh</b>
            </div>
        </div>
        <div class="col-md-4">
            <div class="review glass-card">
                <h5 class="text-warning">⭐⭐⭐⭐⭐</h5>
                <p class="text-muted">Nhân viên cực kỳ thân thiện và chuyên nghiệp.</p>
                <b>— Quốc Bảo</b>
            </div>
        </div>
        <div class="col-md-4">
            <div class="review glass-card">
                <h5 class="text-warning">⭐⭐⭐⭐⭐</h5>
                <p class="text-muted">Tôi sẽ quay lại mỗi tuần.</p>
                <b>— Nhật Nam</b>
            </div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="container py-5" id="contact">
    <div class="cta glass-card">
        <h2 class="display-5 fw-bold">Đặt bàn ngay hôm nay</h2>
        <p class="lead mt-3 text-muted">Trải nghiệm bữa ăn đẳng cấp cùng gia đình</p>
        <a href="<%= ctx %>/tables" class="btn btn-primary-custom btn-lg mt-3 px-5">Đặt bàn</a>
    </div>
</section>

<button class="toTop" id="toTop" type="button" aria-label="Lên đầu trang">↑</button>

<script>window.CHAT_API_URL = "<%= ctx %>/chat";</script>
<script src="<%= ctx %>/js/chatbot.js"></script>

<jsp:include page="layout/footer.jsp"/>
