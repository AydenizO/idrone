// lib/models/message.dart (GÜNCELLENMİŞ)

import 'package:flutter/foundation.dart';

@immutable
class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead; // 🎉 Eklendi

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false, // 🎉 Varsayılan değer eklendi
  });
}