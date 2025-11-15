// lib/services/auth_service.dart (SON VE HATASIZ KOD)

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/user_profile.dart';
import '../constants/enums.dart';

class AuthService extends ChangeNotifier {

  final List<UserProfile> _mockUsers = [
    UserProfile(
      id: 'user1',
      email: 'user@idrone.com',
      username: 'NormalKullanici',
      role: UserRole.user,
      registrationDate: DateTime.now(),
      rating: 4.5,
      // Düzeltme: totalReviews eklendi, reviewCount kaldırıldı
      totalReviews: 50,
      plan: SubscriptionPlan.basic,
      joinDate: DateTime(2023, 1, 1),
      // Düzeltme: Zorunlu alanlar eklendi
      isRegistered: true,
      profileImageUrl: '',
    ),
    UserProfile(
      id: 'pilot1',
      email: 'pilot@idrone.com',
      username: 'IDronePilot',
      role: UserRole.pilot,
      registrationDate: DateTime.now(),
      rating: 4.9,
      // Düzeltme: totalReviews eklendi, reviewCount kaldırıldı
      totalReviews: 120,
      plan: SubscriptionPlan.premium,
      joinDate: DateTime(2022, 10, 15),
      // Düzeltme: Zorunlu alanlar eklendi
      isRegistered: true,
      profileImageUrl: 'https://cdn.example.com/pilot_avatar.jpg',
      // SellerProfile alanları
      businessName: 'Global Drone Hizmetleri',
      serviceRegions: ['İstanbul', 'Ankara'],
      certifications: ['İHA-1', 'RTK/PPK'],
      servicesOffered: const [],
    ),
  ];

  String? _currentUserId;
  bool _isLoading = false;

  // info: Use 'const' with the constructor to improve performance. uyarısı giderildi
  AuthService() {
    _currentUserId = 'pilot1';
  }

  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentUserId != null;

  bool get isAuthenticated => _currentUserId != null;
  bool get isLoading => _isLoading;

  UserRole get currentUserRole {
    if (_currentUserId == null) {
      return UserRole.user;
    }

    final user = _mockUsers.firstWhereOrNull((u) => u.id == _currentUserId);
    return user?.role ?? UserRole.user;
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      final user = _mockUsers.firstWhereOrNull((u) => u.email == email);

      if (user != null) {
        _currentUserId = user.id;
        notifyListeners();
        return true;
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String username) async {
    try {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock kayıt başarılı:
      _currentUserId = 'temp_user_${DateTime.now().microsecondsSinceEpoch}';

      // Gerçek implementasyonda burada UserProfile nesnesi oluşturulup _mockUsers listesine eklenmelidir.
      // ÖRNEK:
      // final newUser = UserProfile(
      //   id: _currentUserId!, email: email, username: username, role: UserRole.user,
      //   rating: 0.0, totalReviews: 0, joinDate: DateTime.now(), registrationDate: DateTime.now(),
      //   plan: SubscriptionPlan.free, isRegistered: true, profileImageUrl: '',
      // );
      // _mockUsers.add(newUser);

      notifyListeners();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserProfile?> getCurrentUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return _mockUsers.firstWhereOrNull((user) => user.id == userId);
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUserId = null;
    notifyListeners();
    debugPrint('Çıkış yapıldı.');
  }
}