// lib/models/conversation.dart (NİHAİ VE HATA GİDERİCİ)

import '../models/message.dart';
import '../constants/enums.dart';
import 'package:flutter/foundation.dart'; // @immutable için kalsın

@immutable
class Conversation {
  final String id;
  final List<String> participants;
  final List<Message> messages;

  // ⚠️ Mock verilerde güncelleme yapılabilmesi için 'final' kaldırılmalıydı,
  // ancak modelin immutable kalması için 'copyWith' kullanılıyor.
  final DateTime lastUpdate;

  // ✅ KRİTİK ALANLAR: Tüm getter hatalarını çözer.
  final String? listingTitle;
  final String senderId;
  final String listingId;

  const Conversation({
    required this.id,
    required this.participants,
    required this.messages,
    required this.lastUpdate,
    required this.senderId, // Hata: senderId isn't defined
    required this.listingId,
    this.listingTitle, // Hata: listingTitle isn't defined
  });

  // ✅ copyWith Metodu: Hata: The method 'copyWith' isn't defined.
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