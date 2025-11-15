// lib/screens/chat_list_screen.dart (SON İYİLEŞTİRİLMİŞ KOD - Null Safety Düzeltildi)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../models/conversation.dart';
import 'chat_screen.dart'; // ChatScreen'e yönlendirme için import edildi

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  static const routeName = '/chat-list';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();
  late Future<List<Conversation>> _conversationsFuture;

  // ⚠️ UYARI GİDERİLDİ: Future artık late ile tanımlanıp init edilmelidir.
  // didChangeDependencies yerine initState içinde başlatılması daha güvenlidir.
  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserId = authService.currentUserId;

    // initState içinde başlatma zorunluluğu için
    if (currentUserId != null) {
      _conversationsFuture = _chatService.fetchConversations(currentUserId);
    } else {
      _conversationsFuture = Future.value([]); // Kullanıcı yoksa boş liste
    }
  }

  // Konuşmadaki karşı katılımcının ID'sini bulur
  String _getParticipantId(Conversation conversation, String currentUserId) {
    return conversation.participants.firstWhere(
          (id) => id != currentUserId,
      orElse: () => 'Sistem',
    );
  }

  // Katılımcı ID'sine göre adını döndürür (Mock)
  String _getParticipantName(String participantId) {
    switch (participantId) {
      case 'seller1':
        return 'Drone Satıcısı A';
      case 'pilotA':
        return 'Pilot Ahmet Bey';
      default:
        return 'Kullanıcı $participantId';
    }
  }

  // Okunmamış mesaj sayısını hesaplar
  int _getUnreadCount(Conversation conversation, String currentUserId) {
    return conversation.messages
        .where((m) => m.senderId != currentUserId && !m.isRead)
        .length;
  }

  // Son güncelleme zamanını formatlar
  String _formatLastUpdate(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return DateFormat.Hm().format(timestamp);
    } else if (diff.inDays == 1) {
      return 'Dün';
    } else if (diff.inDays < 7) {
      return DateFormat.E('tr').format(timestamp);
    } else {
      return DateFormat('dd/MM/yy').format(timestamp);
    }
  }


  @override
  Widget build(BuildContext context) {
    // AuthService'i dinlemek yerine sadece ID'yi alıp kullanıcının durumuna göre davranmalıyız
    final currentUserId = Provider.of<AuthService>(context).currentUserId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlarım'),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: _conversationsFuture,
        builder: (context, snapshot) {
          if (currentUserId.isEmpty) {
            return const Center(child: Text('Konuşmaları görmek için lütfen giriş yapın.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Konuşmalar yüklenemedi: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz aktif bir sohbetiniz yok.'));
          }

          final conversations = snapshot.data!;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final participantId = _getParticipantId(conversation, currentUserId);
              final participantName = _getParticipantName(participantId);
              final unreadCount = _getUnreadCount(conversation, currentUserId);
              final isUnread = unreadCount > 0;
              final lastMessage = conversation.messages.isNotEmpty ? conversation.messages.last : null;

              // ✅ DÜZELTME: conversation.listingTitle artık String? (nullable) kabul edildi.
              final title = conversation.listingTitle ?? 'İlan Başlığı Belirtilmemiş';


              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  participantName,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  // İlan başlığını alana yerleştirmek isterseniz:
                  // '${title}: ${lastMessage?.content ?? 'Yeni sohbet'}',
                  // Veya sadece son mesajı gösterelim:
                  lastMessage?.content ?? 'Yeni sohbet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isUnread ? Colors.black : Colors.grey,
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatLastUpdate(conversation.lastUpdate),
                      style: TextStyle(fontSize: 12, color: isUnread ? Colors.deepPurple : Colors.grey),
                    ),
                    if (isUnread)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // 🚀 NAVİGASYON: ChatScreen'e doğru parametrelerle yönlendiriliyor
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: {
                      'conversationId': conversation.id,
                      'recipientName': participantName,
                      'listingTitle': title,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}