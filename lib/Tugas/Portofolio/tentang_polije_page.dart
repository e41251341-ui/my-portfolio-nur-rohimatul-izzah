import 'package:flutter/material.dart';

class TentangPolijePage extends StatefulWidget {
  const TentangPolijePage({super.key});

  @override
  State<TentangPolijePage> createState() => _TentangPolijePageState();
}

class _TentangPolijePageState extends State<TentangPolijePage> {
  String _selectedDepartment = 'Teknologi Informasi';

  final Map<String, String> _departments = const {
    'Produksi Pertanian': 'Bidang pembelajaran yang berkaitan dengan produksi dan budidaya pertanian.',
    'Teknologi Pertanian': 'Bidang penerapan teknologi pada proses pertanian dan pengolahan hasil.',
    'Peternakan': 'Bidang pembelajaran terapan yang berkaitan dengan peternakan.',
    'Manajemen Agribisnis': 'Bidang pengelolaan usaha dan manajemen agribisnis.',
    'Teknologi Informasi': 'Bidang teknologi informasi, termasuk pengembangan sistem dan aplikasi.',
    'Bahasa, Komunikasi & Pariwisata': 'Bidang bahasa, komunikasi, dan layanan pariwisata.',
    'Kesehatan': 'Bidang pendidikan terapan terkait layanan dan teknologi kesehatan.',
    'Teknik': 'Bidang pendidikan terapan di rumpun teknik.',
    'Bisnis': 'Bidang pembelajaran terapan yang berkaitan dengan kegiatan bisnis.',
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF6546E8), Color(0xFFD946EF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance, color: Colors.white, size: 38),
              SizedBox(height: 12),
              Text('Politeknik Negeri Jember', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Perguruan tinggi vokasi yang mendukung pembelajaran terapan dan pengalaman praktik untuk mempersiapkan mahasiswa menghadapi dunia kerja.', style: TextStyle(color: Colors.white, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _infoCard(
          icon: Icons.location_on_outlined,
          title: 'Lokasi Kampus Pusat',
          content: 'Jl. Mastrip PO BOX 164, Jember, Jawa Timur, Indonesia.',
        ),
        _infoCard(
          icon: Icons.school_outlined,
          title: 'Karakteristik Pendidikan Vokasi',
          content: 'Pendidikan vokasi menekankan penerapan ilmu dan keterampilan praktik. POLIJE juga memiliki fasilitas Teaching Factory (TEFA) untuk mendukung pembelajaran yang terhubung dengan praktik industri.',
        ),
        const SizedBox(height: 6),
        const Text('Kenali Jurusan', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDepartment,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.menu_book_outlined),
          ),
          items: _departments.keys.map((name) => DropdownMenuItem<String>(
            value: name,
            child: Text(name, overflow: TextOverflow.ellipsis),
          )).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedDepartment = value);
          },
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedDepartment, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 6),
                Text(_departments[_selectedDepartment] ?? ''),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Fasilitas dan Kehidupan Kampus', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _infoCard(icon: Icons.local_library_outlined, title: 'Perpustakaan', content: 'Mendukung kegiatan belajar, membaca, penelitian, dan akses sumber pengetahuan.'),
        _infoCard(icon: Icons.local_hospital_outlined, title: 'Klinik Kesehatan', content: 'Fasilitas layanan kesehatan dasar untuk mendukung kebutuhan sivitas kampus.'),
        _infoCard(icon: Icons.hotel_outlined, title: 'Mini Hotel dan Teaching Factory', content: 'Fasilitas praktik yang membantu mahasiswa belajar melalui situasi kerja dan proses produksi yang nyata.'),
        _infoCard(icon: Icons.groups_outlined, title: 'Kegiatan Mahasiswa', content: 'Mahasiswa dapat mengembangkan kemampuan melalui organisasi, UKM, prestasi, kegiatan akademik, dan kegiatan nonakademik.'),
        const SizedBox(height: 12),
        const Text('Sumber informasi resmi', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const SelectableText('https://polije.ac.id/'),
        const SelectableText('https://polije.ac.id/program-studi/'),
        const SelectableText('https://kui.polije.ac.id/student-service/campus-facilities'),
        const SizedBox(height: 18),
        const Text('Informasi kampus dapat berubah. Untuk informasi terbaru, periksa kembali website resmi POLIJE.', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _infoCard({required IconData icon, required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFEDE9FE),
              child: Icon(icon, color: const Color(0xFF6546E8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
