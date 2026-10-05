-- p01_lingkungan_25430026.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

-- 1. Mengamankan Akun Root
ALTER USER 'root'@'localhost' IDENTIFIED BY '<password_root>';

-- 2. Membuat Database
CREATE DATABASE IF NOT EXISTS klinik_026 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS kopma_026 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Membuat Akun / User
CREATE USER IF NOT EXISTS 'dev_026'@'localhost' IDENTIFIED BY '<password_dev>';
CREATE USER IF NOT EXISTS 'kaylani_25430026'@'localhost' IDENTIFIED BY '<password_kaylani>';
CREATE USER IF NOT EXISTS 'tamu_026'@'localhost' IDENTIFIED BY '<password_tamu>';

-- 4. Mengatur Hak Akses (Privileges)
GRANT ALL PRIVILEGES ON klinik_026.* TO 'dev_026'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'kaylani_25430026'@'localhost';
GRANT SELECT ON kopma_026.* TO 'tamu_026'@'localhost';

-- 5. Menerapkan Perubahan Privileges
FLUSH PRIVILEGES;

-- Rekam perintah Git:
-- Buka CMD lalu ketik ;
-- git init
-- git add README.md p01_lingkungan_25430026.sql
-- git commit -m "p01: inisialisasi repositori dan skrip lingkungan"
-- git remote add origin https://github.com/kaylanieka/basisdata-25430026.git
-- git push -u origin main