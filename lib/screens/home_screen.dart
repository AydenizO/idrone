import 'package:flutter/material.dart';
import '../models/listing_item.dart';
import '../constants/enums.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  // GÜNCELLENMİŞ: I DRONE Logo Widget'ı
  Widget _buildIDroneLogoTitle() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
            Icons.local_airport, // Drone ikonu veya başka bir logo simgesi
            color: Colors.white,
            size: 28
        ),
        SizedBox(width: 8),
        Text(
          'I DRONE', // İstenen büyük harfli format
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Başlık olarak sadece I DRONE logosunu kullanır
        title: _buildIDroneLogoTitle(),
        centerTitle: false, // Logo sola hizalı
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // İSTEK: "Popüler Kategoriler" Başlığı BURADAN KALDIRILDI.

            Text(
              'Öne Çıkan İlanlar', // Bu başlık ilan listesi için korunuyor
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            // Mock İlan 1
            _buildListingCard(
              context,
              ListingItem(
                id: '1',
                sellerId: 's1',
                title: 'DJI Mavic 3 Pro',
                description: '3 kameralı profesyonel drone. (Yeni)',
                price: 65000.0,
                category: 'Kamera Drone',
                condition: ItemCondition.newCondition,
                datePosted: DateTime(2024, 11, 1),
                imageUrl: 'https://placehold.co/600x400/007AFF/ffffff?text=Mavic+3+Pro',
                isActive: true,
                categoryId: 'cat_droneler',
              ),
            ),
            const SizedBox(height: 10),

            // Mock İlan 2
            _buildListingCard(
              context,
              ListingItem(
                id: '2',
                sellerId: 's2',
                title: 'Used FPV Drone Kit',
                description: 'Eğlenceli başlangıç FPV kiti. (Kullanılmış)',
                price: 12000.0,
                category: 'FPV Kitleri',
                condition: ItemCondition.usedGood,
                datePosted: DateTime(2024, 10, 25),
                imageUrl: 'https://placehold.co/600x400/FF9500/ffffff?text=FPV+Kit',
                isActive: true,
                categoryId: 'cat_kitler',
              ),
            ),

            // Mock İlan 3
            _buildListingCard(
              context,
              ListingItem(
                id: '3',
                sellerId: 's3',
                title: 'Test İlanı (URL Yok)',
                description: 'URL olmadan listeleme testi.',
                price: 100.0,
                category: 'Test',
                condition: ItemCondition.used,
                datePosted: DateTime(2024, 11, 5),
                imageUrl: '',
                isActive: true,
                categoryId: 'cat_test',
              ),
            ),
          ],
        ),
      ),
      // İlan Verme Butonu (Talep 5)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: İlan Verme Penceresine (Post Listing Screen) yönlendir
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yeni İlan Verme Ekranına Yönlendiriliyor...')),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, ListingItem item) {
    final hasImage = item.imageUrl.isNotEmpty;

    Widget imageWidget = hasImage
        ? Image.network(
      item.imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
      },
    )
        : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);


    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // İlan detay sayfasına gitme navigasyonu
        },
        child: ListTile(
          leading: imageWidget,
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fiyat: ${item.price.toStringAsFixed(2)} TL'),
              Text('Durum: ${item.condition.name}'),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}