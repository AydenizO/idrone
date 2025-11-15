// lib/models/seller_stats.dart

class SellerStats {
  final int totalSales;         // Toplam Satış Adedi (Ürün/Hizmet)
  final double totalRevenue;    // Toplam Gelir
  final int activeListings;     // Aktif İlan Sayısı (Drone/Parça/Hizmet)
  final int pendingOrders;      // Bekleyen Sipariş/Talep Sayısı
  final double ratingAverage;   // Ortalam Puan (Örn: 4.7/5.0)
  final int totalReviews;       // Toplam Yorum Sayısı

  SellerStats({
    required this.totalSales,
    required this.totalRevenue,
    required this.activeListings,
    required this.pendingOrders,
    required this.ratingAverage,
    required this.totalReviews,
  });

  // API'den gelen JSON verisini modele dönüştürmek için fabrika metodu (isteğe bağlı ama önerilir)
  factory SellerStats.fromJson(Map<String, dynamic> json) {
    return SellerStats(
      totalSales: json['totalSales'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      activeListings: json['activeListings'] as int,
      pendingOrders: json['pendingOrders'] as int,
      ratingAverage: (json['ratingAverage'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
    );
  }
}