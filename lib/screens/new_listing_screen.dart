// lib/screens/new_listing_screen.dart (SON DÜZELTME VE İYİLEŞTİRME: Pilot Hizmet Alanları Eklendi)

import 'dart:io'; // File kullanmak için
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Fotoğraf seçmek için gerekli

class NewListingScreen extends StatefulWidget {
  static const routeName = '/new-listing';

  // listing_list_screen.dart'tan gelen categoryTitle parametresi
  final String categoryTitle;

  const NewListingScreen({
    super.key,
    required this.categoryTitle, // Zorunlu hale getirildi
  });

  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _serviceDuration = ''; // Yeni: Hizmet Süresi
  String _serviceRegion = ''; // Yeni: Hizmet Bölgesi

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Galeriden veya kameradan fotoğraf seçme metodu
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        if (_selectedImages.length < 5) {
          _selectedImages.add(File(pickedFile.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maksimum 5 fotoğraf ekleyebilirsiniz.')),
          );
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ilanınıza en az bir fotoğraf ekleyin.')),
      );
      return;
    }

    // 🚀 Bilgileri Kaydetme Simulasyonu
    debugPrint('İlan Başlığı: $_title');
    debugPrint('Kategori: ${widget.categoryTitle}');
    debugPrint('Açıklama: $_description');
    debugPrint('Fiyat: $_price TL');
    debugPrint('Hizmet Süresi: $_serviceDuration');
    debugPrint('Hizmet Bölgesi: $_serviceRegion');
    debugPrint('Toplam Fotoğraf Sayısı: ${_selectedImages.length}');

    // TODO: Gerçekte buradan ListingService ile ilan verileri gönderilecektir.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İlanınız başarıyla oluşturuldu ve incelenmeye alındı!')),
    );
    Navigator.of(context).pop();
  }

  Widget _buildIDroneWatermark() {
    return const Padding(
      padding: EdgeInsets.all(5.0),
      child: Opacity(
        opacity: 0.4,
        child: Text(
          'I DRONE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotoğraflar (${_selectedImages.length}/5)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _selectedImages.length < 5 ? () => _pickImage(ImageSource.gallery) : null,
              icon: const Icon(Icons.photo_library),
              label: const Text('Galeriden Seç'),
            ),
            ElevatedButton.icon(
              onPressed: _selectedImages.length < 5 ? () => _pickImage(ImageSource.camera) : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Kamera'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: _buildIDroneWatermark(),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        if (_selectedImages.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Lütfen en az bir fotoğraf ekleyin.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Başlıkta kategori bilgisi eklendi
        title: Text('${widget.categoryTitle} İlanı Oluştur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // FOTOĞRAF SEÇİM WIDGET'I
              _buildImagePicker(),

              // Kategori Bilgisi Gösterimi
              Text(
                'Kategori: ${widget.categoryTitle}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 15),

              // İlan Başlığı
              TextFormField(
                decoration: const InputDecoration(labelText: 'İlan Başlığı'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen bir başlık girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 15),

              // Açıklama
              TextFormField(
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen bir açıklama girin.';
                  }
                  if (value.length < 10) {
                    return 'Açıklama en az 10 karakter olmalıdır.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 15),

              // Fiyat
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Lütfen geçerli bir fiyat girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              const SizedBox(height: 15),

              // 🚀 YENİ ALAN: Hizmet Süresi (Opsiyonel)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hizmet Süresi (Saat/Gün/Proje)'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _serviceDuration = value ?? '';
                },
              ),
              const SizedBox(height: 15),

              // 🚀 YENİ ALAN: Hizmet Bölgesi/Şehri (Zorunlu)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hizmet Verilecek Ana Şehir/Bölge'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen hizmet vereceğiniz ana bölgeyi belirtin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _serviceRegion = value!;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('İlanı Yayınla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}