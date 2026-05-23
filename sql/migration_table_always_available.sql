-- Bàn luôn hiển thị: trạng thái bàn không còn chặn đặt theo khung giờ.
-- Lịch đặt chỉ kiểm tra qua bảng reservations (overlap + delay dọn).

USE nhahang;

UPDATE restaurant_tables SET status = 'AVAILABLE';
