<%@ page contentType="text/html;charset=UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-5">
    <h2>Đặt bàn</h2>

    <form action="reserve" method="post" class="card p-4 shadow">

        <input class="form-control mb-2" name="userId" placeholder="User ID">

        <input class="form-control mb-2" name="tableId" placeholder="Table ID">

        <input class="form-control mb-2" name="time" placeholder="YYYY-MM-DD HH:MM:SS">

        <input class="form-control mb-2" name="people" placeholder="Số người">

        <button class="btn btn-success">Đặt bàn</button>

        <p class="text-danger">${error}</p>
    </form>
</div>