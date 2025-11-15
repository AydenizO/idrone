// lib/models/listing_item.dart

import 'package:flutter/foundation.dart';
import '../constants/enums.dart'; // ItemCondition buradan geliyor.

@immutable
class ListingItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String category;

  // ItemCondition artık enums.dart'tan geliyor
  final ItemCondition condition;

  final DateTime datePosted;
  final bool isActive;
  final String imageUrl;

  // Filtreleme ve Kategori Listeleme için gerekli alan
  final String categoryId;

  // 🚀 EKLENDİ: Marka ve Model Filtreleme için
  final String? brand;
  final String? model;

  const ListingItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.category,
    required this.condition,
    required this.datePosted,
    this.isActive = true,
    required this.imageUrl,
    required this.categoryId,
    // 🚀 EKLENDİ
    this.brand,
    this.model,
  });
}