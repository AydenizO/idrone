// lib/screens/product_detail_screen.dart (İyileştirilmiş Kod)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🚀 Eklendi: AuthService kullanımı için
import '../models/listing_item.dart';
import '../constants/enums.dart';
// Sohbet ekranı için import edildi
import 'chat_screen.dart';
import '../services/auth_service.dart'; // 🚀 Eklendi: Kullanıcı ID'sini almak için

class ProductDetailScreen extends StatelessWidget {
  final ListingItem listing;

  const ProductDetailScreen({super.key, required this.listing});

  // 🚀 İyileştirme: Unreachable switch default uyarısı giderildi.
  String _getConditionText(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.newCondition: return 'Yeni';
      case ItemCondition.usedLikeNew: return 'Yeni Gibi Kullanılmış';
      case ItemCondition.usedGood: return 'İyi Durumda';
      case ItemCondition.usedFair: return 'Orta Durumda';
      case ItemCondition.used: return 'Kullanılmış';
      case ItemCondition.refurbished: return 'Yenilenmiş';
    // Default kısmı Enum'daki tüm değerler kapsandığı için gereksizdir.
    // Ancak gelecekteki değişikliklere karşı korunmak için 'Bilinmiyor' olarak bırakılabilir.
    // Uyarıyı gidermek için kaldırılabilir. Eğer kaldırırsak, Flutter Dart'ın
    // tüm durumları kontrol ettiğini bilecektir.
    // Eğer enum'a yeni değer eklenmezse ve bu kod böyle kalırsa uyarı gider.
    // case ItemCondition.unknown: return 'Bilinmiyor'; // Örnek: Eğer enum'da bu varsa.
    }
    // Eğer tüm durumları kapsıyorsanız, buraya düşmez.
    // Eğer ItemCondition enum'unda ek değerler varsa, switch'e eklenmelidir.
    // Şimdilik varsayalım ki ItemCondition tüm değerleri kapsamıyor.
    // Eğer ItemCondition tüm değerleri kapsıyorsa ve hâlâ uyarı alıyorsanız, switch'i sadece enum değerleri için tutun.
    // Not: Varsayılan enum kullanımı nedeniyle 'default' kaldırılmıştır.
  }

  // Basit Conversation ID oluşturucu (Mock amaçlı)
  String _generateConversationId(String currentUserId, String sellerId) {
    final ids = [currentUserId, sellerId]..sort();
    return 'CONV_${ids.join('_')}';
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 İyileştirme: Mock ID yerine gerçek kullanıcı ID'si alındı
    final currentUserId = Provider.of<AuthService>(context).currentUserId ?? 'guest_user';
    final conversationId = _generateConversationId(currentUserId, listing.sellerId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                  listing.title,
                  style: const TextStyle(
                      fontSize: 16, // Daha küçük font
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)]
                  )
              ),
              background: Image.network(
                listing.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.white70)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${listing.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 8),
                      Text(listing.description, style: Theme.of(context).textTheme.bodyLarge),
                      const Divider(height: 32),

                      // Detay Kartları
                      ListTile(
                        leading: const Icon(Icons.local_offer, color: Colors.blue),
                        title: const Text('Durum'),
                        subtitle: Text(_getConditionText(listing.condition)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.category, color: Colors.green),
                        title: const Text('Kategori'),
                        subtitle: Text(listing.category),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.orange),
                        title: const Text('Satıcı ID'),
                        subtitle: Text(listing.sellerId),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text('Satıcıyla Konuş'),
                onPressed: () {
                  // SOHBET EKRANINA NAVİGASYON
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        conversationId: conversationId,
                        recipientName: listing.sellerId, // Geçici olarak ID kullanılıyor
                        listingTitle: listing.title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Hemen Satın Al'),
                onPressed: () {
                  // Ödeme akışını başlatılacak
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}