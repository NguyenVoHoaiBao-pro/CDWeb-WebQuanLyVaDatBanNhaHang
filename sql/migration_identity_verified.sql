-- Xác thực danh tính (Dump20260523 (2) chưa có cột này)
-- Chạy trên database nhahang HOẶC để app tự ALTER khi có quyền

USE nhahang;

-- An toàn khi chạy nhiều lần (MySQL 8+)
SET @col_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'users'
      AND COLUMN_NAME = 'identity_verified'
);

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE users
        ADD COLUMN identity_verified TINYINT(1) NOT NULL DEFAULT 0
            COMMENT ''1 = da xac thuc qua bai quiz'' AFTER role,
        ADD COLUMN identity_verified_at DATETIME NULL
            COMMENT ''Thoi diem xac thuc'' AFTER identity_verified',
    'SELECT ''identity_verified da ton tai'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE users
SET identity_verified = 1, identity_verified_at = NOW()
WHERE role = 'ADMIN';

-- Kiểm tra
SELECT id, username, role, identity_verified, identity_verified_at FROM users;
