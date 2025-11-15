// lib/services/chat_service.dart (NİHAİ VE BÜTÜNSEL KOD)

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ChatService {

  // Mock Konuşma Verileri Listesi (const kaldırıldı, çünkü DateTime.now() sabit değildir)
  final List<Conversation> _mockConversations = [
    // --- KONUŞMA 1 ---
    Conversation(
      id: 'c1',
      listingId: 'l1',
      listingTitle: 'DJI Mavic Mini Satılık',
      senderId: 'seller1',
      participants: const ['user1', 'seller1'],
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
      messages: [ // const kaldırıldı
        // ✅ DÜZELTME: Null yerine DateTime.now() kullanıldı
        Message(id: 'm1', senderId: 'user1', content: 'Merhaba, dron hala satılık mı?', timestamp: DateTime.now().subtract(const Duration(minutes: 5)), isRead: true),
        Message(id: 'm2', senderId: 'seller1', content: 'Evet, satılık.', timestamp: DateTime.now().subtract(const Duration(minutes: 4)), isRead: false),
      ],
    ),

    // --- KONUŞMA 2 ---
    Conversation(
      id: 'c2',
      listingId: 'l2',
      listingTitle: 'Profesyonel Drone Pilotluk Hizmeti',
      senderId: 'pilotA',
      participants: const ['user1', 'pilotA'],
      lastUpdate: DateTime.now().subtract(const Duration(hours: 1)),
      messages: [ // const kaldırıldı
        // ✅ DÜZELTME: Null yerine DateTime.now() kullanıldı
        Message(id: 'm3', senderId: 'pilotA', content: 'Uçuş hizmetiniz için fiyat ne kadar?', timestamp: DateTime.now().subtract(const Duration(hours: 1)), isRead: true),
      ],
    ),
  ];

  /// Kullanıcı ID'sine göre ilgili konuşmaları çeker.
  Future<List<Conversation>> fetchConversations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockConversations.where((c) => c.participants.contains(userId)).toList();
  }

  /// Belirli bir konuşmaya ait mesajları çeker.
  Future<List<Message>> fetchMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final convo = _mockConversations.firstWhereOrNull((c) => c.id == conversationId);
    return convo?.messages ?? [];
  }

  /// Gerçek zamanlı dinleme için Mock fonksiyonu (Yer tutucu)
  void startListening(String conversationId, Function(Message) onNewMessage) {
    // Gerçek bir uygulamada bu, bir Stream veya WebSocket dinleyicisi olurdu.
  }

  /// Yeni bir mesajı gönderir ve Mock listesini günceller.
  Future<void> sendMessage(String conversationId, Message message) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _mockConversations.indexWhere((c) => c.id == conversationId);

    if (index != -1) {
      final currentConvo = _mockConversations[index];
      // Mesajlar listesi değiştirilebilir olmalı
      final updatedMessages = List<Message>.from(currentConvo.messages)..add(message);

      // Conversation'ı copyWith ile güncel verilerle yeniden oluştur
      final updatedConvo = currentConvo.copyWith(
        messages: updatedMessages,
        lastUpdate: message.timestamp,
        senderId: message.senderId,
      );

      // Mock listeyi güncelle
      _mockConversations[index] = updatedConvo;

      debugPrint('Mesaj gönderildi: ${message.content}');
    } else {
      debugPrint('Hata: Konuşma bulunamadı.');
    }
  }
}