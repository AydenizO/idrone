// lib/models/review.dart

import 'package:flutter/foundation.dart';
import '../constants/enums.dart';

@immutable
class Review {
  final String id;
  final String listingId;
  final DateTime timestamp;

  final String reviewerId;
  final String reviewerName;
  final UserRole reviewerRole;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.listingId,
    required this.timestamp,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerRole,
    required this.rating,
    required this.comment,
    required this.date,
  });
}