// lib/screens/order_detail_screen.dart (SON İYİLEŞTİRİLMİŞ VERSİYON)

import 'package:flutter/material.dart';
import '../models/order.dart'; // Order modeli için gerekli
import '../constants/enums.dart'; // OrderStatus ve UserRole için gerekli

// Varsayım: Bu ekranı çağıranın rolünü belirlemek için basit bir mekanizma
// KRİTİK DÜZELTME: UserRole.seller -> UserRole.pilot
const UserRole _mockCurrentUserRole = UserRole.pilot;

class OrderDetailScreen extends StatefulWidget {
  // Satıcı ve alıcı aynı ekranı kullanacağı için, rolü bilmek önemlidir.
  const OrderDetailScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderStatus _currentStatus;

  // Sipariş durumlarını güncellemek için kullanılabilir.
  final List<OrderStatus> _sellerUpdatableStatuses = const [
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  // Sipariş durumunu güncelleme simülasyonu
  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    setState(() {
      _currentStatus = newStatus;
    });

    // TODO: API'ye durum güncelleme isteği gönderme mantığı buraya eklenecek

    await Future.delayed(const Duration(seconds: 1)); // Mock API gecikmesi

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş durumu: ${newStatus.toString().split('.').last.toUpperCase()} olarak güncellendi.')),
      );
    }
  }

  // ----------------------------------------------------
  // YARDIMCI WIDGET'LAR
  // ----------------------------------------------------

  String _getStatusText(OrderStatus status) {
    switch(status){
      case OrderStatus.pending: return 'Beklemede';
      case OrderStatus.processing: return 'Hazırlanıyor';
      case OrderStatus.shipped: return 'Kargoda';
      case OrderStatus.delivered: return 'Teslim Edildi';
      case OrderStatus.cancelled: return 'İptal Edildi';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.processing: return Colors.blue;
      case OrderStatus.shipped: return Colors.lightBlue;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
    }
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateDropdown() {
    // Yalnızca pilot (eski satıcı) rolünde ise gösterilir
    // KRİTİK DÜZELTME: UserRole.seller -> UserRole.pilot
    if (_mockCurrentUserRole != UserRole.pilot) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sipariş Durumu Güncelleme:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<OrderStatus>(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)
            ),
            value: _currentStatus,
            items: _sellerUpdatableStatuses.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(_getStatusText(status)),
              );
            }).toList(),
            onChanged: (newStatus) {
              if (newStatus != null) {
                _updateOrderStatus(newStatus);
              }
            },
            hint: const Text('Yeni Durum Seçin'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    // Tarih formatı için basitleştirme
    final orderDate = '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}';
    final totalAmount = '\$${order.totalAmount.toStringAsFixed(2)}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Sipariş #${order.id} Detayı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sipariş Başlığı ve Durum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.listingTitle,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(_currentStatus),
                    style: TextStyle(
                      color: _getStatusColor(_currentStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),

            // 1. Temel Sipariş Bilgileri
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Sipariş ID', order.id, icon: Icons.receipt),
                    _buildDetailRow('Tarih', orderDate, icon: Icons.calendar_today),
                    _buildDetailRow('Alıcı', order.buyerName, icon: Icons.person),
                    _buildDetailRow('Satıcı', order.sellerName, icon: Icons.store),
                    _buildDetailRow('Toplam Tutar', totalAmount, icon: Icons.payments),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Teslimat Bilgileri
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teslimat Bilgileri',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Adres',
                      order.shippingAddress,
                      icon: Icons.location_on,
                    ),
                    _buildDetailRow(
                      'Takip No',
                      order.trackingNumber ?? 'Henüz gönderilmedi',
                      icon: Icons.local_shipping,
                    ),
                  ],
                ),
              ),
            ),

            // 3. Satıcı Durum Güncelleme Alanı
            _buildStatusUpdateDropdown(),

            const SizedBox(height: 30),

            // 4. İletişim Butonları
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Alıcı/Satıcı ile sohbet ekranına yönlendirme
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sohbet ekranına gidiliyor: ${order.buyerName}')),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Alıcı ile Konuş'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
                ),
                // KRİTİK DÜZELTME: UserRole.seller -> UserRole.pilot
                if (_mockCurrentUserRole == UserRole.pilot) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Fatura oluşturma/görüntüleme
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fatura oluşturuluyor/görüntüleniyor...')),
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('Fatura'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}