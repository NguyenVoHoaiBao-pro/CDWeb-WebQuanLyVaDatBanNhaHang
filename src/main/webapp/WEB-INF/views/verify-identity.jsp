<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.util.IdentityQuiz" %>
<%@ page import="java.util.List" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Xác thực danh tính");
    List<IdentityQuiz.Question> questions = (List<IdentityQuiz.Question>) request.getAttribute("questions");
    if (questions == null) questions = IdentityQuiz.getQuestions();
    Boolean needBooking = (Boolean) request.getAttribute("needBooking");
    if (needBooking == null) needBooking = "1".equals(request.getParameter("need"));
%>
<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1><i class="bi bi-shield-lock"></i> Xác thực khách hàng</h1>
        <p>Trả lời đúng 5 câu hỏi về quy tắc nhà hàng để sử dụng đặt bàn và gọi món</p>
    </div>
</section>

<div class="container py-5" style="max-width:720px;">
    <% if (needBooking) { %>
    <div class="alert alert-info glass-card">Bạn cần hoàn thành bài xác thực trước khi tiếp tục.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="<%= ctx %>/verify-identity" class="box glass-card">
        <% int n = 0;
           for (IdentityQuiz.Question q : questions) {
               n++;
        %>
        <div class="mb-4 pb-3 border-bottom border-secondary">
            <p class="fw-bold mb-2"><%= n %>. <%= q.getText() %></p>
            <% int opt = 0;
               for (String label : q.getOptions()) { %>
            <div class="form-check mb-2">
                <input class="form-check-input" type="radio" name="<%= q.getId() %>" id="<%= q.getId() %>_<%= opt %>" value="<%= opt %>" required>
                <label class="form-check-label" for="<%= q.getId() %>_<%= opt %>"><%= label %></label>
            </div>
            <% opt++; } %>
        </div>
        <% } %>

        <button type="submit" class="btn btn-primary-custom btn-lg w-100">
            <i class="bi bi-check2-circle"></i> Gửi và xác nhận
        </button>
        <a href="<%= ctx %>/profile" class="btn btn-link text-muted w-100 mt-2">Quay lại hồ sơ</a>
    </form>
</div>

<jsp:include page="layout/footer.jsp"/>
