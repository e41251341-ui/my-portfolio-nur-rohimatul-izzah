import 'package:flutter/material.dart';

import 'models/portfolio_item.dart';
import 'services/portfolio_api.dart';

class PortfolioPage extends StatefulWidget {
  final VoidCallback onAdd;
  final ValueChanged<PortfolioItem> onEdit;

  const PortfolioPage({
    super.key,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  State<PortfolioPage> createState() =>
      _PortfolioPageState();
}

class _PortfolioPageState
    extends State<PortfolioPage> {
  List<PortfolioItem> items = [];
  bool loading = true;
  String? errorMessage;

  String selectedTechnology =
      'Semua Teknologi';

  final List<String> technologies = const [
    'Semua Teknologi',
    'Flutter',
    'Laravel',
    'React',
    'Python',
    'Java',
    'PHP',
    'MySQL',
    'Figma',
  ];

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data =
          await PortfolioApi.getPortfolio();

      if (!mounted) return;

      setState(() {
        items = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _deleteItem(
    PortfolioItem item,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Karya?',
          ),
          content: Text(
            'Yakin ingin menghapus "${item.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await PortfolioApi.hapusPortfolio(
        item.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Karya berhasil dihapus',
          ),
        ),
      );

      _loadPortfolio();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Gagal menghapus: $e',
          ),
        ),
      );
    }
  }

  List<PortfolioItem> get filteredItems {
    if (selectedTechnology ==
        'Semua Teknologi') {
      return items;
    }

    return items.where((item) {
      return item.technology
          .toLowerCase()
          .contains(
            selectedTechnology.toLowerCase(),
          );
    }).toList();
  }

  Widget _buildImage(
    String path, {
    double height = 210,
  }) {
    if (path.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        child: const Icon(
          Icons.image_outlined,
          size: 60,
        ),
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return const SizedBox(
            height: 210,
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 60,
              ),
            ),
          );
        },
      );
    }

    return Image.network(
      PortfolioApi.getImageUrl(path),
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) {
        return const SizedBox(
          height: 210,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 60,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioCard(
    PortfolioItem item,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildImage(item.imagePath),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.category.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  item.year,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.technology
                      .split(',')
                      .map(
                        (tech) => Chip(
                          label: Text(
                            tech.trim(),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 10),

                Text(
                  item.description,
                  style: const TextStyle(
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            widget.onEdit(item),
                        icon: const Icon(
                          Icons.edit_outlined,
                        ),
                        label:
                            const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Hapus',
                      onPressed: () =>
                          _deleteItem(item),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredItems;

    return RefreshIndicator(
      onRefresh: _loadPortfolio,
      child: ListView(
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
            child: const Row(
              children: [
                Icon(
                  Icons.collections_bookmark,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Projects',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kumpulan karya dan project saya.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Filter berdasarkan teknologi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue:
                selectedTechnology,
            decoration:
                const InputDecoration(
              prefixIcon: Icon(
                Icons.filter_alt_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: technologies
                .map(
                  (tech) => DropdownMenuItem(
                    value: tech,
                    child: Text(tech),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedTechnology = value;
              });
            },
          ),

          const SizedBox(height: 16),

          Text(
            'Data portfolio dari database: ${items.length} project',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .primary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (loading)
            const Center(
              child: Padding(
                padding:
                    EdgeInsets.all(40),
                child:
                    CircularProgressIndicator(),
              ),
            )
          else if (errorMessage != null)
            Card(
              color: Colors.red.withOpacity(0.08),
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      color: Colors.red,
                      size: 55,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal mengambil data portfolio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed:
                          _loadPortfolio,
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      label:
                          const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          else if (filtered.isEmpty)
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Icon(
                      Icons.work_off_outlined,
                      size: 60,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Belum ada karya',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filtered.map(
              (item) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 18,
                ),
                child:
                    _buildPortfolioCard(item),
              ),
            ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah Portofolio Baru',
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}