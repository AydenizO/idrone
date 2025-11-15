// lib/models/user_profile.dart

import 'package:flutter/foundation.dart';
import '../constants/enums.dart'; // UserRole, SubscriptionPlan, PriceUnit buradan alınır

// ----------------------------------------------------------------------
// SERVICE DETAIL MODELİ
// ----------------------------------------------------------------------
class ServiceDetail {
  final String category; // Hava Video, Haritalama vb.
  final String device;   // DJI Mavic 3, Phantom 4 RTK vb.
  final String city;     // Hizmetin verildiği ana şehir

  final double price;
  final PriceUnit priceUnit; // enums.dart'tan geliyor
  final String description; // Fiyatlandırma detayını tutmak için

  const ServiceDetail({
    required this.category,
    required this.device,
    required this.city,
    required this.price,
    required this.priceUnit,
    this.description = '',
  });

  // Fiyatı okunabilir metin formatında sunar
  String get priceInfo {
    String unitText;
    switch (priceUnit) {
      case PriceUnit.hourly:
        unitText = 'Saat';
        break;
      case PriceUnit.perDecare:
        unitText = 'Dekar';
        break;
      case PriceUnit.perProject:
        unitText = 'Proje Bazlı';
        break;
      case PriceUnit.perDay:
        unitText = 'Günlük';
        break;
    // warning: This default clause is covered by the previous cases. hatasını gidermek için kaldırıldı
    // default:
    //   unitText = 'Birim';
    //   break;
    }

    if (price == 0.0) {
      return 'Fiyat Teklifi İsteyiniz ($unitText)';
    }

    // info: Unnecessary braces in a string interpolation. uyarısı giderildi
    return 'TL ${price.toStringAsFixed(0)} / $unitText${description.isNotEmpty ? " ($description)" : ""}'
        .trim();
  }
}

// ----------------------------------------------------------------------
// USER PROFILE MODELİ
// ----------------------------------------------------------------------
@immutable
class UserProfile {
  // Temel Kullanıcı Alanları
  final String id;
  final String username;
  final String email;
  final UserRole role;

  final double rating;

  // Düzeltildi: reviewCount yerine totalReviews kullanılıyor (Diğer ekranlarla uyum için)
  final int totalReviews;

  final DateTime joinDate;
  final DateTime registrationDate;
  final SubscriptionPlan plan;

  final String? bio;

  // Düzeltildi: imageUrl yerine profileImageUrl kullanılıyor (Diğer ekranlarla uyum için)
  final String profileImageUrl;

  final String? city;

  // Düzeltildi: Zorunlu alan olarak eklendi
  final bool isRegistered;

  // Pilotlar İçin Alanlar
  final String? businessName;
  final List<String>? serviceRegions;
  final List<String>? certifications;
  final List<ServiceDetail>? servicesOffered;


  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.rating,
    required this.totalReviews, // Düzeltildi
    required this.joinDate,
    required this.registrationDate,
    required this.plan,
    this.bio,
    this.profileImageUrl = '', // Düzeltildi ve varsayılan değer atandı
    this.city,
    required this.isRegistered, // Düzeltildi
    this.businessName,
    this.serviceRegions,
    this.certifications,
    this.servicesOffered,
  });

  // Rol kontrolü
  bool get isPilot => role == UserRole.pilot;


  factory UserProfile.empty() {
    return UserProfile(
      id: 'guest_user_0',
      username: 'Misafir',
      email: 'guest@idrone.com',
      role: UserRole.user,
      rating: 0.0,
      totalReviews: 0,
      joinDate: DateTime(2023, 1, 1),
      plan: SubscriptionPlan.free,
      registrationDate: DateTime(2023, 1, 1),
      isRegistered: true,
      bio: 'Profil bilgisi yüklenemedi veya misafir olarak giriş yapıldı.',
      profileImageUrl: '',
    );
  }


  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    UserRole? role,
    double? rating,
    int? totalReviews,
    DateTime? joinDate,
    DateTime? registrationDate,
    SubscriptionPlan? plan,
    String? bio,
    String? profileImageUrl,
    String? city,
    bool? isRegistered,
    String? businessName,
    List<String>? serviceRegions,
    List<String>? certifications,
    List<ServiceDetail>? servicesOffered,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      joinDate: joinDate ?? this.joinDate,
      registrationDate: registrationDate ?? this.registrationDate,
      plan: plan ?? this.plan,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      city: city ?? this.city,
      isRegistered: isRegistered ?? this.isRegistered,

      businessName: businessName ?? this.businessName,
      serviceRegions: serviceRegions ?? this.serviceRegions,
      certifications: certifications ?? this.certifications,
      servicesOffered: servicesOffered ?? this.servicesOffered,
    );
  }
}