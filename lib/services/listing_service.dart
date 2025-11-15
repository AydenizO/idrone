// lib/services/listing_service.dart (GÜNCELLENMİŞ NİHAİ KOD)

import 'package:flutter/material.dart'; // Icons için
// Varsayım: Aşağıdaki modellerin var olduğunu varsayıyoruz
import '../models/listing_item.dart';
import '../models/category.dart';
import '../models/service_listing_item.dart'; // ✅ DÜZELTME: Doğru konumdan import
import '../constants/enums.dart';

// Varsayım: ListingItem modeli ItemCondition, Category ve id, title, price vb. içerir.

class ListingService {

  // Mock Kategoriler
  static const List<Category> _mockCategories = [
    Category(id: 'cat_1', name: 'Bataryalar', icon: Icons.battery_charging_full, description: 'Drone bataryaları ve şarj cihazları.'),
    Category(id: 'cat_2', name: 'Gövde ve Şasi', icon: Icons.hardware, description: 'Gövde parçaları, iniş takımları ve şasi bileşenleri.'),
    Category(id: 'cat_3', name: 'Motorlar ve Pervaneler', icon: Icons.build_circle, description: 'Fırçalı/fırçasız motorlar ve pervaneler.'),
    Category(id: 'cat_4', name: 'Kamera ve Gimbal', icon: Icons.videocam, description: '4K kameralar, FPV sistemleri ve dengeleyici birimler.'),
  ];

  // 1. ÜRÜN/PARÇA İLANLARI (USER LISTINGS)
  static final List<ListingItem> _mockListings = [
    ListingItem(
      id: 'list_1',
      title: '5000mAh Lipo Batarya',
      price: 150.0,
      categoryId: 'cat_1',
      description: 'Yüksek kapasiteli, az kullanılmış lipo batarya.',
      sellerId: 'seller1',
      category: 'Bataryalar',
      condition: ItemCondition.used,
      datePosted: DateTime(2025, 10, 1),
      isActive: true,
      imageUrl: 'https://example.com/battery_img.jpg',
    ),
    ListingItem(
      id: 'list_2',
      title: 'Fırçasız Motor Seti',
      price: 250.0,
      categoryId: 'cat_3',
      description: 'Yeni nesil 2207 fırçasız motor seti, 4 adet.',
      sellerId: 'seller2',
      category: 'Motorlar ve Pervaneler',
      condition: ItemCondition.newCondition,
      datePosted: DateTime(2025, 9, 20),
      isActive: true,
      imageUrl: 'https://example.com/motor_img.jpg',
    ),
    ListingItem(
      id: 'list_3',
      title: 'Akıllı Şarj İstasyonu',
      price: 90.0,
      categoryId: 'cat_1',
      description: 'Çoklu şarj portlu akıllı dengeleyici.',
      sellerId: 'seller1',
      category: 'Bataryalar',
      condition: ItemCondition.usedGood,
      datePosted: DateTime(2025, 10, 15),
      isActive: true,
      imageUrl: 'https://example.com/charger_img.jpg',
    ),
    ListingItem(
      id: 'list_4',
      title: 'HD FPV Kamera',
      price: 120.0,
      categoryId: 'cat_4',
      description: 'Düşük gecikmeli FPV kamera ve verici seti.',
      sellerId: 'seller3',
      category: 'Kamera ve Gimbal',
      condition: ItemCondition.refurbished,
      datePosted: DateTime(2025, 8, 5),
      isActive: true,
      imageUrl: 'https://example.com/fpv_img.jpg',
    ),
  ];

  // 2. PİLOT HİZMET İLANLARI (SERVICE LISTINGS)
  static final List<ServiceListingItem> _mockServiceListings = [
    ServiceListingItem(
      id: 'srv_1',
      pilotId: 'pilot_a',
      title: 'Profesyonel 4K Hava Çekimi',
      description: 'Kurumsal tanıtımlar ve etkinlikler için tam gün/yarım gün 4K video hizmeti.',
      category: 'Hava Video ve Fotoğrafçılığı',
      price: 1500.0,
      priceInfo: 'Günlük Ücret',
      serviceRegion: 'İstanbul, İzmir',
      durationInfo: 'Minimum 4 Saat',
      datePosted: DateTime(2025, 10, 25),
    ),
    ServiceListingItem(
      id: 'srv_2',
      pilotId: 'pilot_b',
      title: 'Tarımsal Alan Analizi (İlaçlama Öncesi)',
      description: 'Çoklu spektrumlu sensörlerle bitki sağlığı haritalama hizmeti.',
      category: 'Tarımsal Drone Hizmetleri',
      price: 50.0,
      priceInfo: 'Dönüm Başı',
      serviceRegion: 'Ankara, Konya',
      durationInfo: 'Esnek',
      datePosted: DateTime(2025, 10, 10),
    ),
  ];

  // =======================================================
  // ÜRÜN İLANI METOTLARI
  // =======================================================

  Future<List<Category>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories;
  }

  Future<List<ListingItem>> fetchListingsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockListings.where((item) => item.categoryId == categoryId).toList();
  }

  // =======================================================
  // PİLOT HİZMET İLANI METOTLARI
  // =======================================================

  /// Pilotun hizmet listesini kategoriye göre getirir
  Future<List<ServiceListingItem>> fetchServiceListingsByCategory(String categoryTitle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockServiceListings.where((item) => item.category == categoryTitle).toList();
  }

  /// Yeni bir pilot hizmet ilanını sisteme kaydeder
  Future<bool> createServiceListing({
    required String pilotId,
    required String title,
    required String description,
    required String category,
    required double price,
    required String serviceRegion,
    required String durationInfo,
    required List<String> imageUrls,
    String priceInfo = 'Proje Bazlı',
  }) async {
    final newListing = ServiceListingItem.create(
      pilotId: pilotId,
      title: title,
      description: description,
      category: category,
      price: price,
      serviceRegion: serviceRegion,
      durationInfo: durationInfo,
      priceInfo: priceInfo,
      imageUrls: imageUrls,
    );

    _mockServiceListings.add(newListing);
    debugPrint('Yeni Hizmet İlanı Eklendi: ${newListing.title} (ID: ${newListing.id})');
    return true; // Başarılı kabul edilir
  }
}