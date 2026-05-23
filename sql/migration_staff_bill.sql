-- Hóa đơn nhân viên (mã bill + kênh đặt)
USE nhahang;

ALTER TABLE orders
    ADD COLUMN bill_code VARCHAR(32) NULL COMMENT 'Ma hoa don / QR' AFTER payment_status,
    ADD COLUMN order_channel VARCHAR(20) NOT NULL DEFAULT 'ONLINE' COMMENT 'ONLINE|STAFF' AFTER bill_code;

-- MySQL 8+: CREATE UNIQUE INDEX uk_orders_bill_code ON orders (bill_code);

-- Đơn cũ giữ ONLINE, không bắt buộc backfill bill_code
