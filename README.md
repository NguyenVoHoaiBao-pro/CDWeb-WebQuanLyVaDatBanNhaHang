# Hệ Thống Quản Lý Nhà Hàng Và Đặt Bàn Trực Tuyến

## Giới thiệu đề tài

Hệ thống quản lý nhà hàng và đặt bàn trực tuyến là một website được xây dựng nhằm hỗ trợ số hóa quy trình quản lý hoạt động trong nhà hàng. Hệ thống cho phép khách hàng có thể xem thực đơn, tìm kiếm món ăn, đặt bàn trực tuyến, gọi món và theo dõi trạng thái đặt bàn ngay trên website.

Bên cạnh đó, hệ thống còn cung cấp khu vực quản trị dành cho admin để quản lý món ăn, bàn ăn, người dùng, hóa đơn và các đơn đặt bàn một cách thuận tiện và hiệu quả.

Dự án được phát triển theo mô hình MVC bằng Java Web, áp dụng các công nghệ như Servlet, JSP, JDBC, AJAX và MySQL nhằm tạo ra một hệ thống có tính thực tiễn cao, phù hợp để làm đồ án môn học hoặc dự án báo cáo Java Web.

---

# Thông tin đồ án

## Tên đề tài

Hệ thống quản lý nhà hàng và đặt bàn trực tuyến

## Sinh viên thực hiện

| Họ tên | MSSV |
|---|---|
| Nguyễn Võ Hoài Bảo | 22130022 |
| Lê Bá Khánh Duy | 22130058 |

## Giảng viên hướng dẫn

LÊ PHI HÙNG

---

# Mục tiêu của hệ thống

Hệ thống được xây dựng với các mục tiêu chính sau:

- Xây dựng website quản lý nhà hàng theo mô hình MVC.
- Hỗ trợ khách hàng đặt bàn trực tuyến nhanh chóng và thuận tiện.
- Hỗ trợ quản trị viên quản lý bàn ăn, thực đơn và đơn đặt bàn.
- Tăng trải nghiệm người dùng bằng AJAX và Fetch API.
- Quản lý dữ liệu bằng MySQL.
- Áp dụng các kiến thức Java Web đã học vào dự án thực tế.
- Tạo ra sản phẩm có thể demo và báo cáo hoàn chỉnh.

---

# Các công nghệ sử dụng

## Ngôn ngữ lập trình

- Java

## Frontend

- HTML5
- CSS3
- Bootstrap 5
- JavaScript
- AJAX
- Fetch API
- JSP
- JSTL

## Backend

- Java Servlet
- JDBC

## Cơ sở dữ liệu

- MySQL

## Công cụ phát triển

- IntelliJ IDEA
- Apache Tomcat
- MySQL Workbench
- Postman
- Git
- GitHub

---

# Kiến trúc hệ thống

Dự án được xây dựng theo mô hình MVC.

## Model

Bao gồm:

- Các class model
- DAO xử lý dữ liệu
- Kết nối database

Ví dụ:

```text
Product.java
User.java
Reservation.java
CartDAO.java
ProductDAO.java
```

---

## View

Sử dụng:

- JSP
- HTML
- CSS
- Bootstrap
- JavaScript

Để hiển thị giao diện cho người dùng.

---

## Controller

Sử dụng Servlet để:

- Nhận request
- Xử lý logic
- Gọi DAO
- Trả dữ liệu về giao diện

---

# Luồng hoạt động hệ thống

```text
Người dùng
    ↓
JSP / HTML
    ↓
Servlet Controller
    ↓
DAO
    ↓
MySQL Database
    ↓
Trả dữ liệu về View
```

---

# Chức năng của khách hàng

## Đăng ký tài khoản

Người dùng có thể tạo tài khoản mới để sử dụng các chức năng của hệ thống.

Thông tin bao gồm:

- Họ tên
- Email
- Số điện thoại
- Mật khẩu

---

## Đăng nhập

Người dùng đăng nhập để:

- Đặt bàn
- Gọi món
- Theo dõi lịch sử đặt bàn

Hệ thống sử dụng Session để lưu trạng thái đăng nhập.

---

## Xem thực đơn

Khách hàng có thể:

- Xem danh sách món ăn
- Xem hình ảnh món ăn
- Xem giá
- Xem mô tả món ăn

---

## Tìm kiếm món ăn

Người dùng có thể:

- Tìm kiếm theo tên món
- Lọc theo danh mục

Ví dụ:

- Món nướng
- Nước uống
- Hải sản

---

## Xem chi tiết món ăn

Trang chi tiết bao gồm:

- Hình ảnh
- Tên món
- Giá
- Mô tả
- Gợi ý món liên quan

---

## Đặt bàn trực tuyến

Người dùng có thể chọn:

- Ngày đặt
- Giờ đặt
- Số lượng người
- Bàn phù hợp

Hệ thống kiểm tra trạng thái bàn trước khi xác nhận.

---

## Gọi món

Sau khi đặt bàn:

- Người dùng có thể thêm món vào giỏ hàng.
- Tăng hoặc giảm số lượng món ăn.
- Xóa món ăn khỏi giỏ hàng.

---

## Quản lý giỏ hàng

Chức năng bao gồm:

- Thêm món
- Xóa món
- Tăng số lượng
- Giảm số lượng
- Tính tổng tiền

---

## Theo dõi trạng thái đặt bàn

Người dùng có thể xem:

- Chờ xác nhận
- Đã xác nhận
- Chờ thanh toán
- Hoàn thành
- Đã hủy

---

## Xem lịch sử đặt bàn

Hiển thị:

- Thời gian đặt
- Số người
- Danh sách món ăn
- Tổng tiền
- Trạng thái đơn

---

# Chức năng của quản trị viên

## Quản lý người dùng

Admin có thể:

- Xem danh sách người dùng
- Khóa tài khoản
- Xóa tài khoản

---

## Quản lý món ăn

Admin có thể:

- Thêm món ăn
- Chỉnh sửa món ăn
- Xóa món ăn
- Cập nhật hình ảnh
- Quản lý giá

---

## Quản lý danh mục

Bao gồm:

- Thêm danh mục
- Chỉnh sửa danh mục
- Xóa danh mục

---

## Quản lý bàn ăn

Admin có thể:

- Thêm bàn
- Chỉnh sửa bàn
- Xóa bàn
- Cập nhật trạng thái bàn

Ví dụ:

- Trống
- Đang sử dụng
- Đã đặt

---

## Quản lý đơn đặt bàn

Admin có thể:

- Xác nhận đơn
- Hủy đơn
- Hoàn thành đơn
- Theo dõi lịch sử đặt bàn

---

## Quản lý hóa đơn

Bao gồm:

- Xem bill
- Xem món ăn đã gọi
- Tổng tiền
- Trạng thái thanh toán

---

## Thống kê cơ bản

Hệ thống hỗ trợ:

- Thống kê số lượng đơn
- Thống kê doanh thu cơ bản
- Thống kê món ăn phổ biến

---

# AJAX và Fetch API

Hệ thống có sử dụng AJAX và Fetch API để tăng trải nghiệm người dùng.

Các chức năng sử dụng AJAX:

- Tìm kiếm món ăn
- Thêm món vào giỏ hàng
- Cập nhật số lượng món ăn
- Kiểm tra trạng thái bàn
- Gợi ý món ăn

Ưu điểm:

- Không cần reload toàn bộ trang
- Tăng tốc độ xử lý
- Giao diện mượt hơn

---

# Cấu trúc thư mục

```text
src/
├── controller/
├── dao/
├── model/
├── utils/

webapp/
├── assets/
├── css/
├── images/
├── js/
├── WEB-INF/
│   └── views/
```

---

# Hướng dẫn cài đặt

## Bước 1: Clone project

```bash
git clone https://github.com/NguyenVoHoaiBao-pro/CDWeb-WebQuanLyVaDatBanNhaHang.git
```

---

## Bước 2: Import project vào IntelliJ IDEA

- Open Project
- Chọn thư mục project

---

## Bước 3: Tạo database

```sql
CREATE DATABASE nhahang;
```

Sau đó import file SQL vào MySQL.

---

## Bước 4: Cấu hình database

Mở file:

```text
DBConnection.java
```

Sửa thông tin:

```java
private static final String URL =
        "jdbc:mysql://localhost:3306/nhahang";

private static final String USER = "root";

private static final String PASSWORD = "123456";
```

---

## Bước 5: Chạy project

- Deploy bằng Apache Tomcat
- Chạy server
- Truy cập:

```text
http://localhost:8080/
```

---

# Một số giao diện của hệ thống

## Trang chủ

Bao gồm:

- Banner giới thiệu
- Danh sách món ăn
- Thông tin nhà hàng

---

## Trang menu

Hiển thị:

- Hình ảnh món ăn
- Giá
- Danh mục
- Tìm kiếm

---

## Trang đặt bàn

Cho phép:

- Chọn bàn
- Chọn thời gian
- Đặt bàn trực tuyến

---

## Trang admin

Bao gồm:

- Dashboard
- Quản lý món ăn
- Quản lý đơn
- Quản lý người dùng

---

# Kiến thức áp dụng trong dự án

- Java Web MVC
- Servlet/JSP
- JDBC
- Session và Cookie
- CRUD MySQL
- Responsive Design
- AJAX / Fetch API
- Git/GitHub

---

# Hướng phát triển

Trong tương lai hệ thống có thể mở rộng thêm:

- Thanh toán online
- AI gợi ý món ăn
- Chatbot hỗ trợ khách hàng
- QR Code menu
- Gửi email xác nhận
- Dashboard thống kê nâng cao

---

# Kết luận

Hệ thống quản lý nhà hàng và đặt bàn trực tuyến giúp số hóa quy trình quản lý nhà hàng và hỗ trợ khách hàng đặt bàn dễ dàng hơn.

Dự án mang tính thực tế cao và phù hợp để:

- Báo cáo môn học
- Đồ án Java Web
- Demo portfolio
- Thực hành MVC và JDBC

---

# License

Dự án được sử dụng cho mục đích học tập và nghiên cứu.
