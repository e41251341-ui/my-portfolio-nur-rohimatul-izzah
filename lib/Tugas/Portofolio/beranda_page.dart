import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaPage extends StatelessWidget {
  final VoidCallback onPortfolioTap;

  const BerandaPage({
    super.key,
    required this.onPortfolioTap,
  });

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      final bool success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        throw Exception(
          'Tidak dapat membuka link',
        );
      }
    } catch (e) {
      debugPrint(
        'Gagal membuka $url : $e',
      );
    }
  }

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
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/foto_profil.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Nur Rohimatul Izzah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'E41251341',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'D4 Teknik Informatika',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Politeknik Negeri Jember',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          'Tentang Saya',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Saya adalah mahasiswa D4 Teknik Informatika yang tertarik pada pengembangan aplikasi mobile, website, UI/UX, dan teknologi informasi.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPortfolioTap,
            icon: const Icon(
              Icons.work_outline,
            ),
            label: const Text(
              'Lihat My Projects',
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Media Sosial & Kontak',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        _socialCard(
          context,
          icon: Icons.camera_alt_outlined,
          title: 'Instagram',
          subtitle: '@n.rhmaaiz',
          onTap: () => _openUrl(
            'https://www.instagram.com/n.rhmaaiz/',
          ),
        ),

        _socialCard(
          context,
          icon: Icons.music_note,
          title: 'TikTok',
          subtitle: '@rhmaaiz',
          onTap: () => _openUrl(
            'https://www.tiktok.com/@rhmaaiz',
          ),
        ),

        _socialCard(
          context,
          icon: Icons.chat_outlined,
          title: 'WhatsApp',
          subtitle: '085784620746',
          onTap: () => _openUrl(
            'https://wa.me/6285784620746',
          ),
        ),

        _socialCard(
          context,
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle:
              'e41251341@student.polije.ac.id',
          onTap: () => _openUrl(
            'mailto:e41251341@student.polije.ac.id?subject=Kontak%20dari%20Portfolio',
          ),
        ),

        _socialCard(
          context,
          icon: Icons.code,
          title: 'GitHub',
          subtitle: 'e41251341-ui',
          onTap: () => _openUrl(
            'https://github.com/e41251341-ui',
          ),
        ),

        const SizedBox(height: 25),
      ],
    );
  }

  Widget _socialCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.open_in_new,
        ),
      ),
    );
  }
}