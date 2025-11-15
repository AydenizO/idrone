// lib/screens/notifications_screen.dart (NİHAİ VE DÜZELTİLMİŞ KOD)

import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_item.dart';
import '../constants/enums.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  late Future<List<NotificationItem>> _notificationsFuture;

  // Gerçek uygulamada bu, AuthService'ten gelmelidir.
  static const String currentUserId = 'user1';

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.fetchNotifications(currentUserId);
  }

  Future<void> _markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    if (mounted) {
      setState(() {
        // Okundu işaretlendikten sonra listeyi yeniden yükle
        _notificationsFuture = _notificationService.fetchNotifications(currentUserId);
      });
    }
  }

  // ⚠️ Önemli: Yeniden Yükleme işlevi (Pull-to-Refresh) eklendi
  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _notificationService.fetchNotifications(currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ DÜZELTME: Geri oku ve başlığı olan AppBar geri getirildi.
      appBar: AppBar(
        title: const Text('Bildirimler'),
        centerTitle: true,
        // Geri butonu otomatik olarak eklenir.
      ),
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('Henüz bir bildiriminiz yok.'));
          }

          // ✅ Yeniden Yükleme (Pull-to-Refresh) mekanizması
          return RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isRead = item.isRead;

                return ListTile(
                  tileColor: isRead ? Colors.white : Colors.blue.withOpacity(0.05),
                  leading: Icon(
                    item.type == NotificationType.chatMessage ? Icons.chat : Icons.update,
                    color: isRead ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
                  ),
                  subtitle: Text(item.body),
                  trailing: isRead ? null : const Icon(Icons.circle, color: Colors.red, size: 10),
                  onTap: () {
                    if (!isRead) {
                      _markAsRead(item.id);
                    }
                    // TODO: Bildirim tipine göre ilgili sayfaya navigasyon ekle (Örn: ChatScreen)
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}