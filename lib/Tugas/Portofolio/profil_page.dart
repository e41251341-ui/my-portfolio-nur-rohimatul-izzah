import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6546E8), width: 3),
              image: const DecorationImage(
                image: AssetImage('assets/images/foto_profil.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text('Nur Rohimatul Izzah', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const Center(child: Text('Mahasiswa Teknik Informatika', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 24),
        _infoTile(Icons.badge_outlined, 'NIM', 'E41251341'),
        _infoTile(Icons.school_outlined, 'Program Studi', 'D4 Teknik Informatika'),
        _infoTile(Icons.account_balance_outlined, 'Perguruan Tinggi', 'Politeknik Negeri Jember'),
        _infoTile(Icons.code_outlined, 'Bidang yang diminati', 'Mobile App, Website, dan UI/UX'),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEDE9FE),
          child: Icon(icon, color: const Color(0xFF6546E8)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    );
  }
}
