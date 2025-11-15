// lib/screens/marketplace_screen.dart

import 'package:flutter/material.dart';
import '../models/listing_item.dart';
import '../constants/enums.dart';
import '../services/seller_service.dart';
import 'product_detail_screen.dart';

// Varsayım: Filtreleme için kullanılacak kategori listesi
const List<Map<String, String>> mockCategories = [
  {'id': 'C1', 'name': 'Drone'},
  {'id': 'C2', 'name': 'Hizmet'},
  {'id': 'C3', 'name': 'Aksesuar'},
];

// 🚀 YENİ MOCK VERİ: Marka ve Model Listeleri
const List<String> mockBrands = ['DJI', 'Autel', 'Yuneec', 'Parrot', 'Diğer'];
const Map<String, List<String>> mockBrandModels = {
  'DJI': ['Mavic 3 Pro', 'Air 3', 'Mini 4 Pro', 'Phantom 4 RTK'],
  'Autel': ['Evo Nano', 'Evo Lite', 'Evo II'],
  'Yuneec': ['Typhoon H Plus'],
  'Parrot': ['Anafi'],
};

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final SellerService _sellerService = SellerService();
  late Future<List<ListingItem>> _listingsFuture;

  // STATE YÖNETİMİ
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchTerm = '';
  ItemCondition? _selectedCondition;
  String? _selectedCategoryId;

  // 💥 YENİ: Marka ve Model Filtre State'leri
  String? _selectedBrand;
  String? _selectedModel;

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchListings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // İLANLARI FİLTRELERLE YENİDEN YÜKLEME METODU
  Future<List<ListingItem>> _fetchListings() {
    // 💥 GÜNCELLENDİ: SellerService'e Marka ve Model Filtreleri eklendi.
    // (SellerService içindeki bu metot imzası da güncellenmelidir!)
    return _sellerService.fetchAllMarketplaceListings(
      searchTerm: _currentSearchTerm,
      conditionFilter: _selectedCondition,
      categoryId: _selectedCategoryId,
      brandFilter: _selectedBrand, // YENİ
      modelFilter: _selectedModel, // YENİ
    );
  }

  // Arama çubuğu değiştiğinde tetiklenir
  void _onSearchChanged() {
    if (_searchController.text != _currentSearchTerm) {
      setState(() {
        _currentSearchTerm = _searchController.text;
        _listingsFuture = _fetchListings(); // Yeni Future'ı ayarla
      });
    }
  }

  // Filtreler değiştiğinde tetiklenir
  void _applyFilters() {
    setState(() {
      _listingsFuture = _fetchListings();
    });
  }

  // ----------------------------------------------------
  // YARDIMCI WIDGET'LAR
  // ----------------------------------------------------

  Widget _buildFilterButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () => _showFilterModal(context),
    );
  }

  void _showFilterModal(BuildContext context) {
    // Geçici olarak, modal açıldığında mevcut filtreleri saklamak için
    // modal scope'unda geçici state'ler tanımlanır.
    String? tempSelectedCategoryId = _selectedCategoryId;
    ItemCondition? tempSelectedCondition = _selectedCondition;
    String? tempSelectedBrand = _selectedBrand; // YENİ
    String? tempSelectedModel = _selectedModel; // YENİ

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            // Markaya göre filtrelenmiş modeller
            final List<String> availableModels = tempSelectedBrand != null
                ? mockBrandModels[tempSelectedBrand] ?? []
                : [];

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtreler', style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),

                  // Kategori Filtresi
                  Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: tempSelectedCategoryId,
                    hint: const Text('Tüm Kategoriler'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Tüm Kategoriler')),
                      ...mockCategories.map((category) => DropdownMenuItem(
                        value: category['id'],
                        child: Text(category['name']!),
                      )),
                    ],
                    onChanged: (newValue) {
                      setModalState(() {
                        tempSelectedCategoryId = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Durum Filtresi
                  Text('Ürün Durumu', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButton<ItemCondition>(
                    isExpanded: true,
                    value: tempSelectedCondition,
                    hint: const Text('Tüm Durumlar'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Tüm Durumlar')),
                      ...ItemCondition.values.map((condition) => DropdownMenuItem(
                        value: condition,
                        child: Text(condition.toString().split('.').last.toUpperCase()),
                      )),
                    ],
                    onChanged: (newValue) {
                      setModalState(() {
                        tempSelectedCondition = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // 💥 YENİ: Marka Filtresi
                  Text('Marka', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: tempSelectedBrand,
                    hint: const Text('Tüm Markalar'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Tüm Markalar')),
                      ...mockBrands.map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      )),
                    ],
                    onChanged: (newValue) {
                      setModalState(() {
                        tempSelectedBrand = newValue;
                        tempSelectedModel = null; // Marka değişince Modeli sıfırla
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 💥 YENİ: Model Filtresi
                  Text('Model', style: Theme.of(context).textTheme.titleMedium),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: tempSelectedModel,
                    hint: Text(tempSelectedBrand == null ? 'Önce Marka Seçin' : 'Tüm Modeller'),
                    // Marka seçilmediyse veya o markaya ait model yoksa pasif
                    items: tempSelectedBrand == null ? [] : [
                      const DropdownMenuItem(value: null, child: Text('Tüm Modeller')),
                      ...availableModels.map((model) => DropdownMenuItem(
                        value: model,
                        child: Text(model),
                      )),
                    ],
                    onChanged: tempSelectedBrand == null ? null : (newValue) {
                      setModalState(() {
                        tempSelectedModel = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 30),
                  const Divider(),

                  // Filtre Uygulama Butonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Modal ve uygulama state'ini temizle
                          setModalState(() {
                            tempSelectedCategoryId = null;
                            tempSelectedCondition = null;
                            tempSelectedBrand = null; // YENİ
                            tempSelectedModel = null;  // YENİ
                          });
                          setState(() {
                            _selectedCategoryId = null;
                            _selectedCondition = null;
                            _selectedBrand = null; // YENİ
                            _selectedModel = null;  // YENİ
                            _listingsFuture = _fetchListings();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Temizle'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Modal state'lerini ana state'e uygula
                          setState(() {
                            _selectedCategoryId = tempSelectedCategoryId;
                            _selectedCondition = tempSelectedCondition;
                            _selectedBrand = tempSelectedBrand; // YENİ
                            _selectedModel = tempSelectedModel;  // YENİ
                          });
                          _applyFilters();
                          Navigator.pop(context); // Modalı kapat
                        },
                        child: const Text('Filtrele'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // İlan Kartı Yapısı (Aynı kaldı)
  Widget _buildListingCard(ListingItem item) {
    String conditionText;
    switch (item.condition) {
      case ItemCondition.newCondition: conditionText = 'Yeni'; break;
      case ItemCondition.usedLikeNew: conditionText = 'Yeni Gibi Kullanılmış'; break;
      case ItemCondition.usedGood: conditionText = 'İyi Durumda'; break;
      case ItemCondition.usedFair: conditionText = 'Orta Durumda'; break;
      case ItemCondition.used: conditionText = 'Kullanılmış'; break;
      case ItemCondition.refurbished: conditionText = 'Yenilenmiş'; break;
      default: conditionText = 'Bilinmiyor';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Image.network(
          item.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
          },
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fiyat: \$${item.price.toStringAsFixed(2)}'),
            Text('Durum: $conditionText'),
          ],
        ),
        trailing: Text('Satıcı: ${item.sellerId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(listing: item),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Başlık hala 'Pazar Yeri' olarak kalmıştır, önceki adımda 'Drone Pazarı' olarak düzeltmiştik.
        // Eğer başlığın "Drone Pazarı" olmasını istiyorsanız, bu satırı güncelleyin.
        title: const Text('Drone Pazarı'),
        actions: [
          _buildFilterButton(context), // Filtre butonu
        ],
        // Arama Çubuğu (Aynı kaldı)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'İlanlarda ara (örn: Drone, Hizmet)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ListingItem>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('İlanlar yüklenemedi: ${snapshot.error}'));
          }
          final filteredListings = snapshot.data ?? [];

          if (filteredListings.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Aradığınız kriterlere uygun ilan bulunamadı.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredListings.length,
            itemBuilder: (context, index) {
              return _buildListingCard(filteredListings[index]);
            },
          );
        },
      ),
    );
  }
}