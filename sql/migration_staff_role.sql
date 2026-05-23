-- Phân quyền nhân viên (STAFF) + metadata đặt bàn tại quầy
-- Chạy trên database nhahang

USE nhahang;

-- Vai trò: users.role = 'USER' | 'STAFF' | 'ADMIN' (varchar, không cần đổi kiểu)

-- Cột xác thực (nếu chưa có từ migration trước)
SET @has_iv = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'identity_verified'
);
SET @sql_iv = IF(@has_iv = 0,
    'ALTER TABLE users ADD COLUMN identity_verified TINYINT(1) NOT NULL DEFAULT 0 AFTER role,
     ADD COLUMN identity_verified_at DATETIME NULL AFTER identity_verified',
    'SELECT 1');
PREPARE s1 FROM @sql_iv; EXECUTE s1; DEALLOCATE PREPARE s1;

UPDATE users SET identity_verified = 1, identity_verified_at = NOW()
WHERE role IN ('ADMIN', 'STAFF');

-- Metadata đặt bàn cho nhân viên
SET @has_bs = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reservations' AND COLUMN_NAME = 'booking_source'
);
SET @sql_bs = IF(@has_bs = 0,
    'ALTER TABLE reservations
        ADD COLUMN booking_source VARCHAR(20) NOT NULL DEFAULT ''ONLINE'' COMMENT ''ONLINE|STAFF'' AFTER status,
        ADD COLUMN guest_name VARCHAR(100) NULL COMMENT ''Tên khách walk-in'' AFTER booking_source,
        ADD COLUMN staff_adjusted_at DATETIME NULL AFTER guest_name,
        ADD COLUMN staff_adjusted_by INT NULL COMMENT ''users.id nhân viên'' AFTER staff_adjusted_at',
    'SELECT 1');
PREPARE s2 FROM @sql_bs; EXECUTE s2; DEALLOCATE PREPARE s2;

-- FK tùy chọn (bỏ qua nếu lỗi)
-- ALTER TABLE reservations ADD CONSTRAINT fk_res_staff FOREIGN KEY (staff_adjusted_by) REFERENCES users(id);

CREATE INDEX IF NOT EXISTS idx_res_day_table
    ON reservations (table_id, reservation_start_time);

SELECT id, username, role, identity_verified FROM users;
