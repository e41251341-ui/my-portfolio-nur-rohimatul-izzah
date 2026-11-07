import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/portfolio_item.dart';
import 'services/portfolio_api.dart';

class PortfolioFormPage extends StatefulWidget {
  final PortfolioItem? item;
  final VoidCallback onSaved;
  final VoidCallback onCancel;

  const PortfolioFormPage({
    super.key,
    this.item,
    required this.onSaved,
    required this.onCancel,
  });

  @override
  State<PortfolioFormPage> createState() =>
      _PortfolioFormPageState();
}

class _PortfolioFormPageState
    extends State<PortfolioFormPage> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _yearController =
      TextEditingController();

  final TextEditingController _technologyController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _category = 'Website';

  String _imagePath = '';

  XFile? _selectedImage;

  bool _saving = false;

  final List<String> _categories = const [
    'Website',
    'Mobile App',
    'UI/UX',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _titleController.text =
        item?.title ?? '';

    _yearController.text =
        item?.year ?? '2026';

    _technologyController.text =
        item?.technology ?? 'Flutter';

    _descriptionController.text =
        item?.description ?? '';

    if (item != null) {
      _category =
          _categories.contains(item.category)
              ? item.category
              : 'Lainnya';

      _imagePath = item.imagePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _technologyController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  // ============================
  // PILIH GAMBAR GALERI
  // ============================

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        _selectedImage = image;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal membuka galeri: $e',
          ),
        ),
      );
    }
  }

  // ============================
  // SIMPAN
  // ============================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      String imagePath = _imagePath;

      // Jika user memilih gambar baru
      if (_selectedImage != null) {
        imagePath =
            await PortfolioApi.uploadGambar(
          _selectedImage!,
        );
      }

      final PortfolioItem item =
          PortfolioItem(
        id: widget.item?.id ?? 0,
        title: _titleController.text.trim(),
        category: _category,
        year: _yearController.text.trim(),
        technology:
            _technologyController.text.trim(),
        description:
            _descriptionController.text.trim(),
        imagePath: imagePath,
      );

      if (widget.item == null) {
        await PortfolioApi.tambahPortfolio(item);
      } else {
        await PortfolioApi.editPortfolio(item);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Karya berhasil ditambahkan'
                : 'Karya berhasil diperbarui',
          ),
        ),
      );

      widget.onSaved();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Gagal menyimpan: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================
  // PREVIEW GAMBAR
  // ============================

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return FutureBuilder(
        future: _selectedImage!.readAsBytes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              snapshot.data!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }

    if (_imagePath.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
        ),
        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 60,
            ),
            SizedBox(height: 8),
            Text('Belum ada gambar'),
          ],
        ),
      );
    }

    if (_imagePath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          _imagePath,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return _imageError();
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        PortfolioApi.getImageUrl(_imagePath),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return _imageError();
        },
      ),
    );
  }

  Widget _imageError() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image,
        size: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing =
        widget.item != null;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF6546E8),
                Color(0xFFD946EF),
              ],
            ),
            borderRadius:
                BorderRadius.circular(22),
          ),
          child: Text(
            isEditing
                ? 'Edit Portofolio'
                : 'Tambah Portofolio',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(
                  labelText: 'Nama Karya',
                  prefixIcon:
                      Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama karya harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration:
                    const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon:
                      Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (item) =>
                          DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _yearController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Tahun',
                  prefixIcon:
                      Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Tahun harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller:
                    _technologyController,
                decoration:
                    const InputDecoration(
                  labelText: 'Teknologi',
                  hintText:
                      'Contoh: Flutter, PHP, MySQL',
                  prefixIcon:
                      Icon(Icons.code),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Teknologi harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller:
                    _descriptionController,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText: 'Deskripsi Karya',
                  prefixIcon:
                      Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ========================
              // GAMBAR
              // ========================

              Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Gambar Karya',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),
              ),

              const SizedBox(height: 10),

              _buildImagePreview(),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _saving
                      ? null
                      : _pickImage,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  label: const Text(
                    'Pilih Gambar dari Galeri',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Gambar yang dipilih akan diupload ke server XAMPP.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _saving
                        ? 'Menyimpan...'
                        : isEditing
                            ? 'Simpan Perubahan'
                            : 'Simpan Karya',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed:
                      _saving ? null : widget.onCancel,
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}