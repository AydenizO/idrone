// lib/models/order.dart

import '../constants/enums.dart'; // OrderStatus için gerekli

class Order {
  final String id;
  final String listingId;
  final String listingTitle;
  final String buyerId;
  final String sellerId;

  // 🎉 EKSİK ALANLAR EKLENDİ (Hataları çözer)
  final String buyerName;
  final String sellerName;
  final String shippingAddress;
  final String? trackingNumber; // Takip numarası opsiyonel olabilir

  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.buyerId,
    required this.sellerId,
    required this.buyerName, // 🎉
    required this.sellerName, // 🎉
    required this.shippingAddress, // 🎉
    this.trackingNumber, // 🎉
    required this.totalAmount,
    required this.orderDate,
    required this.status,
  });

// İhtiyaç duyulursa copyWith metodu buraya eklenebilir.
}

// İhtiyaç olursa OrdersTab/OrderDetailScreen'de mock data kullanmak için:
final List<Order> mockOrders = [
  Order(
    id: 'ORD1001',
    listingId: 'LIST456',
    listingTitle: 'DJI Mavic 3 Pro (İyi Durumda)',
    buyerId: 'user789',
    sellerId: 'seller1',
    buyerName: 'Ayşe Yılmaz',
    sellerName: 'Drone Uzmanı Ltd.',
    shippingAddress: 'İstanbul, Şişli, Büyükdere Cd. No:123',
    trackingNumber: 'TRK998877',
    totalAmount: 1850.00,
    orderDate: DateTime(2025, 11, 5),
    status: OrderStatus.shipped,
  ),
  Order(
    id: 'ORD1002',
    listingId: 'LIST123',
    listingTitle: 'Tarımsal Drone Hizmeti (100 Hektar)',
    buyerId: 'user101',
    sellerId: 'seller1',
    buyerName: 'Ahmet Çelik',
    sellerName: 'Drone Uzmanı Ltd.',
    shippingAddress: 'Ankara, Çankaya, Atatürk Bulvarı No:45',
    trackingNumber: null,
    totalAmount: 500.00,
    orderDate: DateTime(2025, 11, 1),
    status: OrderStatus.processing,
  ),
];