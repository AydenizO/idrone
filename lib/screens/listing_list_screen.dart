// lib/screens/listing_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'new_listing_screen.dart';
import '../models/filter_model.dart';
import 'listing_filter_dialog.dart'; // Bu dosyanın mevcut olduğunu varsayıyoruz.

class ListingListScreen extends StatefulWidget {
  final String categoryTitle;

  const ListingListScreen({super.key, required this.categoryTitle});

  @override
  State<ListingListScreen> createState() => _ListingListScreenState();
}

class _ListingListScreenState extends State<ListingListScreen> {
  // ListingFilterModel'i tutar
  ListingFilterModel _currentFilters = const ListingFilterModel();

  final List<String> mockListings = ['İlan 1', 'İlan 2', 'İlan 3'];

  // Pazar Yeri Kategorileri Kontrolü (Filtre ve İlan Verme için)
  bool get isMarketplaceCategory {
    return widget.categoryTitle == 'Drone Pazarı' ||
        widget.categoryTitle == 'Yedek Parça ve Aksesuar';
  }

  void navigateToNewListing() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => NewListingScreen(categoryTitle: widget.categoryTitle),
    ));
  }

  // Metot: Filtre dialogunu gösterir ve sonuçları günceller
  void _showFilterAndSortDialog() async {
    final newFilters = await showDialog<ListingFilterModel>(
      context: context,
      builder: (context) => ListingFilterDialog(initialFilters: _currentFilters),
    );

    if (newFilters != null && newFilters != _currentFilters) {
      setState(() {
        _currentFilters = newFilters;
        // TODO: Filtreler değişince veriyi yeniden çek
        print('Yeni Pazar Yeri Filtreleri Uygulandı: Marka: ${_currentFilters.selectedBrand}, Model: ${_currentFilters.selectedModel}');
      });
    }
  }

  // Widget: Liste üzerine eklenen filtre çubuğu
  Widget _buildFilterAndSortBar() {
    String brandText = _currentFilters.selectedBrand ?? 'Tüm Markalar';
    String modelText = _currentFilters.selectedModel ?? 'Tüm Modeller';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Filtreler: $brandText, $modelText',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.tune, size: 20),
            label: const Text('Filtrele'),
            onPressed: _showFilterAndSortDialog,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} İlanları'),
        actions: [
          // İlan Verme (+) Butonu (AppBar'da kalır)
          if (isMarketplaceCategory)
            IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: navigateToNewListing,
            ),
        ],
      ),
      body: Column( // Body Column yapıldı
        children: [
          // 🚀 Filtre Çubuğu (Sadece Pazar Yeri için görünür)
          if (isMarketplaceCategory)
            _buildFilterAndSortBar(),

          // Liste içeriğini sarar
          Expanded(
            child: mockListings.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list_alt, size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    'Burada "${widget.categoryTitle}" için ilanlar listelenecektir.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Mevcut Kullanıcı Rolü: ${Provider.of<AuthService>(context).currentUserRole}',
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: mockListings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(mockListings[index]),
                  subtitle: Text('Bu bir ${widget.categoryTitle} ilanıdır.'),
                  onTap: () {
                    // TODO: İlan detay sayfasına yönlendir
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}