<%@ page contentType="text/html;charset=UTF-8" %>

<h2 class="mb-4 fw-bold">➕ Thêm bàn mới</h2>

<div class="card-box" style="max-width:500px;">
    <form action="${pageContext.request.contextPath}/admin/add-table"
          method="post">

        <div class="mb-3">
            <label class="form-label">Tên bàn</label>
            <input type="text"
                   name="name"
                   class="form-control"
                   placeholder="VD: Bàn VIP 1"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Sức chứa</label>
            <input type="number"
                   name="capacity"
                   class="form-control"
                   min="1"
                   required>
        </div>
        <div class="mb-3">

            <label class="form-label">
                Tầng
            </label>

            <select name="floorNumber"
                    class="form-select">

                <option value="0">
                    Tầng Trệt
                </option>

                <option value="1">
                    Tầng 1
                </option>

                <option value="2">
                    Tầng 2
                </option>

            </select>

        </div>

        <div class="d-flex gap-2">

            <button class="btn btn-success">
                Lưu
            </button>

            <a href="${pageContext.request.contextPath}/admin/tables"
               class="btn btn-secondary">
               Quay lại
            </a>

        </div>

    </form>
</div>
