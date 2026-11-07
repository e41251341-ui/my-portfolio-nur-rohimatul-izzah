
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/portfolio_item.dart';

class PortfolioDatabase {
  PortfolioDatabase._internal();

  static final PortfolioDatabase instance =
      PortfolioDatabase._internal();

  // Alamat API PHP XAMPP
  // Digunakan ketika Flutter dijalankan di Chrome
  // pada laptop yang sama dengan XAMPP.
  static const String baseUrl =
      'http://localhost/portfolio_api/get_portfolio.php';

  final Duration timeoutDuration =
      const Duration(seconds: 15);

  // Header request
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Mengubah respons JSON menjadi Map
  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Respons server bukan JSON yang valid.',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format respons API tidak sesuai.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        decoded['message'] ??
            'Terjadi kesalahan pada server.',
      );
    }

    if (decoded['success'] != true) {
      throw Exception(
        decoded['message'] ??
            'Permintaan gagal diproses.',
      );
    }

    return decoded;
  }

  // Mengubah JSON menjadi PortfolioItem
  PortfolioItem _fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id: int.tryParse('${json['id']}') ?? 0,
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      technology: json['technology']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
    );
  }

  // Mengubah PortfolioItem menjadi JSON
  Map<String, dynamic> _toJson(PortfolioItem item) {
    return {
      'category': item.category,
      'title': item.title,
      'year': item.year,
      'technology': item.technology,
      'description': item.description,
      'imagePath': item.imagePath,
    };
  }

  // =========================
  // MENAMPILKAN SEMUA PORTFOLIO
  // =========================

  Future<List<PortfolioItem>> getAllItems() async {
    try {
      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: headers,
          )
          .timeout(timeoutDuration);

      final result = _decodeResponse(response);

      final List<dynamic> data = result['data'] ?? [];

      return data.map((item) {
        return _fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    } catch (e) {
      throw Exception(
        'Gagal mengambil data portfolio: $e',
      );
    }
  }

  // =========================
  // MENAMBAHKAN PORTFOLIO
  // =========================

  Future<int> insertItem(PortfolioItem item) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: headers,
            body: jsonEncode(_toJson(item)),
          )
          .timeout(timeoutDuration);

      final result = _decodeResponse(response);

      final dynamic id = result['id'];

      return id is int
          ? id
          : int.tryParse('$id') ?? 0;
    } catch (e) {
      throw Exception(
        'Gagal menambahkan portfolio: $e',
      );
    }
  }

  // =========================
  // MENGEDIT PORTFOLIO
  // =========================

  Future<int> updateItem(PortfolioItem item) async {
    if (item.id == null) {
      throw ArgumentError(
        'ID portfolio diperlukan untuk mengedit data.',
      );
    }

    try {
      final Map<String, dynamic> data =
          _toJson(item);

      data['id'] = item.id;

      final response = await http
          .put(
            Uri.parse(baseUrl),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(timeoutDuration);

      _decodeResponse(response);

      return 1;
    } catch (e) {
      throw Exception(
        'Gagal memperbarui portfolio: $e',
      );
    }
  }

  // =========================
  // MENGHAPUS PORTFOLIO
  // =========================

  Future<int> deleteItem(int id) async {
    try {
      final Uri uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'id': id.toString(),
        },
      );

      final response = await http
          .delete(
            uri,
            headers: headers,
          )
          .timeout(timeoutDuration);

      _decodeResponse(response);

      return 1;
    } catch (e) {
      throw Exception(
        'Gagal menghapus portfolio: $e',
      );
    }
  }
}