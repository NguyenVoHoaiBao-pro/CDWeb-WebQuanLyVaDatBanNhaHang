<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>

<%
  String ctx = request.getContextPath();
  User u = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Admin Panel</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body{
      padding-top:70px;
      background:#f8f9fa;
    }
  </style>
</head>

<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
  <div class="container">

    <a class="navbar-brand" href="<%=ctx%>/admin">⚙ Admin Panel</a>

    <div>
      <a href="<%=ctx%>/" class="btn btn-warning btn-sm">Trang chủ</a>
      <a href="<%=ctx%>/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>

  </div>
</nav>

<div style="height:80px;"></div>