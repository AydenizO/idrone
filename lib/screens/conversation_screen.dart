// lib/models/conversation.dart (HATA GİDERİLDİ: listingTitle eklendi)

import '../models/message.dart'; // Message modelini kullanıyorsa bu import gereklidir
import '../constants/enums.dart'; // Gerekliyse kalsın

class Conversation {
  final String id;
  final List<String> participants; // Pilot ve kullanıcının ID'leri
  final List<Message> messages; // Konuşmadaki tüm mesajlar
  final DateTime lastUpdate;

  // ✅ KRİTİK EKLENTİ: ChatListScreen'in ihtiyaç duyduğu alan
  final String? listingTitle; // Nullable olarak tanımlandı (String?)

  // Varsayım: Kimin gönderdiğini bilmek için eklenmeli
  final String senderId;

  // Varsayım: İlan ID'si de bulunabilir
  final String listingId;

  const Conversation({
    required this.id,
    required this.participants,
    required this.messages,
    required this.lastUpdate,
    this.listingTitle, // Artık required değil, nullable olabilir
    required this.senderId,
    required this.listingId,
  });

  // Bu modelin temel özelliklerini korumak için copyWith metodu (opsiyonel ama önerilir)
  Conversation copyWith({
    String? id,
    List<String>? participants,
    List<Message>? messages,
    DateTime? lastUpdate,
    String? listingTitle,
    String? senderId,
    String? listingId,
  }) {
    return Conversation(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      listingTitle: listingTitle ?? this.listingTitle,
      senderId: senderId ?? this.senderId,
      listingId: listingId ?? this.listingId,
    );
  }
}