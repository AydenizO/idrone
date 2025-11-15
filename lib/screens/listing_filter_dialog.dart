// lib/screens/listing_filter_dialog.dart

import 'package:flutter/material.dart';
// Doğru modelleri ve enumları import edin
import '../models/filter_model.dart';
import '../constants/enums.dart'; // Bu dosya UserRole veya PriceUnit gibi diğer enumları içerebilir

// ************************************************
// LİSTELEME FİLTRE DİALOGU (Marka/Model)
// ************************************************

class ListingFilterDialog extends StatefulWidget {
  final ListingFilterModel initialFilters;

  const ListingFilterDialog({super.key, required this.initialFilters});

  @override
  State<ListingFilterDialog> createState() => _ListingFilterDialogState();
}

class _ListingFilterDialogState extends State<ListingFilterDialog> {
  late String? _selectedBrand;
  late String? _selectedModel;
  // 💥 Düzeltme: Tipi ListingSortOption olarak ayarlandı
  late ListingSortOption _selectedSortOption;

  // Mock marka ve model listeleri
  final List<String> _mockBrands = ['Hepsi', 'DJI', 'Autel', 'Yuneec', 'Parrot'];
  final List<String> _mockModels = ['Hepsi', 'Mavic 3', 'Air 2S', 'Mini 4 Pro', 'EVO Lite'];

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.initialFilters.selectedBrand;
    _selectedModel = widget.initialFilters.selectedModel;
    // 💥 Düzeltme: ListingSortOption enum'u kullanıldı
    _selectedSortOption = widget.initialFilters.sortBy ?? ListingSortOption.dateNewest;
  }

  // Sıralama Seçeneği metnini temizleyen yardımcı metot
  // 💥 Düzeltme: Metot parametresi ListingSortOption olarak ayarlandı
  String _getSortText(ListingSortOption option) {
    switch (option) {
      case ListingSortOption.dateNewest:
        return 'En Yeni İlanlar';
      case ListingSortOption.dateOldest:
        return 'En Eski İlanlar';
      case ListingSortOption.priceLowToHigh:
        return 'Fiyat (Ucuzdan Pahalıya)';
      case ListingSortOption.priceHighToLow:
        return 'Fiyat (Pahalıdan Ucuza)';
      default:
        return option.name;
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ürün Filtrele ve Sırala'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- MARKA FİLTRESİ ---
            const Text('Marka:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedBrand ?? 'Hepsi',
              items: _mockBrands.map((brand) {
                return DropdownMenuItem(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBrand = (newValue == 'Hepsi' ? null : newValue);
                });
              },
            ),
            const SizedBox(height: 15),

            // --- MODEL FİLTRESİ ---
            const Text('Model:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedModel ?? 'Hepsi',
              items: _mockModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = (newValue == 'Hepsi' ? null : newValue);
                });
              },
            ),
            const SizedBox(height: 15),

            // --- SIRALAMA ---
            const Text('Sıralama:', style: TextStyle(fontWeight: FontWeight.bold)),
            // 💥 Düzeltme: Dropdown tipi ListingSortOption olarak ayarlandı
            DropdownButton<ListingSortOption>(
              isExpanded: true,
              value: _selectedSortOption,
              // 💥 Düzeltme: ListingSortOption.values kullanıldı
              items: ListingSortOption.values.map((option) {
                String text = _getSortText(option);
                return DropdownMenuItem(
                  value: option,
                  child: Text(text),
                );
              }).toList(),
              onChanged: (ListingSortOption? newValue) {
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
            // 💥 Düzeltme: ListingFilterModel nesnesi oluşturulurken doğru tipler kullanıldı
            final newFilters = ListingFilterModel(
              selectedBrand: _selectedBrand,
              selectedModel: _selectedModel,
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