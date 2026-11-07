import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/portfolio_item.dart';

class PortfolioApi {
  // IP LAPTOP KAMU
  static const String baseUrl =
      'http://localhost/portfolio_api/get_portfolio.php';

  static const Duration timeoutDuration =
      Duration(seconds: 20);

  // ============================
  // GET PORTFOLIO
  // ============================

  static Future<List<PortfolioItem>> getPortfolio() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/get_portfolio.php'),
        )
        .timeout(timeoutDuration);

    if (response.statusCode != 200) {
      throw Exception(
        'Server error: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal mengambil data portfolio',
      );
    }

    final List data = json['data'] ?? [];

    return data
        .map(
          (item) => PortfolioItem.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // ============================
  // TAMBAH PORTFOLIO
  // ============================

  static Future<void> tambahPortfolio(
    PortfolioItem item,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/tambah_portfolio.php'),
          body: {
            'nama': item.title,
            'kategori': item.category,
            'tahun': item.year,
            'teknologi': item.technology,
            'deskripsi': item.description,
            'gambar': item.imagePath,
          },
        )
        .timeout(timeoutDuration);

    final Map<String, dynamic> json =
        jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal menambahkan portfolio',
      );
    }
  }

  // ============================
  // EDIT PORTFOLIO
  // ============================

  static Future<void> editPortfolio(
    PortfolioItem item,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/edit_portfolio.php'),
          body: {
            'id': item.id.toString(),
            'nama': item.title,
            'kategori': item.category,
            'tahun': item.year,
            'teknologi': item.technology,
            'deskripsi': item.description,
            'gambar': item.imagePath,
          },
        )
        .timeout(timeoutDuration);

    final Map<String, dynamic> json =
        jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal mengubah portfolio',
      );
    }
  }

  // ============================
  // HAPUS PORTFOLIO
  // ============================

  static Future<void> hapusPortfolio(int id) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/hapus_portfolio.php'),
          body: {
            'id': id.toString(),
          },
        )
        .timeout(timeoutDuration);

    final Map<String, dynamic> json =
        jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal menghapus portfolio',
      );
    }
  }

  // ============================
  // UPLOAD GAMBAR GALERI
  // ============================

  static Future<String> uploadGambar(
    XFile image,
  ) async {
    final bytes = await image.readAsBytes();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload_gambar.php'),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'gambar',
        bytes,
        filename: image.name,
      ),
    );

    final streamedResponse =
        await request.send().timeout(timeoutDuration);

    final response =
        await http.Response.fromStream(streamedResponse);

    final Map<String, dynamic> json =
        jsonDecode(response.body);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal mengupload gambar',
      );
    }

    return json['gambar']?.toString() ?? '';
  }

  // ============================
  // URL GAMBAR
  // ============================

  static String getImageUrl(String path) {
    if (path.isEmpty) {
      return '';
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return path;
    }

    if (path.startsWith('assets/')) {
      return path;
    }

    return '$baseUrl/$path';
  }
}