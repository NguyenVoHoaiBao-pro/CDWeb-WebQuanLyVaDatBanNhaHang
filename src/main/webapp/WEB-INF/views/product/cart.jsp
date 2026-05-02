<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../layout/header.jsp"/>

<div class="container mt-5">

    <h2 class="mb-4">🛒 Giỏ hàng</h2>

    <c:forEach var="p" items="${list}">
        <div class="d-flex justify-content-between align-items-center border rounded p-3 mb-2 shadow-sm">
            <span>${p.name}</span>
            <span class="text-danger fw-bold">${p.price} đ</span>
        </div>
    </c:forEach>

    <hr>

    <form>
        <select class="form-control mb-3">
            <option>Thanh toán trước</option>
            <option>Trả tiền khi đến</option>
        </select>

        <button class="btn btn-success w-100">
            💳 Thanh toán
        </button>
    </form>

</div>

<jsp:include page="../layout/footer.jsp"/>
