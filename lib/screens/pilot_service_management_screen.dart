// lib/screens/pilot_service_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../constants/enums.dart';

// ******************************************************
// 1. HİZMET YÖNETİMİ ANA EKRANI (PilotServiceManagementScreen)
// ******************************************************

class PilotServiceManagementScreen extends StatefulWidget {
  static const routeName = '/pilot-service-management';

  final UserProfile currentPilotProfile;

  const PilotServiceManagementScreen({
    super.key,
    required this.currentPilotProfile,
  });

  @override
  State<PilotServiceManagementScreen> createState() => _PilotServiceManagementScreenState();
}

class _PilotServiceManagementScreenState extends State<PilotServiceManagementScreen> {
  late List<ServiceDetail> _services;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _services = List.from(widget.currentPilotProfile.servicesOffered ?? []);
  }

  // --- Metotlar ---

  void _addOrEditService({ServiceDetail? serviceToEdit, int? index}) async {
    // Hizmet Ekle/Düzenle Formunu açar
    final resultService = await showModalBottomSheet<ServiceDetail>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => ServiceDetailForm(
        initialService: serviceToEdit,
      ),
    );

    if (resultService != null) {
      setState(() {
        if (index != null) {
          // Düzenleme
          _services[index] = resultService;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hizmet bilgisi güncellendi.')),
          );
        } else {
          // Ekleme
          _services.add(resultService);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yeni hizmet eklendi.')),
          );
        }
      });
      _saveServices();
    }
  }

  void _deleteService(int index) {
    setState(() {
      _services.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hizmet başarıyla silindi.')),
    );
    _saveServices();
  }

  Future<void> _saveServices() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final profileService = Provider.of<ProfileService>(context, listen: false);

    // YENİ PROFİL NESNESİ OLUŞTURULUR
    final updatedProfile = widget.currentPilotProfile.copyWith(
      servicesOffered: _services,
    );

    final success = await profileService.updateUserProfile(updatedProfile);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (success) {
        // Ana profil ekranını güncelleyen bir mekanizma burada tetiklenmeli
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tüm hizmetleriniz başarıyla güncellendi ve yayınlandı!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata: Hizmetleriniz kaydedilemedi.')),
        );
      }
    }
  }


  // --- Widgetlar ---

  Widget _buildServiceList() {
    if (_services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Henüz eklenmiş bir hizmetiniz bulunmamaktadır. Aşağıdaki butonu kullanarak hizmet kategorilerinizi tanımlayın.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.flight_takeoff, color: Colors.blueAccent),
            title: Text('${service.category} - ${service.device}', style: const TextStyle(fontWeight: FontWeight.bold)),
            // 🚀 DÜZELTME: service.city, birden fazla şehri virgülle ayırarak gösterir.
            subtitle: Text(
              '${service.city} | ${service.priceInfo}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.amber),
                  onPressed: () => _addOrEditService(serviceToEdit: service, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteService(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hizmet Kategorilerini Yönet'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              ),
            ),
        ],
      ),
      body: _buildServiceList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditService(),
        label: const Text('Yeni Hizmet Ekle'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

// ************************************************
// 2. HİZMET EKLEME/DÜZENLEME FORMU (ServiceDetailForm)
// ************************************************

class ServiceDetailForm extends StatefulWidget {
  final ServiceDetail? initialService;

  const ServiceDetailForm({super.key, this.initialService});

  @override
  State<ServiceDetailForm> createState() => _ServiceDetailFormState();
}

class _ServiceDetailFormState extends State<ServiceDetailForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _categoryController;
  late TextEditingController _deviceController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  // 🚀 YENİ: Seçilen şehirleri tutmak için liste
  late List<String> _selectedCities;

  late PriceUnit _selectedPriceUnit;

  // Mock kategoriler ve cihazlar
  final List<String> _mockCategories = ['Hava Video/Fotoğraf', '3D Haritalama', 'Tarım Gözetimi', 'İnşaat İlerleyişi'];
  final List<String> _mockDevices = ['DJI Mavic 3 Pro', 'DJI Phantom 4 RTK', 'Autel Evo II Pro', 'Custom Drone'];
  // 🚀 YENİ: Kullanıcıya sunulacak tüm şehirler
  final List<String> _mockCities = ['İstanbul', 'Ankara', 'İzmir', 'Bursa', 'Antalya', 'Kocaeli', 'Eskişehir', 'Adana', 'Konya'];

  @override
  void initState() {
    super.initState();
    final service = widget.initialService;

    _categoryController = TextEditingController(text: service?.category ?? _mockCategories.first);
    _deviceController = TextEditingController(text: service?.device ?? _mockDevices.first);
    _priceController = TextEditingController(text: service?.price.toString() ?? '0');
    _descriptionController = TextEditingController(text: service?.description ?? '');

    _selectedPriceUnit = service?.priceUnit ?? PriceUnit.perProject;

    // 🚀 YENİ: Şehir controller yerine List<String> kullanılıyor.
    // Eğer düzenleme modundaysa, şehir stringini listeye ayır (varsa)
    if (service != null && service.city.isNotEmpty) {
      _selectedCities = service.city.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } else {
      _selectedCities = [];
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _deviceController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    // _cityController kaldırıldı
    super.dispose();
  }

  // 🚀 YENİ METOT: Çoklu Şehir Seçimi Diyaloğu
  Future<void> _showMultiCitySelectionDialog() async {
    // Geçici olarak, diyalog içinde seçimleri tutacak kopya liste
    List<String> tempSelectedCities = List.from(_selectedCities);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hizmet Verdiğiniz Şehirleri Seçin'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _mockCities.map((city) {
                    return CheckboxListTile(
                      title: Text(city),
                      value: tempSelectedCities.contains(city),
                      onChanged: (bool? isChecked) {
                        setDialogState(() { // Dialog State'ini günceller
                          if (isChecked == true) {
                            tempSelectedCities.add(city);
                          } else {
                            tempSelectedCities.remove(city);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Tamam'),
              // Seçili listeyi geri döndürür
              onPressed: () => Navigator.pop(context, tempSelectedCities),
            ),
          ],
        );
      },
    );

    // Ana Form state'ini günceller
    if (result != null) {
      setState(() {
        _selectedCities = result;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedCities.isEmpty) {
        // Eğer hiçbir şehir seçilmemişse uyarı ver
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen hizmet verdiğiniz en az bir şehir seçin.')),
        );
        return;
      }

      final double price = double.tryParse(_priceController.text) ?? 0.0;

      final newService = ServiceDetail(
        category: _categoryController.text,
        device: _deviceController.text,
        // 🚀 DÜZELTME: Listeyi tek bir stringe birleştiriyoruz
        city: _selectedCities.join(', '),
        price: price,
        priceUnit: _selectedPriceUnit,
        description: _descriptionController.text.trim(),
      );

      // Ana ekrana yeni hizmeti döndür
      Navigator.of(context).pop(newService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Klavye boşluğu
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialService == null ? 'Yeni Hizmet Ekle' : 'Hizmeti Düzenle',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),

              // --- Kategori Seçimi (Aynı Kalır) ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Hizmet Kategorisi'),
                value: _categoryController.text.isEmpty ? _mockCategories.first : _categoryController.text,
                items: _mockCategories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) {
                  if (val != null) _categoryController.text = val;
                },
              ),
              const SizedBox(height: 15),

              // --- Cihaz Seçimi (Aynı Kalır) ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kullanılan Drone Modeli'),
                value: _deviceController.text.isEmpty ? _mockDevices.first : _deviceController.text,
                items: _mockDevices.map((dev) => DropdownMenuItem(value: dev, child: Text(dev))).toList(),
                onChanged: (val) {
                  if (val != null) _deviceController.text = val;
                },
              ),
              const SizedBox(height: 15),

              // --- 🚀 YENİ: ÇOKLU ŞEHİR SEÇİMİ ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: Colors.grey),
                title: const Text('Hizmet Verilen Şehirler'),
                subtitle: Text(
                  _selectedCities.isEmpty
                      ? 'Tıklayarak birden fazla şehir seçin...'
                      : _selectedCities.join(', '),
                  style: TextStyle(
                      color: _selectedCities.isEmpty ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
                onTap: _showMultiCitySelectionDialog,
              ),
              const Divider(height: 1),
              const SizedBox(height: 15),

              // --- Fiyat ve Birim (Aynı Kalır) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Fiyat (TL)',
                        prefixText: '₺ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                          return 'Geçerli bir fiyat girin.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<PriceUnit>(
                      decoration: const InputDecoration(labelText: 'Birim'),
                      value: _selectedPriceUnit,
                      items: PriceUnit.values.map((unit) {
                        String text = unit.name.replaceFirst('per', 'Proj.').replaceAll('hourly', 'Saatlik').replaceAll('Day', 'Günlük');
                        return DropdownMenuItem(value: unit, child: Text(text));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPriceUnit = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // --- Açıklama (Aynı Kalır) ---
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Ek Açıklama (Opsiyonel)',
                  hintText: 'Fiyatlandırma veya cihaz hakkında kısa bir açıklama.',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // --- Kaydet Butonu (Aynı Kalır) ---
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: Text(widget.initialService == null ? 'Hizmeti Ekle' : 'Değişiklikleri Kaydet'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}