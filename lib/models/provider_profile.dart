// lib/models/provider_profile.dart

import 'package:flutter/foundation.dart';

@immutable
class ProviderProfile {
  final String userId;
  final String businessName;
  final String taxId;
  final int totalListings;
  final double averageRating;

  const ProviderProfile({
    required this.userId,
    required this.businessName,
    required this.taxId,
    required this.totalListings,
    required this.averageRating,
  });
}