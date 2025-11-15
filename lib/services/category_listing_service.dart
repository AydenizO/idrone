// lib/screens/category_listing_screen.dart

import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/listing_item.dart';
import '../services/listing_service.dart';

class CategoryListingScreen extends StatefulWidget {
  final Category category;

  const CategoryListingScreen({super.key, required this.category});

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  final ListingService _listingService = ListingService();
  List<ListingItem> _listings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final listings = await _listingService.fetchListingsByCategory(widget.category.id);
      setState(() {
        _listings = listings;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Kategori ilanları yüklenirken hata oluştu: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildListingTile(ListingItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag, color: Colors.deepPurple), // Item görseli yerine placeholder
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 🎉 TODO: İlan detay sayfasına yönlendir.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listings.isEmpty
          ? Center(child: Text('${widget.category.name} kategorisinde henüz ilan bulunmamaktadır.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _listings.length,
        itemBuilder: (context, index) {
          return _buildListingTile(_listings[index]);
        },
      ),
    );
  }
}