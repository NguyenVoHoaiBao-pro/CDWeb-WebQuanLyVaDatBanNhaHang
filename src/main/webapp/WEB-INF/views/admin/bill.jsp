<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt"
           uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>

    <title>Hóa đơn nhà hàng</title>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family: Arial, sans-serif;
        }

        body{

            background:#f5f5f5;
            padding:40px;
        }

        .bill-container{

            width:900px;

            margin:auto;

            background:white;

            border-radius:20px;

            overflow:hidden;

            box-shadow:
                    0 10px 30px rgba(0,0,0,0.15);
        }

        /* =========================
           HEADER
        ========================== */

        .bill-header{

            background:linear-gradient(
                    135deg,
                    #ff512f,
                    #dd2476
            );

            color:white;

            padding:40px;
        }

        .restaurant-name{

            font-size:40px;

            font-weight:bold;

            letter-spacing:2px;
        }

        .restaurant-sub{

            margin-top:10px;

            opacity:0.9;

            font-size:16px;
        }

        .bill-title{

            margin-top:25px;

            font-size:28px;

            font-weight:bold;
        }

        /* =========================
           INFO
        ========================== */

        .bill-info{

            display:flex;

            justify-content:space-between;

            padding:35px 40px;

            border-bottom:1px solid #eee;
        }

        .info-box h3{

            margin-bottom:12px;

            color:#333;
        }

        .info-box p{

            margin:8px 0;

            color:#666;
        }

        /* =========================
           TABLE
        ========================== */

        .bill-table{

            width:100%;

            border-collapse:collapse;
        }

        .bill-table thead{

            background:#222;

            color:white;
        }

        .bill-table th{

            padding:18px;

            font-size:15px;
        }

        .bill-table td{

            padding:18px;

            border-bottom:1px solid #eee;

            text-align:center;

            color:#444;
        }

        .bill-table tbody tr:hover{

            background:#fafafa;
        }

        /* =========================
           TOTAL
        ========================== */

        .total-section{

            padding:40px;

            display:flex;

            justify-content:flex-end;
        }

        .total-box{

            width:320px;

            background:#fafafa;

            border-radius:15px;

            padding:25px;

            box-shadow:
                    inset 0 0 10px rgba(0,0,0,0.03);
        }

        .total-row{

            display:flex;

            justify-content:space-between;

            margin-bottom:15px;

            font-size:18px;
        }

        .grand-total{

            font-size:30px;

            font-weight:bold;

            color:#e53935;

            border-top:2px dashed #ccc;

            padding-top:20px;
        }

        /* =========================
           FOOTER
        ========================== */

        .bill-footer{

            text-align:center;

            padding:35px;

            background:#fafafa;

            color:#777;

            line-height:1.8;
        }

        /* =========================
           ACTION
        ========================== */

        .action{

            text-align:center;

            margin-top:30px;
        }

        .print-btn{

            padding:16px 40px;

            border:none;

            background:linear-gradient(
                    135deg,
                    #36d1dc,
                    #5b86e5
            );

            color:white;

            font-size:18px;

            border-radius:50px;

            cursor:pointer;

            transition:0.3s;
        }

        .print-btn:hover{

            transform:scale(1.05);

            box-shadow:
                    0 10px 20px rgba(0,0,0,0.2);
        }

        /* =========================
           EMPTY
        ========================== */

        .empty{

            padding:80px;

            text-align:center;
        }

        .empty h2{

            color:#555;
        }

        /* =========================
           PRINT
        ========================== */

        @media print{

            body{

                background:white;
                padding:0;
            }

            .action{

                display:none;
            }

            .bill-container{

                width:100%;

                box-shadow:none;

                border-radius:0;
            }
        }

    </style>

</head>

<body>

<c:if test="${bill == null}">

    <div class="bill-container">

        <div class="empty">

            <h2>Chưa có hóa đơn</h2>

        </div>

    </div>

</c:if>

<c:if test="${bill != null}">

    <div class="bill-container">

        <!-- =========================
             HEADER
        ========================== -->

        <div class="bill-header">

            <div class="restaurant-name">
                NHÀ HÀNG CỦA CHÚNG TA
            </div>

            <div class="restaurant-sub">
                Fine Dining Restaurant
            </div>

            <div class="bill-title">
                HÓA ĐƠN THANH TOÁN
            </div>

        </div>

        <!-- =========================
             INFO
        ========================== -->

        <div class="bill-info">

            <div class="info-box">

                <h3>Thông tin hóa đơn</h3>

                <p>
                    <b>Mã hóa đơn:</b>
                    #${bill.id}
                </p>

                <p>
                    <b>Mã đặt bàn:</b>
                    #${bill.reservationId}
                </p>

                <p>
                    <b>Trạng thái:</b>
                        ${bill.paymentStatus}
                </p>

            </div>

            <div class="info-box">

                <h3>Thông tin nhà hàng</h3>

                <p>Địa chỉ: TP.HCM</p>

                <p>Hotline: 0123456789</p>

                <p>Email: nhahang@gmail.com</p>

            </div>

        </div>

        <!-- =========================
             TABLE
        ========================== -->

        <table class="bill-table">

            <thead>

            <tr>

                <th>#</th>

                <th>Tên món</th>

                <th>Số lượng</th>

                <th>Đơn giá</th>

                <th>Thành tiền</th>

            </tr>

            </thead>

            <tbody>

            <c:forEach items="${details}"
                       var="d"
                       varStatus="s">

                <tr>

                    <td>${s.index + 1}</td>

                    <td>${d.productName}</td>

                    <td>${d.quantity}</td>

                    <td>

                        <fmt:formatNumber
                                value="${d.price}"
                                type="number"
                                groupingUsed="true"/>

                        VNĐ

                    </td>

                    <td>

                        <fmt:formatNumber
                                value="${d.price * d.quantity}"
                                type="number"
                                groupingUsed="true"/>

                        VNĐ

                    </td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

        <!-- =========================
             TOTAL
        ========================== -->

        <div class="total-section">

            <div class="total-box">

                <div class="total-row">

                    <span>Tạm tính:</span>

                    <span>

                        <fmt:formatNumber
                                value="${bill.total}"
                                type="number"
                                groupingUsed="true"/>

                        VNĐ

                    </span>

                </div>

                <div class="total-row">

                    <span>VAT:</span>

                    <span>0%</span>

                </div>

                <div class="total-row grand-total">

                    <span>TỔNG:</span>

                    <span>

                        <fmt:formatNumber
                                value="${bill.total}"
                                type="number"
                                groupingUsed="true"/>

                        VNĐ

                    </span>

                </div>

            </div>

        </div>

        <!-- =========================
             FOOTER
        ========================== -->

        <div class="bill-footer">

            <h3>
                Cảm ơn quý khách ❤️
            </h3>

            <p>
                Chúc quý khách ngon miệng
                và hẹn gặp lại!
            </p>

        </div>

    </div>

    <!-- =========================
    ACTION
    ========================== -->

    <div class="action">

        <button
                class="print-btn"
                onclick="window.print()">

            🖨 IN HÓA ĐƠN

        </button>

    </div>

</c:if>

</body>
</html>