// lib/models/filter_model.dart (GÜNCEL İÇERİK)

import '../constants/enums.dart';

// Mevcut Servis Sıralama Seçenekleri
enum SortOption {
  ratingHighToLow, // Puana göre çoktan aza
  priceLowToHigh,  // Fiyata göre azdan çoğa (birim fiyat)
  priceHighToLow,  // Fiyata göre çoktan aza
}

// Mevcut Servis Filtre Modeli
class ServiceFilterModel {
  final String? selectedCategory;
  final String? selectedCity;
  final UserRole? serviceRole;
  final SortOption? sortBy;

  const ServiceFilterModel({
    this.selectedCategory,
    this.selectedCity,
    this.serviceRole,
    this.sortBy = SortOption.ratingHighToLow,
  });

  ServiceFilterModel copyWith({
    String? selectedCategory,
    String? selectedCity,
    UserRole? serviceRole,
    SortOption? sortBy,
  }) {
    return ServiceFilterModel(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCity: selectedCity ?? this.selectedCity,
      serviceRole: serviceRole ?? this.serviceRole,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// --------------------------------------------------------------------

// 🚀 YENİ: Pazaryeri İlanları için Sıralama Seçenekleri
enum ListingSortOption {
  dateNewest, // En yeni ilanlar (Varsayılan)
  dateOldest, // En eski ilanlar
  priceLowToHigh, // Fiyata göre azdan çoğa
  priceHighToLow, // Fiyata göre çoktan aza
}

// 🚀 YENİ: Pazaryeri İlanları için Filtre Modeli
class ListingFilterModel {
  final String? selectedCategory; // Drone, Yedek Parça, Aksesuar
  final String? selectedBrand;    // DJI, Autel, vb.
  final String? selectedModel;    // Mavic 3, Air 3, vb.
  final ListingSortOption? sortBy;

  const ListingFilterModel({
    this.selectedCategory,
    this.selectedBrand,
    this.selectedModel,
    this.sortBy = ListingSortOption.dateNewest, // Varsayılan: En Yeni
  });

  ListingFilterModel copyWith({
    String? selectedCategory,
    String? selectedBrand,
    String? selectedModel,
    ListingSortOption? sortBy,
  }) {
    return ListingFilterModel(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}