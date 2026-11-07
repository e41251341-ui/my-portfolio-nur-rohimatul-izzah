CREATE DATABASE IF NOT EXISTS my_portfolio_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE my_portfolio_db;

CREATE TABLE IF NOT EXISTS portfolios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  year VARCHAR(4) NOT NULL,
  technology VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  imagePath VARCHAR(500) NOT NULL DEFAULT '',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Contoh data awal. Jalankan skrip ini sekali saat menyiapkan database.
INSERT INTO portfolios (category, title, year, technology, description, imagePath) VALUES
('Website', 'KerjaKu', '2026', 'React, PHP', 'Website bertema informasi pekerjaan. Gambar ini digunakan sebagai contoh tampilan project website.', 'assets/images/kerjaku.png'),
('Mobile App', 'Seblak Say Cafe', '2026', 'Flutter', 'Aplikasi mobile untuk menampilkan menu dan mendukung proses pemesanan Seblak Say Cafe.', 'assets/images/seblak.jpg'),
('UI/UX', 'UI/UX Seblak Say Cafe', '2026', 'Figma, Flutter', 'Contoh tampilan antarmuka Seblak Say Cafe yang digunakan untuk menjelaskan rancangan UI/UX.', 'assets/images/seblak.jpg'),
('Mobile App', 'MATSANAM E-Learning', '2026', 'Flutter', 'Project aplikasi pembelajaran mobile untuk menampilkan informasi dan materi pembelajaran.', ''),
('Mobile App', 'My Portfolio', '2026', 'Flutter', 'Aplikasi portfolio mahasiswa yang menampilkan profil dan kumpulan karya dalam satu aplikasi.', 'assets/images/foto_profil.jpg');
