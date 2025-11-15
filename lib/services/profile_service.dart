// lib/services/profile_service.dart (Tüm Hatalar Çözüldü, Uyumlu Mock Veri Kullanıldı)

import 'package:flutter/material.dart';
import '../models/review.dart';
import '../constants/enums.dart';
import '../models/user_profile.dart';


class ProfileService {

  final String currentUserId = 'seller1';

  // MOCK VERİ YAPISI:
  static final Map<String, UserProfile> _mockProfiles = {
    'user1': UserProfile(
      id: 'user1',
      username: 'Test Kullanıcı',
      email: 'user1@example.com',
      role: UserRole.user,
      rating: 4.0,
      totalReviews: 5,
      joinDate: DateTime(2023, 5, 15),
      registrationDate: DateTime(2023, 5, 15),
      plan: SubscriptionPlan.free,
      bio: 'Sadece hizmet arayan, drone meraklısı bir kullanıcı.',
      profileImageUrl: '',
      city: 'Ankara',
      isRegistered: true,
      // isPilot KALDIRILDI
    ),
    'seller1': UserProfile(
      id: 'seller1',
      username: 'Gökkuşağı Drone',
      email: 'seller1@example.com',
      role: UserRole.pilot,
      rating: 4.8,
      totalReviews: 15,
      joinDate: DateTime(2023, 1, 1),
      registrationDate: DateTime(2023, 1, 1),
      plan: SubscriptionPlan.pro,
      bio: 'Profesyonel İHA hizmetleri sunan, SHGM lisanslı kurumsal hesap.',
      profileImageUrl: '',
      city: 'İstanbul',
      isRegistered: true,
      // isPilot KALDIRILDI
      businessName: 'Gökkuşağı Drone Hizmetleri A.Ş.',
      serviceRegions: const ['İstanbul', 'Kocaeli', 'Sakarya'],
      certifications: const ['SHGM İHA-1 Lisansı', '4K Video Sertifikası'],
      servicesOffered: [
        const ServiceDetail(
          category: 'Hava Video ve Fotoğrafçılığı',
          device: 'DJI Mavic 3 Pro',
          // 🚀 MOCK DÜZELTME: Bu alanın virgülle ayrılmış şehirleri tuttuğunu varsayıyoruz
          city: 'İstanbul, Ankara',
          price: 1500.0,
          priceUnit: PriceUnit.hourly,
          description: 'Minimum 2 saat',
        ),
        const ServiceDetail(
          category: 'Haritalama ve Modelleme',
          device: 'DJI Phantom 4 RTK',
          // 🚀 MOCK DÜZELTME: Bu alanın virgülle ayrılmış şehirleri tuttuğunu varsayıyoruz
          city: 'Kocaeli, Bursa',
          price: 0.0,
          priceUnit: PriceUnit.perProject,
          description: 'Fiyat teklifi isteyiniz.',
        ),
      ],
    ),
    'pilot1': UserProfile(
      id: 'pilot1',
      username: 'Pilot Alpha',
      email: 'pilot1@test.com',
      role: UserRole.pilot,
      rating: 4.5,
      totalReviews: 7,
      joinDate: DateTime(2025, 1, 1),
      registrationDate: DateTime(2025, 1, 1),
      plan: SubscriptionPlan.basic,
      bio: 'Test amaçlı eklenen pilot profili.',
      profileImageUrl: '',
      city: 'İzmir',
      isRegistered: true,
      // isPilot KALDIRILDI
    ),
    'pilot2': UserProfile(
      id: 'pilot2',
      username: 'Uçan Göz',
      email: 'pilot2@example.com',
      role: UserRole.pilot,
      rating: 4.2,
      totalReviews: 8,
      joinDate: DateTime(2024, 6, 1),
      registrationDate: DateTime(2024, 6, 1),
      plan: SubscriptionPlan.basic,
      bio: 'Profesyonel film çekimleri için hizmetinizdeyim.',
      profileImageUrl: '',
      city: 'Ankara',
      isRegistered: true,
      // isPilot KALDIRILDI
      businessName: 'Uçan Göz Film Yapım',
      serviceRegions: const ['Ankara', 'Eskişehir'],
      certifications: const ['SHGM İHA-0 Lisansı'],
      servicesOffered: [
        const ServiceDetail(
          category: 'Hava Video ve Fotoğrafçılığı',
          device: 'DJI Air 2S',
          city: 'Ankara',
          price: 3000.0,
          priceUnit: PriceUnit.perDay,
        ),
      ],
    ),
    'seller3_agri': UserProfile(
      id: 'seller3_agri',
      username: 'Tarım Drone Uzmanı',
      email: 'agri@example.com',
      role: UserRole.pilot,
      rating: 5.0,
      totalReviews: 10,
      joinDate: DateTime(2024, 1, 1),
      registrationDate: DateTime(2024, 1, 1),
      plan: SubscriptionPlan.pro,
      bio: 'Bitki sağlığı analizi ve ilaçlama hizmetleri.',
      profileImageUrl: '',
      city: 'Konya',
      isRegistered: true,
      // isPilot KALDIRILDI
      businessName: 'Konya Tarım Droneları',
      serviceRegions: const ['Konya', 'Aksaray', 'Karaman'],
      servicesOffered: [
        const ServiceDetail(
          category: 'Tarımsal Hizmetler (İlaçlama/Analiz)',
          device: 'DJI Agras T30',
          city: 'Konya',
          price: 50.0,
          priceUnit: PriceUnit.perDecare,
          description: 'Min. 50 Dekar',
        ),
      ],
    ),
  };

  // =========================================================
  //               MOCK SERVİS METOTLARI
  // =========================================================

  Future<UserProfile?> fetchUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_mockProfiles.containsKey(userId)) {
      return _mockProfiles[userId];
    }

    if (userId == currentUserId) {
      debugPrint('fetchUserProfile: Varsayılan profil oluşturuluyor: $userId');
      return UserProfile(
        id: userId,
        username: 'Aktif Kullanıcı Profili (Mock)',
        email: 'default_user@idrone.com',
        role: UserRole.user,
        rating: 0.0,
        totalReviews: 0,
        joinDate: DateTime.now(),
        registrationDate: DateTime.now(),
        plan: SubscriptionPlan.free,
        bio: 'Profil henüz düzenlenmedi.',
        profileImageUrl: '',
        city: 'Belirtilmedi',
        isRegistered: false,
      );
    }
    return null;
  }

  // 🚀 DÜZELTME: Kategori ve Çoklu Şehir Filtresi Eklendi
  Future<List<UserProfile>> fetchServiceProviders({
    String? category,
    String? city,
    UserRole? roleFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Yalnızca pilot (hizmet veren) rolleri döndürür
    List<UserProfile> filteredProviders = _mockProfiles.values
        .where((user) => user.role == UserRole.pilot)
        .toList();

    // FİLTRELEME MANTIĞI UYGULANIR
    filteredProviders = filteredProviders.where((user) {
      // 1. KATEGORİ FİLTRESİ
      // Kullanıcının hizmet listesinde, aranan kategoriye uygun en az bir hizmet olmalı.
      bool categoryMatch = user.servicesOffered?.any((s) => s.category == category) ?? false;
      if (!categoryMatch) {
        return false;
      }

      // 2. ŞEHİR FİLTRESİ (ÇOKLU ŞEHİR DESTEĞİ)
      if (city != null && city.isNotEmpty) {
        // Kullanıcının hizmet verdiği şehirleri kontrol et.
        bool cityMatch = user.servicesOffered?.any((service) {
          // Hizmetin 'city' alanındaki virgülle ayrılmış şehirleri listeye çevir.
          final List<String> servingCities = service.city
              .split(',')
              .map((s) => s.trim()) // Fazla boşlukları temizle
              .toList();

          // Aranan şehrin listede tam olarak var mı?
          return servingCities.contains(city);
        }) ?? false;

        if (!cityMatch) {
          return false;
        }
      }

      // 3. ROL FİLTRESİ (Opsiyonel, zaten başta filtrelendi ama koruyabiliriz)
      if (roleFilter != null && user.role != roleFilter) {
        return false;
      }

      return true;
    }).toList();

    return filteredProviders;
  }


  Future<List<Review>> fetchRecentReviews(String profileOwnerId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final now = DateTime.now();

    return [
      Review(
        id: 'rev_1',
        listingId: 'list_101',
        timestamp: now,
        reviewerId: 'user_x',
        reviewerName: 'Ahmet T.',
        reviewerRole: UserRole.user,
        rating: 5.0,
        comment: 'Çok hızlı ve kaliteli bir hizmet aldık.',
        date: now,
      ),
      Review(
        id: 'rev_2',
        listingId: 'list_102',
        timestamp: now.subtract(const Duration(days: 5)),
        reviewerId: 'user_y',
        reviewerName: 'Burcu Y.',
        reviewerRole: UserRole.user,
        rating: 4.5,
        comment: 'Fiyat biraz yüksek olsa da sonuçlar mükemmeldi.',
        date: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<bool> updateUserProfile(UserProfile updatedProfile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_mockProfiles.containsKey(updatedProfile.id)) {
      _mockProfiles[updatedProfile.id] = updatedProfile;
      debugPrint('Mock Profil Güncellendi: ${updatedProfile.username}');
      return true;
    }
    return false;
  }
}