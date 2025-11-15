// lib/models/service_detail.dart

import 'package:flutter/foundation.dart';
import '../constants/enums.dart'; // PriceUnit için gereklidir

@immutable
class ServiceDetail {
  final String category;
  final String device;
  // 🚀 Burası artık virgülle ayrılmış birden fazla şehir tutan string'dir.
  final String city;
  final double price;
  final PriceUnit priceUnit;
  final String description;

  const ServiceDetail({
    required this.category,
    required this.device,
    required this.city,
    required this.price,
    required this.priceUnit,
    this.description = '',
  });

  // Fiyatı metin olarak görüntülemek için yardımcı getter
  String get priceInfo {
    if (priceUnit == PriceUnit.perProject || price == 0.0) {
      return 'Fiyat Teklifi İsteyiniz';
    }

    String unitText = '';
    switch (priceUnit) {
      case PriceUnit.hourly:
        unitText = 'saatlik';
        break;
      case PriceUnit.perDay:
        unitText = 'günlük';
        break;
      case PriceUnit.perDecare:
        unitText = 'dekar başına';
        break;
      case PriceUnit.perProject:
        unitText = '';
        break;
    }

    return '${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)} TL / $unitText';
  }
}