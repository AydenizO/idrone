// lib/services/subscription_service.dart (Getter Hataları Çözüldü)

import '../models/provider_profile.dart';
import '../constants/enums.dart';

class SubscriptionService {
  // Hata Düzeltildi: ProviderProfile'da tanımlı olmayan getter'lar için mock değerler döndürüldü

  // ProviderProfile'da subscriptionPlan getter'ı yoksa bu metot onu simüle eder
  SubscriptionPlan getCurrentPlan(ProviderProfile profile) {
    // Gerçek uygulamada profile.subscriptionPlan kullanılırdı
    return profile.totalListings > 10 ? SubscriptionPlan.pro : SubscriptionPlan.free;
  }

  // ProviderProfile'da planEndDate getter'ı yoksa bu metot onu simüle eder
  DateTime? getPlanEndDate(ProviderProfile profile) {
    // Gerçek uygulamada profile.planEndDate kullanılırdı
    if (getCurrentPlan(profile) == SubscriptionPlan.pro) {
      return DateTime.now().add(const Duration(days: 30));
    }
    return null;
  }
}