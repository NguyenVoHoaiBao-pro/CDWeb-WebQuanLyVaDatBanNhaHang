<%@ page contentType="text/html;charset=UTF-8" %>

<div class="card-box mx-auto" style="max-width:600px">

    <h3 class="mb-4">➕ Thêm sản phẩm</h3>

    <form action="${pageContext.request.contextPath}/admin/add-product"
          method="post">

        <label>Tên món</label>
        <input name="name"
               class="form-control mb-3"
               required>

        <label>Giá</label>
        <input type="number"
               name="price"
               class="form-control mb-3"
               required>

        <label>Danh mục</label>
        <input name="category"
               class="form-control mb-3"
               required>

        <label>Link ảnh</label>
        <input name="image"
               class="form-control mb-3"
               required>

        <label>Mô tả</label>
        <textarea name="description"
                  class="form-control mb-3"></textarea>

        <!-- AI -->

        <label>Từ khóa AI</label>
        <input type="text"
               name="aiKeywords"
               class="form-control mb-3"
               placeholder="cay,hải sản,bò,mì">

        <label>Mô tả AI</label>
        <textarea name="aiDescription"
                  class="form-control mb-3"
                  rows="4"></textarea>

        <button class="btn btn-success w-100">
            Lưu
        </button>

    </form>

</div>