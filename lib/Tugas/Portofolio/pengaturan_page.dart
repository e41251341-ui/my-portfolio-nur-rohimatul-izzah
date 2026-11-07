import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const PengaturanPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF6546E8),
                Color(0xFFD946EF),
              ],
            ),
            borderRadius:
                BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
                size: 45,
              ),
              SizedBox(height: 12),
              Text(
                'Pengaturan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Atur tampilan aplikasi sesuai kebutuhan.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Card(
          child: SwitchListTile(
            value: isDarkMode,
            onChanged: onThemeChanged,
            secondary: Icon(
              isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: const Text(
              'Mode Gelap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              isDarkMode
                  ? 'Mode gelap sedang aktif'
                  : 'Mode terang sedang aktif',
            ),
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: const Text(
              'Tentang Aplikasi',
            ),
            subtitle: const Text(
              'My Portfolio - Nur Rohimatul Izzah',
            ),
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: const Icon(
              Icons.school_outlined,
            ),
            title: const Text(
              'Program Studi',
            ),
            subtitle: const Text(
              'D4 Teknik Informatika',
            ),
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: ListTile(
            leading: const Icon(
              Icons.badge_outlined,
            ),
            title: const Text(
              'NIM',
            ),
            subtitle: const Text(
              'E41251341',
            ),
          ),
        ),
      ],
    );
  }
}