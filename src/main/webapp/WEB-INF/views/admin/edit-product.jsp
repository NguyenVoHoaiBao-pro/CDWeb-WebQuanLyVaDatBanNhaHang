<%--
  Created by IntelliJ IDEA.
  User: TGDD
  Date: 14/05/2026
  Time: 17:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>

<%
  Product p = (Product) request.getAttribute("product");
%>

<div class="container py-5">

  <div class="card p-4 shadow">

    <h2 class="mb-4">
      ✏️ Chỉnh sửa món ăn
    </h2>

    <form action="<%=request.getContextPath()%>/admin/update-product"
          method="post">

      <input type="hidden"
             name="id"
             value="<%=p.getId()%>">

      <div class="mb-3">

        <label>Tên món</label>

        <input type="text"
               name="name"
               class="form-control"
               value="<%=p.getName()%>">

      </div>

      <div class="mb-3">

        <label>Giá</label>

        <input type="number"
               name="price"
               class="form-control"
               value="<%=p.getPrice()%>">

      </div>

      <div class="mb-3">

        <label>Mô tả</label>

        <textarea name="description"
                  class="form-control"
                  rows="4"><%=p.getDescription()%></textarea>

      </div>

      <div class="mb-3">

        <label>Ảnh</label>

        <input type="text"
               name="image"
               class="form-control"
               value="<%=p.getImage()%>">

      </div>

      <div class="mb-3">

        <label>Danh mục</label>

        <input type="text"
               name="category"
               class="form-control"
               value="<%=p.getCategory()%>">

      </div>

      <!-- AI -->

      <div class="mb-3">

        <label>Từ khóa AI</label>

        <input type="text"
               name="aiKeywords"
               class="form-control"
               value="<%=p.getAiKeywords()%>">

      </div>

      <div class="mb-3">

        <label>Mô tả AI</label>

        <textarea name="aiDescription"
                  class="form-control"
                  rows="4"><%=p.getAiDescription()%></textarea>

      </div>

      <button class="btn btn-warning">
        Cập nhật
      </button>

    </form>

  </div>

</div>