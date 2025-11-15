// lib/constants/app_constants.dart (Güncellenmiş Versiyon)

import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'IDrone Market';
  static const Color primaryColor = Color(0xFF007BFF);
  static const Color secondaryColor = Color(0xFF28A745);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const double borderRadius = 10.0;

  // Rotalar
  static const String homeRoute = '/';
  static const String chatRoute = '/chat';
  // Hata Düzeltildi: Eksik rotalar eklendi
  static const String sellerDashboardRoute = '/seller-dashboard';
  static const String chatListRoute = '/chat-list';

  static get userProfileRoute => null;
}