class PortfolioItem {
  final int id;
  final String title;
  final String category;
  final String year;
  final String technology;
  final String description;
  final String imagePath;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.category,
    required this.year,
    required this.technology,
    required this.description,
    required this.imagePath,
  });

  // ============================================================
  // JSON -> OBJECT
  // ============================================================

  factory PortfolioItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return PortfolioItem(
      // Database PHP/MySQL kadang mengirim id sebagai
      // String "1", jadi kita ubah dulu menjadi int.
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      title: json['nama']?.toString() ?? '',

      category:
          json['kategori']?.toString() ?? '',

      year:
          json['tahun']?.toString() ?? '',

      technology:
          json['teknologi']?.toString() ?? '',

      description:
          json['deskripsi']?.toString() ?? '',

      imagePath:
          json['gambar']?.toString() ?? '',
    );
  }

  // ============================================================
  // OBJECT -> JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': title,
      'kategori': category,
      'tahun': year,
      'teknologi': technology,
      'deskripsi': description,
      'gambar': imagePath,
    };
  }
}