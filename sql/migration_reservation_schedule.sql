-- Migration: multi-hour reservations with cleaning buffer
-- Database: nhahang
-- Run once against existing schema (Dump20260523 compatible)

USE nhahang;

-- New time-range columns
ALTER TABLE reservations
    ADD COLUMN reservation_start_time DATETIME NULL AFTER reservation_time,
    ADD COLUMN reservation_end_time DATETIME NULL AFTER reservation_start_time,
    ADD COLUMN cleaning_buffer_until DATETIME NULL AFTER reservation_end_time;

-- Backfill from legacy single-point reservation_time (default 2h stay + 2h cleaning)
UPDATE reservations
SET reservation_start_time = reservation_time,
    reservation_end_time   = DATE_ADD(reservation_time, INTERVAL 2 HOUR),
    cleaning_buffer_until  = DATE_ADD(reservation_time, INTERVAL 4 HOUR)
WHERE reservation_start_time IS NULL
  AND reservation_time IS NOT NULL;

-- Legacy unique constraint blocks multiple bookings per table
ALTER TABLE reservations
    DROP INDEX unique_table_time;

-- Indexes for overlap queries
CREATE INDEX idx_res_table_active
    ON reservations (table_id, cleaning_buffer_until, reservation_start_time);

CREATE INDEX idx_res_start_end
    ON reservations (table_id, reservation_start_time, reservation_end_time);

-- Optional: normalize legacy DONE -> COMPLETED (safe to run multiple times)
UPDATE reservations SET status = 'COMPLETED' WHERE status = 'DONE';

-- Recommended: align MySQL session timezone with JVM (Vietnam)
-- SET GLOBAL time_zone = '+07:00';
-- Or in DBConnection URL: serverTimezone=Asia/Ho_Chi_Minh
