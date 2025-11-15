// lib/services/review_service.dart (Varsayımsal ve Hata Giderici Versiyon)

import '../models/review.dart';
import '../constants/enums.dart';

class ReviewService {

  Future<List<Review>> fetchRecentReviews(String profileOwnerId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      Review(
        id: 'rev_1_from_rs',
        listingId: 'list_101',
        timestamp: DateTime(2025, 10, 25, 10),
        reviewerId: 'user_x',
        reviewerName: 'Ahmet T.',
        rating: 5.0,
        comment: 'Ürün hızlı ve tam istediğim gibi geldi.',

        reviewerRole: UserRole.user,
        date: DateTime(2025, 10, 25),
      ),
      Review(
        id: 'rev_2_from_rs',
        listingId: 'list_105',
        timestamp: DateTime(2025, 9, 10, 15),
        reviewerId: 'pilot_y',
        reviewerName: 'Drone Uzmanı',
        rating: 4.0,
        comment: 'Piyasada bulunmayan özel bir bataryayı temin ettim.',

        // 🎉 KRİTİK DÜZELTME: UserRole.seller -> UserRole.pilot
        reviewerRole: UserRole.pilot,
        date: DateTime(2025, 9, 10),
      ),
    ];
  }
}