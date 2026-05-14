<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>
<%--<%@ page import="vn.edu.hcmuaf.fit.dao.ProductDAO" %>--%>
<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>
<%--<%@ page import="java.util.*" %>--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%
    User u = (User) session.getAttribute("user");
    String ctx = request.getContextPath();

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
    <!-- NÚT CHAT -->
    <div id="chat-toggle" onclick="toggleChat()">
        💬
    </div>

    <!-- CHATBOX -->
    <div id="chat-box">

        <!-- HEADER -->
        <div id="chat-header">

            <div>
                🍽️ Luxury AI
            </div>

            <button onclick="toggleChat()">
                ✕
            </button>

        </div>

        <!-- MESSAGE -->
        <div id="chat-messages">

            <div class="ai-msg">
                Xin chào 👋<br>
                Tôi có thể giúp gì cho bạn hôm nay?
            </div>

        </div>

        <!-- INPUT -->
        <div id="chat-input-area">

            <input
                    type="text"
                    id="chat-input"
                    placeholder="Nhập tin nhắn..."
            >

            <button onclick="sendMessage()">
                Gửi
            </button>

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
<script>

    // MỞ / ĐÓNG CHAT
    function toggleChat(){

        let chatBox =
            document.getElementById("chat-box");

        if(chatBox.style.display === "flex"){

            chatBox.style.display = "none";

        }else{

            chatBox.style.display = "flex";
        }
    }

    // GỬI TIN NHẮN
    function sendMessage(){

        let input =
            document.getElementById("chat-input");

        let msg =
            input.value.trim();

        if(msg === ""){
            return;
        }

        let box =
            document.getElementById("chat-messages");

        // TẠO TIN NHẮN USER
        let userDiv =
            document.createElement("div");

        userDiv.className = "user-msg";

        userDiv.innerText = msg;

        box.appendChild(userDiv);

        box.scrollTop = box.scrollHeight;

        input.value = "";

        fetch("<%=ctx%>/chat", {

            method: "POST",

            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            body:
                "message=" + encodeURIComponent(msg)

        })

            .then(response => response.text())

            .then(data => {

                let aiDiv =
                    document.createElement("div");

                aiDiv.className = "ai-msg";

                aiDiv.innerHTML = data;

                box.appendChild(aiDiv);

                box.scrollTop = box.scrollHeight;
            })

            .catch(error => {

                console.log(error);

                let err =
                    document.createElement("div");

                err.className = "ai-msg";

                err.innerText =
                    "Không kết nối được chatbot";

                box.appendChild(err);
            });
    }function sendMessage(){

        let input =
            document.getElementById("chat-input");

        let msg =
            input.value.trim();

        if(msg === ""){
            return;
        }

        let box =
            document.getElementById("chat-messages");

        // TẠO TIN NHẮN USER
        let userDiv =
            document.createElement("div");

        userDiv.className = "user-msg";

        userDiv.innerText = msg;

        box.appendChild(userDiv);

        box.scrollTop = box.scrollHeight;

        input.value = "";

        fetch("<%=ctx%>/chat", {

            method: "POST",

            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            body:
                "message=" + encodeURIComponent(msg)

        })

            .then(response => response.text())

            .then(data => {

                let aiDiv =
                    document.createElement("div");

                aiDiv.className = "ai-msg";

                aiDiv.innerHTML = data;

                box.appendChild(aiDiv);

                box.scrollTop = box.scrollHeight;
            })

            .catch(error => {

                console.log(error);

                let err =
                    document.createElement("div");

                err.className = "ai-msg";

                err.innerText =
                    "Không kết nối được chatbot";

                box.appendChild(err);
            });
    }

    // ENTER ĐỂ GỬI
    document.addEventListener("DOMContentLoaded",()=>{

        document
            .getElementById("chat-input")
            .addEventListener("keypress",function(e){

                if(e.key === "Enter"){
                    sendMessage();
                }
            });

    });

</script>
<jsp:include page="layout/footer.jsp"/>
</body>


</html>