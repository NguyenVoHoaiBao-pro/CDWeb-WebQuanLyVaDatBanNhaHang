<%@ page contentType="text/html;charset=UTF-8" %>

<h2 class="mb-4 fw-bold">➕ Add New Table</h2>

<div class="card-box" style="max-width:500px;">
    <form action="${pageContext.request.contextPath}/admin/add-table"
          method="post">

        <div class="mb-3">
            <label class="form-label">Table Name</label>
            <input type="text"
                   name="name"
                   class="form-control"
                   placeholder="VD: Bàn VIP 1"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Capacity</label>
            <input type="number"
                   name="capacity"
                   class="form-control"
                   min="1"
                   required>
        </div>

        <div class="d-flex gap-2">

            <button class="btn btn-success">
                Save
            </button>

            <a href="${pageContext.request.contextPath}/admin/tables"
               class="btn btn-secondary">
                Back
            </a>

        </div>

    </form>
</div>
