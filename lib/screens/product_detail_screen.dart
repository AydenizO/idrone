// lib/screens/product_detail_screen.dart (SON VE UYUMLU KOD)

import 'package:flutter/material.dart';
// 🎉 KRİTİK EKLENTİ
import '../services/auth_service.dart';
import '../models/listing_item.dart';
import '../constants/enums.dart';
import 'chat_screen.dart'; // Sohbet ekranı için import edildi

class ProductDetailScreen extends StatelessWidget {
  final ListingItem listing;

  // AuthService örneğini başlatıyoruz (Provider kullanmıyorsak)
  final AuthService _authService = AuthService(); // 🎉 AuthService eklendi

  // *******************************************
  // 🎉 DÜZELTME: const anahtar kelimesi kaldırıldı
  // *******************************************
  ProductDetailScreen({super.key, required this.listing});

  String _getConditionText(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.newCondition: return 'Yeni';
      case ItemCondition.usedLikeNew: return 'Yeni Gibi Kullanılmış';
      case ItemCondition.usedGood: return 'İyi Durumda';
      case ItemCondition.usedFair: return 'Orta Durumda';
      case ItemCondition.used: return 'Kullanılmış';
      case ItemCondition.refurbished: return 'Yenilenmiş';
      default: return 'Bilinmiyor';
    }
  }

  // Basit Conversation ID oluşturucu
  String _generateConversationId(String currentUserId, String sellerId) {
    final ids = [currentUserId, sellerId]..sort();
    return 'CONV_${ids.join('_')}';
  }

  @override
  Widget build(BuildContext context) {

    // 🎉 DÜZELTME: AuthService'ten dinamik ID alınır. Eğer null ise 'guest' kullanılır.
    final currentUserId = _authService.currentUserId ?? 'guest_user';
    final conversationId = _generateConversationId(currentUserId, listing.sellerId);

    // Satıcı kendi ilanını görüntülüyorsa, sohbet butonu yerine düzenleme/silme butonu gösterilebilir
    final isOwner = currentUserId == listing.sellerId;

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
                      fontSize: 16,
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
            // 🎉 DÜZELTME: Kendi ilanımızı görüntülüyorsak sohbet butonu gösterilmez
            if (!isOwner)
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
                          recipientName: listing.sellerId,
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

            SizedBox(width: isOwner ? 0 : 10),

            // Satın al butonu veya (eğer sahibi ise) düzenle butonu
            Expanded(
              child: ElevatedButton.icon(
                icon: isOwner ? const Icon(Icons.edit) : const Icon(Icons.shopping_cart),
                label: isOwner ? const Text('İlanı Düzenle') : const Text('Hemen Satın Al'),
                onPressed: () {
                  if (isOwner) {
                    // İlan Düzenleme akışını başlatılacak
                  } else {
                    // Ödeme akışını başlatılacak
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOwner ? Colors.blueGrey : Colors.deepPurple,
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