# My Portfolio – Nur Rohimatul Izzah

Aplikasi My Portfolio merupakan aplikasi berbasis Flutter yang dibuat untuk menampilkan profil diri, keterampilan, dan hasil proyek yang telah dikerjakan.

## Identitas Pengembang

- **Nama:** Nur Rohimatul Izzah
- **NIM:** E41251341
- **Program Studi:** D4 Teknik Informatika
- **Perguruan Tinggi:** Politeknik Negeri Jember

## Fitur Aplikasi

1. **Halaman Beranda** – Menampilkan informasi singkat mengenai pengembang.
2. **Halaman Profil** – Menampilkan identitas dan informasi diri.
3. **Halaman Portfolio** – Menampilkan daftar proyek yang telah dibuat.
4. **Kategori Proyek** – Mengelompokkan proyek berdasarkan jenisnya.
5. **Pengaturan** – Menyediakan halaman pengaturan aplikasi.
6. **Database Portfolio** – Menggunakan API PHP dan MySQL untuk mengelola data portfolio.

## Teknologi yang Digunakan

- Flutter
- Dart
- PHP
- MySQL
- REST API
- XAMPP

## Struktur Backend

File backend tersedia di:

`lib/backend/my_portfolio_api/`

File yang tersedia:
- `api.php` – API untuk mengelola data portfolio.
- `database.sql` – Struktur database MySQL.

## Cara Menjalankan Aplikasi

### 1. Persiapan Flutter

Pastikan Flutter SDK sudah terpasang. Buka terminal pada folder project, kemudian jalankan:

```bash
flutter pub get
flutter run
```

### 2. Persiapan Database

1. Jalankan Apache dan MySQL melalui XAMPP.
2. Buka phpMyAdmin melalui `http://localhost/phpmyadmin`.
3. Buat atau impor database sesuai file `database.sql`.
4. Pastikan konfigurasi koneksi database pada API sudah sesuai.

### 3. Persiapan API

1. Salin file API ke folder `C:\xampp\htdocs\portfolio_api`.
2. Pastikan nama file dan alamat API sesuai dengan konfigurasi pada aplikasi Flutter.
3. Jalankan Apache dan MySQL.
4. Pastikan API dapat diakses melalui browser.

## Repository

Source code project dapat dilihat melalui GitHub:

https://github.com/e41251341-ui/my-portfolio-nur-rohimatul-izzah

**Dibuat oleh Nur Rohimatul Izzah**  
Politeknik Negeri Jember – D4 Teknik Informatika