// lib/constants/enums.dart (SADELEŞTİRİLMİŞ VE KESİN)

/// Kullanıcı rollerini tanımlar
// 🎉 SADELEŞTİRME: Sadece user (alıcı) ve pilot (hizmet veren/satıcı) rolleri kaldı.
enum UserRole {
  user,  // Alıcı, Tüketici
  pilot, // Hizmet Veren, Satıcı, Üretici
}

/// Abonelik planlarını tanımlar
enum SubscriptionPlan {
  free,
  basic,
  premium,
  pro,
  enterprise,
}

/// İlan öğelerinin durumunu tanımlar
enum ItemCondition {
  newCondition,
  usedLikeNew,
  usedGood,
  usedFair,
  used,
  refurbished,
}

/// Bildirim türlerini tanımlar
enum NotificationType {
  chatMessage,
  newOrder,
  listingUpdate,
  reviewReceived,
  systemAlert,
  promo,
}

/// Sipariş durumlarını tanımlar
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

// 💥 KRİTİK EKSİK: ServiceDetail'ın ihtiyacı olan PriceUnit tanımı
enum PriceUnit {
  hourly,
  perDay,
  perProject,
  perDecare,
}