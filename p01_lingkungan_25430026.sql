-- p01_lingkungan_25430026.sql
-- Modifikasi agar skrip dapat dijalankan berulang kali tanpa galat

CREATE DATABASE IF NOT EXISTS kopma_026
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_026'@'localhost' IDENTIFIED BY '<password_kerja>';

GRANT ALL PRIVILEGES ON kopma_026.* TO 'mhs_026'@'localhost';
FLUSH PRIVILEGES;