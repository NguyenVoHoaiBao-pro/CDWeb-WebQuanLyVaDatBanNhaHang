<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<div class="container mt-5">
    <form action="login" method="post" class="card p-4 shadow">
        <h3 class="mb-3">Đăng nhập</h3>

        <input class="form-control mb-2" name="username" placeholder="Username">
        <input class="form-control mb-2" type="password" name="password" placeholder="Password">

        <button class="btn btn-primary">Login</button>

        <p class="text-danger mt-2">${error}</p>
    </form>
</div>