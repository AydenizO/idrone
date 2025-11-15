// lib/screens/category_selection_screen.dart (Kategori Seçim Ekranı)

import 'package:flutter/material.dart';
// ServingListingScreen'i import edin. (Bu, elinizdeki serving_listing_screen.dart dosyasına denk gelir)
import 'serving_listing_screen.dart';

// Kategori verileri (Anasayfa ekran görüntüsündeki yapıya eşittir)
class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryItem(this.title, this.icon, this.color);
}

const List<CategoryItem> _categories = [
  CategoryItem('Hava Video ve Fotoğrafçılığı', Icons.videocam, Colors.blue),
  CategoryItem('Drone İlan Pazarı', Icons.storefront, Colors.orange),
  CategoryItem('Tarımsal Drone Hizmetleri', Icons.eco, Colors.green),
  CategoryItem('Kargo ve Taşımacılık', Icons.local_shipping, Colors.teal),
  CategoryItem('Haritalama ve Modelleme', Icons.map, Colors.purple),
  CategoryItem('Reklam Hizmetleri', Icons.campaign, Colors.red),
];


class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  // Kategori kartını oluşturan yardımcı metot
  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    return InkWell(
      onTap: () {
        // 🎉 KRİTİK NAVİGASYON: serving_listing_screen'e yönlendirme
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ServingListingScreen(categoryTitle: category.title),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 40, color: category.color),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Arama Çubuğu
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Hizmet veya ürün ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),

        // Popüler Kategoriler Başlığı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popüler Kategoriler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // Kategori Grid Görünümü
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return _buildCategoryCard(context, _categories[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}