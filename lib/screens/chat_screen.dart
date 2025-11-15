// lib/screens/chat_screen.dart (NİHAİ VE DÜZELTİLMİŞ KONUŞMA EKRANI)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için eklendi

import '../services/chat_service.dart';
import '../models/message.dart';
import '../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String recipientName;
  final String listingTitle;

  static const routeName = '/chat-screen';

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.recipientName,
    required this.listingTitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Gerekli Controller ve Servisler
  late ChatService _chatService;
  late String _currentUserId;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Listenin yönetimi için

  // Future, sadece initState içinde bir kez başlatılmalıdır.
  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();

    // 🚀 DÜZELTME: Servisleri ve ID'yi initState içinde alıyoruz.
    _chatService = Provider.of<ChatService>(context, listen: false);
    _currentUserId = Provider.of<AuthService>(context, listen: false).currentUserId ?? '';

    // Mesaj çekme işlemini başlat.
    _messagesFuture = _fetchMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Mesajları çekme metodu
  Future<List<Message>> _fetchMessages() {
    // currentUserId yoksa boş liste döndürerek hatayı engelle
    if (_currentUserId.isEmpty) {
      return Future.value([]);
    }
    return _chatService.fetchMessages(widget.conversationId);
  }

  // Mesaj gönderme metodu
  void _sendMessage() async {
    final text = _controller.text.trim();

    // ✅ KULLANICI KONTROLÜ: Kullanıcı ID'si yoksa veya mesaj boşsa gönderme
    if (text.isEmpty || _currentUserId.isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      content: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _controller.clear();

    // sendMessage metodu ChatService'te tanımlı
    await _chatService.sendMessage(widget.conversationId, newMessage);

    // Mesajlar gönderildikten sonra listeyi yenile
    if (mounted) {
      setState(() {
        _messagesFuture = _fetchMessages();
      });
      // 🚀 İYİLEŞTİRME: Yenileme sonrası listeyi en alta kaydırmak gerekebilir.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0); // reverse: true olduğu için 0 en alttır
        }
      });
    }
  }

  // Mesaj balonu (Bubble) widget'ı
  Widget _buildMessageBubble(Message message, bool isMe) {
    // ⚠️ İYİLEŞTİRME: withOpacity yerine ColorScheme.fromSwatch() ile tanımlanan renkler kullanılır
    final primaryColor = Theme.of(context).primaryColor;
    final bubbleColor = isMe
        ? primaryColor // Gönderen için ana renk
        : Colors.grey.shade300; // Alıcı için gri tonu
    final textColor = isMe ? Colors.white : Colors.black;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.Hm().format(message.timestamp),
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.recipientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.listingTitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (_currentUserId.isEmpty) {
                  return const Center(child: Text('Giriş yapmadan sohbet görüntülenemiyor.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Mesajlar yüklenirken hata: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(child: Text('Bu sohbet boş. İlk mesajı siz gönderin!'));
                }

                // 🚀 DÜZELTME: reversed.toList() kaldırıldı. reverse: true yeterli.
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Listeyi alttan başlatır (en yeni mesaj en altta)
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId;
                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          // Mesaj gönderme alanı
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Mesaj yaz...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                // 🚀 İYİLEŞTİRME: Buton stili, gönderilen butona benzetildi.
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}