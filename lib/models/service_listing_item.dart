// lib/models/service_listing_item.dart (YENİ DOSYA)

class ServiceListingItem {
  final String id;
  final String pilotId;
  final String title;
  final String description;
  final String category;
  final double price; // TL
  final String priceInfo; // Örn: "Saatlik", "Proje Bazlı"
  final String serviceRegion;
  final String durationInfo; // Örn: "Minimum 4 saat", "1 gün"
  final DateTime datePosted;
  final List<String> imageUrls;
  final bool isActive;

  const ServiceListingItem({
    required this.id,
    required this.pilotId,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.priceInfo,
    required this.serviceRegion,
    required this.durationInfo,
    required this.datePosted,
    this.imageUrls = const [],
    this.isActive = true,
  });

  // İlan oluştururken kullanılacak basit bir fabrika metodu
  ServiceListingItem.create({
    required this.pilotId,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.serviceRegion,
    required this.durationInfo,
    this.priceInfo = 'Proje Bazlı', // Varsayılan fiyat bilgisi
    this.imageUrls = const [],
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
        datePosted = DateTime.now(),
        isActive = true;
}