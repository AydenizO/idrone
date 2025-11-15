// lib/screens/serving_listing_screen.dart (NİHAİ VE MESAJLAŞMA DÜZELTMELİ KOD)

import 'package:flutter/material.dart';
// Gerekli Model ve Servis importları
import '../models/user_profile.dart';
import '../models/filter_model.dart';
import '../constants/enums.dart';
import '../services/profile_service.dart';
import 'user_profile_screen.dart';


// ************************************************
// 1. ANA LİSTELEME EKRANI (ServingListingScreen)
// ************************************************

class ServingListingScreen extends StatefulWidget {
  final String categoryTitle;

  const ServingListingScreen({super.key, required this.categoryTitle});

  @override
  State<ServingListingScreen> createState() => _ServingListingScreenState();
}

class _ServingListingScreenState extends State<ServingListingScreen> {
  ServiceFilterModel _currentFilters = const ServiceFilterModel(
    serviceRole: null,
    sortBy: SortOption.ratingHighToLow,
  );

  late Future<List<UserProfile>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _currentFilters = _currentFilters.copyWith(selectedCategory: widget.categoryTitle);
    _providersFuture = _fetchProviders();
  }

  // 🚀 DÜZELTİLDİ: Sohbeti Başlatma İşlevi
  void _startChatWithProvider(String userId, String username) {
    // Sohbet ekranına navigasyon yapar. (Varsayım: ChatScreen.routeName = '/chat-screen')
    Navigator.of(context).pushNamed(
      '/chat-screen',
      arguments: {
        // Yeni bir konuşma başlatılacağı için geçici bir ID oluşturulur
        'conversationId': 'NEW_CHAT_${userId}',

        // Alıcının ID'si ve adı
        'recipientId': userId,
        'recipientName': username,

        // Konuşma başlığı olarak kategori başlığı kullanılır
        'listingTitle': widget.categoryTitle,
      },
    );
  }

  // Fiyatı sıralama için normalize eden yardımcı metot
  double _normalizePriceForSorting(UserProfile user) {
    if (user.servicesOffered == null || user.servicesOffered!.isEmpty) {
      return double.maxFinite;
    }
    // Basitlik için sadece ilk hizmet detayına bakılır
    final detail = user.servicesOffered!.first;
    if (detail.priceUnit == PriceUnit.perProject || detail.price == 0.0) {
      return double.maxFinite;
    }
    if (detail.priceUnit == PriceUnit.perDay) {
      return detail.price / 8.0; // Günlük fiyatı yaklaşık saatlik fiyata çevir
    }
    return detail.price;
  }

  // Veriyi çeken ve sıralayan ana metot
  Future<List<UserProfile>> _fetchProviders() async {
    // ProfileService'in burada oluşturulduğu varsayılıyor
    final service = ProfileService();

    List<UserProfile> providers = await service.fetchServiceProviders(
      category: _currentFilters.selectedCategory,
      city: _currentFilters.selectedCity,
      roleFilter: _currentFilters.serviceRole,
    );

    // SIRALAMA MANTIĞI UYGULANIR
    switch (_currentFilters.sortBy) {
      case SortOption.ratingHighToLow:
        providers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceLowToHigh:
        providers.sort((a, b) => _normalizePriceForSorting(a).compareTo(_normalizePriceForSorting(b)));
        break;
      case SortOption.priceHighToLow:
        providers.sort((a, b) => _normalizePriceForSorting(b).compareTo(_normalizePriceForSorting(a)));
        break;
      case null:
        break;
    }
    return providers;
  }

  // Sıralama Seçeneği metnini temizleyen yardımcı metot
  String _getSortText(SortOption option) {
    switch (option) {
      case SortOption.ratingHighToLow:
        return 'Puan (Yüksekten Düşüğe)';
      case SortOption.priceLowToHigh:
        return 'Birim Fiyat (Ucuzdan Pahalıya)';
      case SortOption.priceHighToLow:
        return 'Birim Fiyat (Pahalıdan Ucuza)';
    }
  }

  void _updateFilters(ServiceFilterModel newFilters) {
    setState(() {
      _currentFilters = newFilters;
      _providersFuture = _fetchProviders(); // Filtre değişince veriyi yeniden çek
    });
  }

  void _showFilterAndSortDialog() async {
    final newFilters = await showDialog<ServiceFilterModel>(
      context: context,
      builder: (context) => FilterDialog(initialFilters: _currentFilters),
    );

    if (newFilters != null && newFilters != _currentFilters) {
      _updateFilters(newFilters);
    }
  }

  // Widget: Liste üzerine eklenen filtre çubuğu
  Widget _buildFilterAndSortBar(BuildContext context) {
    String sortText = _getSortText(_currentFilters.sortBy ?? SortOption.ratingHighToLow);
    String cityText = _currentFilters.selectedCity ?? 'Tüm Şehirler';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Şehir: $cityText | Sıralama: $sortText',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.tune, size: 20),
            label: const Text('Filtrele'),
            onPressed: _showFilterAndSortDialog,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} Hizmet Verenler'),
        centerTitle: true,
        actions: const [],
      ),
      body: Column(
        children: [
          _buildFilterAndSortBar(context),

          Expanded(
            child: FutureBuilder<List<UserProfile>>(
              future: _providersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Hata oluştu: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Seçilen kriterlere uygun hizmet veren bulunamadı.',
                          textAlign: TextAlign.center,
                        ),
                      ));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];

                    final firstService = user.servicesOffered?.isNotEmpty == true
                        ? user.servicesOffered!.first
                        : null;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.role.name[0].toUpperCase()),
                      ),
                      title: Text(user.businessName ?? user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold)),

                      subtitle: Text(
                        'Puan: ${user.rating.toStringAsFixed(1)} | ${firstService?.priceInfo ?? 'Fiyat Belirtilmemiş'}',
                      ),
                      // Mesaj ve İleri Ok ikonu için Row
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: () => _startChatWithProvider(user.id, user.username),
                            tooltip: 'Mesaj Gönder',
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                              externalUserId: user.id,
                              isCurrentUser: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// -------------------------------------------------------------
// 2. FİLTRE DİALOGU (FilterDialog) - DEĞİŞİKLİK YOK
// -------------------------------------------------------------

class FilterDialog extends StatefulWidget {
  final ServiceFilterModel initialFilters;

  const FilterDialog({super.key, required this.initialFilters});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? _selectedCity;
  late UserRole? _selectedRole;
  late SortOption _selectedSortOption;

  // Mock şehir listesi
  final List<String> _mockCities = ['Hepsi', 'İstanbul', 'Ankara', 'Kocaeli', 'Eskişehir'];

  @override
  void initState() {
    super.initState();
    // Eğer selectedCity null ise 'Hepsi' olarak başlat
    _selectedCity = widget.initialFilters.selectedCity ?? 'Hepsi';
    _selectedRole = widget.initialFilters.serviceRole;
    _selectedSortOption = widget.initialFilters.sortBy ?? SortOption.ratingHighToLow;
  }

  // Sıralama Seçeneği metnini temizleyen yardımcı metot
  String _getSortText(SortOption option) {
    switch (option) {
      case SortOption.ratingHighToLow:
        return 'Puan (Yüksekten Düşüğe)';
      case SortOption.priceLowToHigh:
        return 'Birim Fiyat (Ucuzdan Pahalıya)';
      case SortOption.priceHighToLow:
        return 'Birim Fiyat (Pahalıdan Ucuza)';
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrele ve Sırala'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ŞEHİR FİLTRESİ ---
            const Text('Şehir:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedCity,
              items: _mockCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                });
              },
            ),
            const SizedBox(height: 15),

            // --- HİZMET SAĞLAYICI ROLÜ ---
            const Text('Hizmet Rolü:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<UserRole?>(
              isExpanded: true,
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: null, child: Text('Tüm Kullanıcılar (Filtresiz)')),
                DropdownMenuItem(value: UserRole.pilot, child: Text('Sadece Pilotlar')),
              ],
              onChanged: (UserRole? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
            ),
            const SizedBox(height: 15),

            // --- SIRALAMA ---
            const Text('Sıralama:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<SortOption>(
              isExpanded: true,
              value: _selectedSortOption,
              items: SortOption.values.map((option) {
                String text = _getSortText(option);
                return DropdownMenuItem(
                  value: option,
                  child: Text(text),
                );
              }).toList(),
              onChanged: (SortOption? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSortOption = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            final newFilters = ServiceFilterModel(
              selectedCategory: widget.initialFilters.selectedCategory,
              // 'Hepsi' ise null gönder, aksi takdirde seçilen şehri
              selectedCity: (_selectedCity == 'Hepsi' ? null : _selectedCity),
              serviceRole: _selectedRole,
              sortBy: _selectedSortOption,
            );
            Navigator.of(context).pop(newFilters);
          },
          child: const Text('Uygula'),
        ),
      ],
    );
  }
}