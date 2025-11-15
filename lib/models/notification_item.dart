// lib/models/notification_item.dart (Değişiklik yapılmadı)

import '../constants/enums.dart';

class NotificationItem {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  // NotificationService'deki hatalı 'const' kullanımı bu yapıcı ile çözüldü.
  const NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}