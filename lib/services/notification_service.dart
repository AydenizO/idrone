// lib/services/notification_service.dart (TAM KOD)

import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';
import '../constants/enums.dart';

class NotificationService {
  final List<NotificationItem> _mockNotifications = [
    NotificationItem(
      id: 'n1',
      userId: 'user1',
      type: NotificationType.chatMessage,
      title: 'Yeni Mesaj',
      body: 'Gökkuşağı Drone size cevap yazdı.',
      timestamp: DateTime(2024, 10, 27, 9, 30),
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      userId: 'user1',
      type: NotificationType.listingUpdate,
      title: 'İlanınız Güncellendi',
      body: 'DJI Mavic 3 Pro ilanınızın stok sayısı arttırıldı.',
      timestamp: DateTime(2024, 10, 26, 14, 0),
      isRead: true,
    ),
  ];

  Future<List<NotificationItem>> fetchNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockNotifications.where((n) => n.userId == userId).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_mockNotifications[index].isRead) {
      final updatedItem = NotificationItem(
        id: _mockNotifications[index].id,
        userId: _mockNotifications[index].userId,
        type: _mockNotifications[index].type,
        title: _mockNotifications[index].title,
        body: _mockNotifications[index].body,
        timestamp: _mockNotifications[index].timestamp,
        isRead: true,
      );
      _mockNotifications[index] = updatedItem;
      debugPrint('Bildirim okundu: $notificationId');
    }
  }

  Future<int> getUnreadCount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockNotifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }
}