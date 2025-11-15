// lib/services/seller_service.dart (Marka/Model Filtre Desteği Eklendi)

import '../models/listing_item.dart'; // Merkezi model buradan import edildi
import '../models/order.dart'; // Order modeli için gerekli
import '../constants/enums.dart';

class SellerService {

  // ----------------------------------------------------
  // MOCK İLAN VERİSİ (BRAND ve MODEL ALANLARI EKLENMİŞTİR)
  // ----------------------------------------------------
  static final List<ListingItem> _mockMarketplaceListings = [
    ListingItem(
      id: 'L1',
      title: 'DJI Mini 3 Pro Drone Satılık',
      description: 'Çok az kullanıldı, garantisi devam ediyor.',
      price: 950.00,
      sellerId: 'seller1',
      category: 'Drone',
      categoryId: 'C1',
      condition: ItemCondition.usedLikeNew,
      datePosted: DateTime(2025, 11, 1),
      imageUrl: 'https://picsum.photos/id/237/200/300',
      brand: 'DJI', // YENİ
      model: 'Mini 3 Pro', // YENİ
    ),
    ListingItem(
      id: 'L2',
      title: 'Tarımsal İlaçlama Hizmeti (Pilot Desteği)',
      description: 'Bölgenizdeki tarlalar için profesyonel ilaçlama hizmeti.',
      price: 200.00,
      sellerId: 'seller1',
      category: 'Hizmet',
      categoryId: 'C2',
      condition: ItemCondition.newCondition,
      datePosted: DateTime(2025, 10, 20),
      isActive: false,
      imageUrl: 'https://picsum.photos/id/1018/200/300',
    ),
    ListingItem(
      id: 'M1',
      title: 'GoPro Karma Drone (Çok Az Kullanılmış)',
      description: 'Taşınabilir, katlanabilir drone seti.',
      price: 1200.00,
      sellerId: 'SATIC001',
      category: 'Drone',
      categoryId: 'C1',
      condition: ItemCondition.usedGood,
      datePosted: DateTime(2025, 11, 2),
      imageUrl: 'https://picsum.photos/id/1025/200/300',
      brand: 'GoPro', // YENİ
      model: 'Karma', // YENİ
    ),
    ListingItem(
      id: 'M2',
      title: 'İstanbul 8K Çekim Hizmeti',
      description: 'Profesyonel 8K hava çekim hizmeti.',
      price: 500.00,
      sellerId: 'SATIC002',
      category: 'Hizmet',
      categoryId: 'C2',
      condition: ItemCondition.newCondition,
      datePosted: DateTime(2025, 11, 3),
      imageUrl: 'https://picsum.photos/id/1080/200/300',
    ),
    ListingItem(
      id: 'M3',
      title: 'Autel Evo Nano Pervane Seti',
      description: 'Sıfır yedek pervane seti.',
      price: 55.00,
      sellerId: 'SATIC003',
      category: 'Aksesuar',
      categoryId: 'C3',
      condition: ItemCondition.newCondition,
      datePosted: DateTime(2025, 11, 8),
      imageUrl: 'https://picsum.photos/id/23/200/300',
      brand: 'Autel', // YENİ
      model: 'Evo Nano', // YENİ
    ),
  ];

  // ----------------------------------------------------
  // MOCK İSTATİSTİKLER (Aynı kaldı)
  // ----------------------------------------------------
  Future<Map<String, int>> fetchSellerStats(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'totalListings': 15,
      'activeListings': 10,
      'pendingOrders': 3,
      'totalSales': 45,
    };
  }

  // ----------------------------------------------------
  // MOCK İLANLAR (Aynı kaldı, ana mock listesini kullanır)
  // ----------------------------------------------------
  Future<List<ListingItem>> fetchMyListings(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Yalnızca ilgili satıcıya ait olan ilanları döndürür
    return _mockMarketplaceListings.where((item) => item.sellerId == sellerId).toList();
  }

  // ----------------------------------------------------
  // YENİ METOT: Tüm Pazaryeri İlanları (Marka/Model Desteği ile GÜNCELLENDİ)
  // ----------------------------------------------------
  Future<List<ListingItem>> fetchAllMarketplaceListings({
    String? categoryId,
    required String searchTerm,
    ItemCondition? conditionFilter,
    // 💥 YENİ PARAMETRELER EKLENDİ
    String? brandFilter,
    String? modelFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // 1. ADIM: Filtreleme
    List<ListingItem> filteredList = _mockMarketplaceListings.where((item) {

      // Arama Terimi Filtresi
      bool matchesSearchTerm = true;
      if (searchTerm.isNotEmpty) {
        matchesSearchTerm = item.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            item.description.toLowerCase().contains(searchTerm.toLowerCase());
      }

      // Durum Filtresi
      bool matchesCondition = conditionFilter == null || item.condition == conditionFilter;

      // Kategori Filtresi
      bool matchesCategory = categoryId == null || item.categoryId == categoryId;

      // 💥 YENİ: Marka Filtresi
      bool matchesBrand = brandFilter == null ||
          (item.brand != null && item.brand!.toLowerCase() == brandFilter.toLowerCase());

      // 💥 YENİ: Model Filtresi
      bool matchesModel = modelFilter == null ||
          (item.model != null && item.model!.toLowerCase() == modelFilter.toLowerCase());

      return matchesSearchTerm && matchesCondition && matchesCategory && matchesBrand && matchesModel;

    }).toList();

    // 2. ADIM: Sıralama (Varsayılan olarak en yeniler başta olabilir)
    filteredList.sort((a, b) => b.datePosted.compareTo(a.datePosted));

    return filteredList;
  }


  // ----------------------------------------------------
  // MOCK SİPARİŞLER (Aynı kaldı)
  // ----------------------------------------------------
  Future<List<Order>> fetchMyOrders(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Eksik zorunlu alanlar dolduruldu
    return [
      Order(
        id: 'ORD1001',
        listingId: 'L1',
        listingTitle: 'DJI Mini 3 Pro Drone Satılık',
        buyerId: 'U789',
        sellerId: sellerId,
        buyerName: 'Ayşe Yılmaz',
        sellerName: 'Satıcı Adı',
        shippingAddress: 'İstanbul, Şişli, Merkez Mh.',
        totalAmount: 950.00,
        orderDate: DateTime(2025, 11, 5),
        status: OrderStatus.pending,
      ),
      Order(
        id: 'ORD1002',
        listingId: 'L3',
        listingTitle: '4K Video Çekim Hizmeti',
        buyerId: 'U101',
        sellerId: sellerId,
        buyerName: 'Mehmet Kara',
        sellerName: 'Satıcı Adı',
        shippingAddress: 'Ankara, Çankaya, Kızılay Cd.',
        totalAmount: 350.00,
        orderDate: DateTime(2025, 11, 1),
        status: OrderStatus.processing,
      ),
      Order(
        id: 'ORD1003',
        listingId: 'L4',
        listingTitle: 'Drone Yedek Pili',
        buyerId: 'U222',
        sellerId: sellerId,
        buyerName: 'Canan Demir',
        sellerName: 'Satıcı Adı',
        shippingAddress: 'İzmir, Konak, Alsancak Mh.',
        totalAmount: 150.00,
        orderDate: DateTime(2025, 10, 25),
        status: OrderStatus.delivered,
        trackingNumber: 'TKP778899',
      ),
    ];
  }
}