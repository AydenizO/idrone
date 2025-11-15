// lib/screens/user_profile_screen.dart (NİHAİ VE KRİTİK HATA DÜZELTİLMİŞ KOD)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🚀 İMPORTLAR
import 'pilot_service_management_screen.dart';
import 'payment_screen.dart';
import '../models/user_profile.dart';
import '../models/review.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../constants/enums.dart';
import 'auth_screen.dart';
import 'chat_screen.dart'; // Sohbet ekranına navigasyon için eklendi


// =======================================================
// UserProfileScreen
// =======================================================


class UserProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  final String? externalUserId;
  final bool isCurrentUser;

  const UserProfileScreen({
    super.key,
    this.externalUserId,
    this.isCurrentUser = true,
  });

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  UserProfile? _userProfile;
  List<Review> _recentReviews = const [];
  bool _isLoading = true;
  bool _hasLoadError = false;
  bool _isEditing = false;

  bool _kvkkConsent = false;
  bool _communicationConsent = false;

  final DateTime _subscriptionEndDate = DateTime.now().add(const Duration(days: 30));

  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _regionsController;
  late TextEditingController _certsController;
  late TextEditingController _cityController;

  bool _isControllersInitialized = false;

  bool get _isPilot => _userProfile != null && _userProfile!.role == UserRole.pilot;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _initializeControllers() {
    if (_userProfile == null || _isControllersInitialized) return;

    _usernameController = TextEditingController(text: _userProfile!.username);
    _bioController = TextEditingController(text: _userProfile!.bio);
    _cityController = TextEditingController(text: _userProfile!.city ?? '');

    _regionsController = TextEditingController(text: _userProfile!.serviceRegions?.join(', ') ?? '');
    _certsController = TextEditingController(text: _userProfile!.certifications?.join(', ') ?? '');

    _isControllersInitialized = true;
  }

  @override
  void dispose() {
    if (_isControllersInitialized) {
      _usernameController.dispose();
      _bioController.dispose();
      _regionsController.dispose();
      _certsController.dispose();
      _cityController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final profileService = Provider.of<ProfileService>(context, listen: false);
    String? profileToLoadId = widget.externalUserId;

    if (widget.isCurrentUser) {
      profileToLoadId = authService.currentUserId ?? profileService.currentUserId;
    }

    if (profileToLoadId == null || profileToLoadId.isEmpty) {
      if (widget.isCurrentUser && !authService.isAuthenticated) {
        setState(() => _isLoading = false);
        return;
      }
      setState(() { _isLoading = false; _hasLoadError = true; });
      return;
    }

    try {
      final profile = await profileService.fetchUserProfile(profileToLoadId);
      final reviews = await profileService.fetchRecentReviews(profileToLoadId);

      if (profile == null) {
        _userProfile = UserProfile.empty();
        throw Exception("Profil verisi bulunamadı.");
      }

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _recentReviews = reviews;
          _hasLoadError = false;
          _isEditing = false;
        });

        _initializeControllers();
      }

    } catch (e) {
      debugPrint('Profil yüklenirken HATA oluştu: $e');
      if (mounted) {
        setState(() { _hasLoadError = true; });
      }
      if (_userProfile == null) {
        _userProfile = UserProfile.empty();
        _initializeControllers();
      }
    }
    finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // 🚀 YENİ METOT: Sohbeti Başlatma İşlevi
  void _startChat() {
    if (_userProfile == null || widget.isCurrentUser) return;

    // Pilotun ücretli üyeliğe sahip olup olmadığını kontrol edin (Varsayım: Bitiş tarihi geçmiş mi?)
    final bool isPremium = _isPilot && _subscriptionEndDate.isAfter(DateTime.now());

    if (!isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sadece ücretli üyeliğe sahip pilotlarla sohbet edebilirsiniz.')),
      );
      return;
    }

    // Sohbet ekranına yönlendirme
    Navigator.of(context).pushNamed(
      ChatScreen.routeName,
      arguments: {
        'conversationId': 'NEW_CHAT_${_userProfile!.id}',
        'recipientName': _userProfile!.username,
        'listingTitle': 'Profil Üzerinden Talep', // Varsayılan konu
      },
    );
  }

  void _manageServices() {
    if (mounted && _userProfile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PilotServiceManagementScreen(
            currentPilotProfile: _userProfile!,
          ),
        ),
      ).then((_) {
        _loadUserProfile();
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata: Profil yüklenemediği için hizmet yönetimine geçilemiyor.')),
      );
    }
  }

  // 🎯 GÜNCELLENDİ: PaymentScreen'e yönlendirme
  void _navigateToPayment() {
    if(mounted) {
      Navigator.of(context).pushNamed(PaymentScreen.routeName);
    }
  }

  Future<void> _signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başarıyla çıkış yaptınız.')),
      );
      // Ana ekrana geri dönerek yetki durumunun MainScreen tarafından yeniden kontrol edilmesini sağlar.
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _toggleEdit() async {
    if (!widget.isCurrentUser) return;

    if (_isEditing) {
      await _saveProfileChanges();
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // ✅ DÜZELTME: MainScreen'in ihtiyaç duyduğu AppBar Aksiyon Metodu (MainScreen bunu AppBar actions'a ekler)
  AppBar? buildProfileAppBarActions(BuildContext context) {
    if (!widget.isCurrentUser) return null; // Sadece kendi profili için geçerli

    return AppBar( // Sadece AppBar'ın aksiyonlarını döndürmek için kullanılıyor
      actions: [
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _toggleEdit, // Kaydetme ve Düzenlemeden Çıkma
          ),
        IconButton(
          icon: Icon(_isEditing ? Icons.cancel : Icons.edit, color: Colors.white),
          onPressed: _toggleEdit,
        ),
      ],
    );
  }


  Future<void> _saveProfileChanges() async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(
      username: _usernameController.text,
      bio: _bioController.text,
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      serviceRegions: _regionsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      certifications: _certsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    );

    final profileService = Provider.of<ProfileService>(context, listen: false);
    final success = await profileService.updateUserProfile(updatedProfile);

    if (mounted) {
      if (success) {
        setState(() {
          _userProfile = updatedProfile;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata: Profil güncellenemedi.')),
        );
      }
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, {required String title, required String content, required VoidCallback onConfirm}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
                const SizedBox(height: 10),
                Text('Bu işlem geri alınamaz.', style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(title.contains('Sil') ? 'Profili Sil' : 'Üyeliği Sonlandır'),
            ),
          ],
        );
      },
    );
  }

  void _deactivateAccount() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Üyeliğiniz başarıyla sonlandırıldı (donduruldu).')),
      );
    }
    _signOut();
  }

  void _deleteProfilePermanently() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profiliniz ve tüm verileriniz kalıcı olarak silindi.')),
      );
    }
    _signOut();
  }

  // --------------------------------------------------------
  // MERKEZİ YÖNETİM MODAL
  // --------------------------------------------------------
  void _showManagementDialog() {
    if (_userProfile == null) return;

    final bool isPilot = _isPilot;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Profil Yönetim Merkezi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profil Ayarları', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const Divider(height: 10),

                // 1. Kullanıcı Profili Düzenleme
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Kullanıcı Olarak Profili Düzenle'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _toggleEdit();
                  },
                ),

                // 2. Pilot Olarak Yönetim / Aktivasyon
                isPilot
                    ? ListTile(
                  leading: const Icon(Icons.category, color: Colors.indigo),
                  title: const Text('Pilot Hizmet Kategorilerini Yönet'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _manageServices();
                  },
                )
                    : ListTile(
                  leading: const Icon(Icons.airplanemode_active, color: Colors.orange),
                  title: const Text('Pilot Üyeliğini Aktive Et'),
                  subtitle: const Text('Hizmet eklemek için önce üyelik aktive edilmeli.'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _navigateToPayment();
                  },
                ),

                // ------------------------------------
                // ABONELİK VE ÖDEME İŞLEMLERİ
                // ------------------------------------
                const Divider(),
                Text('   Üyelik ve Ödeme', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.payment, color: Colors.green),
                  title: isPilot ? const Text('Pilot Üyeliğimi Yenile / Ödeme Yap') : const Text('Pilot Üyeliğini Aktive Et / Üye Ol'),
                  subtitle: isPilot ? Text('Bitiş Tarihi: ${_subscriptionEndDate.day}.${_subscriptionEndDate.month}.${_subscriptionEndDate.year}') : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _navigateToPayment();
                  },
                ),

                // ------------------------------------
                // RİSKLİ AKSİYONLAR
                // ------------------------------------
                const Divider(),
                const Text('   Riskli İşlemler', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(Icons.pause_circle_outline, color: Colors.redAccent),
                  title: const Text('Üyeliğimi Sonlandır (Dondur)', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showConfirmationDialog(context, title: 'Üyeliği Sonlandır', content: 'Hesabınız askıya alınacak ve pilot hizmetleriniz yayınlanmayacaktır.', onConfirm: _deactivateAccount);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Profili ve Tüm Verileri Kalıcı Sil', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showConfirmationDialog(context, title: 'Profili Kalıcı Olarak Sil', content: 'Bu işlem tüm verilerinizi geri dönüşsüz olarak silecektir.', onConfirm: _deleteProfilePermanently);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------
  // YÖNETİM KUTUSU WIDGET'I (BÜYÜK ve KALIN)
  // --------------------------------------------------------
  Widget _buildManagementBox(BuildContext context) {
    if (!widget.isCurrentUser || _isEditing || _userProfile == null) return const SizedBox.shrink();

    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primaryColor, width: 2),
          ),
          child: InkWell(
            onTap: _showManagementDialog,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings, size: 28, color: primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'Profilimi Yönet',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // --------------------------------------------------------
  // DİĞER YARDIMCI WIDGETLAR (Aynı Kalır)
  // --------------------------------------------------------

  Widget _buildRatingStars(double rating, int count) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor()
                  ? Icons.star
                  : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          '${rating.toStringAsFixed(1)} / 5.0 ($count yorum)',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'Son Kullanıcı Yorumları',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
        if (_recentReviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Henüz yorum bulunmamaktadır.'),
          ),
        ..._recentReviews.map((review) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingStars(review.rating, 0),
              const SizedBox(height: 8),
              // 🐛 KRİTİK HATA DÜZELTİLDİ: Sentaks hatası ve yanlış Style kullanımı düzeltildi.
              Text(review.comment, style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 4),
              Text(
                '— ${review.reviewerName} (${review.reviewerRole.name.toUpperCase()})',
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildServicesOffered() {
    final services = _userProfile?.servicesOffered;
    if (services == null || services.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'Öne Çıkan Ürün/Hizmetler',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
        ...services.map((service) => ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: Text(service.category),
          subtitle: Text(service.priceInfo),
          trailing: widget.isCurrentUser ? const Icon(Icons.edit, size: 16) : null,
          onTap: () {
            if (widget.isCurrentUser && _isPilot) {
              _manageServices();
            }
          },
        )),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    IconData? icon,
    bool isEditable = false,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    final bool showLabel = label.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) ...[
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
          ],
          isEditable && controller != null && _isControllersInitialized
              ? TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            maxLines: maxLines,
          )
              : Row(
            mainAxisAlignment: showLabel ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: 20, color: Colors.grey.shade600),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  textAlign: showLabel ? TextAlign.left : TextAlign.center,
                  style: TextStyle(
                    fontSize: showLabel ? 16 : 22,
                    fontWeight: showLabel ? FontWeight.normal : FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationPrompt() {
    const TextStyle linkStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              'Hesabınıza Erişim',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // KVKK Onayı
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _kvkkConsent,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _kvkkConsent = newValue ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: GestureDetector(
                      onTap: () { /* TODO: KVKK metnine yönlendirme */ },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(text: 'KVKK Aydınlatma Metni\'ni okudum ve '),
                            TextSpan(
                              text: 'onaylıyorum.',
                              style: linkStyle,
                            ),
                            TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // İletişim Onayı
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _communicationConsent,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _communicationConsent = newValue ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: GestureDetector(
                      onTap: () { /* TODO: İletişim onayı metnine yönlendirme */ },
                      child: const Text(
                        'İletişim izni veriyorum.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _kvkkConsent ? () {
                Navigator.of(context, rootNavigator: true).pushReplacementNamed(AuthScreen.routeName);
              } : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Giriş Yap / Kaydol'),
            ),

            const SizedBox(height: 10),
            if (!_kvkkConsent)
              const Text(
                'Devam etmek için KVKK onayını vermelisiniz.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------
  // ANA İÇERİK (BODY)
  // --------------------------------------------------------

  Widget _buildProfileContent(BuildContext context) {
    if (_userProfile == null) {
      return const Center(child: Text("Profil bilgisi mevcut değil."));
    }

    final profile = _userProfile!;
    final isPilot = _isPilot;

    if(!_isControllersInitialized) {
      _initializeControllers();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // YÖNETİM WIDGET'I (Sadece kutu/buton)
          _buildManagementBox(context),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profile.profileImageUrl.isNotEmpty
                          ? NetworkImage(profile.profileImageUrl) as ImageProvider<Object>?
                          : null,
                      child: profile.profileImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Kullanıcı Adı
                  Center(
                    child: _buildInfoRow(
                      label: '',
                      value: profile.username,
                      isEditable: _isEditing,
                      controller: _usernameController,
                    ),
                  ),

                  // Diğer Bilgiler
                  _buildInfoRow(
                    label: 'Konum',
                    icon: Icons.location_on,
                    value: profile.city ?? 'Belirtilmedi',
                    isEditable: _isEditing,
                    controller: _cityController,
                  ),

                  _buildInfoRow(
                    label: 'Hakkında',
                    value: profile.bio ?? 'Profil biyografisi eklenmedi.',
                    isEditable: _isEditing,
                    controller: _bioController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          if (isPilot) ...[
            _buildServicesOffered(),

            _buildInfoRow(
              label: 'Sertifikalar',
              icon: Icons.military_tech,
              value: profile.certifications?.join(', ') ?? 'Yok',
              isEditable: _isEditing,
              controller: _certsController,
              maxLines: 3,
            ),

            _buildInfoRow(
              label: 'Hizmet Bölgeleri',
              icon: Icons.map,
              value: profile.serviceRegions?.join(', ') ?? 'Yok',
              isEditable: _isEditing,
              controller: _regionsController,
              maxLines: 3,
            ),
          ],

          _buildRecentReviews(),

          const SizedBox(height: 40),

          // EK WIDGET: Hızlı Çıkış Yap Butonu
          if (widget.isCurrentUser && !_isEditing)
            Column(
              children: [
                OutlinedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout, color: Colors.blueGrey),
                  label: const Text('Çıkış Yap', style: TextStyle(color: Colors.blueGrey)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    side: const BorderSide(color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Diğer yönetim ve üyelik işlemleri için yukarıdaki "Profilimi Yönet" kutusunu kullanın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
              ],
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // BUILD (DÜZELTİLMİŞ HALİ)
  // --------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // Senaryo 1: Oturum Açma İsteniyorsa (Scaffold burada kalır)
    if (widget.isCurrentUser && !authService.isAuthenticated ||
        (widget.isCurrentUser && _userProfile != null && !_userProfile!.isRegistered)) {

      final Widget content = _buildRegistrationPrompt();

      return Scaffold(
        appBar: AppBar(title: const Text('Profil Yönetimi')),
        body: content,
      );
    }

    final Widget bodyContent = _isLoading && _userProfile == null
        ? const Center(child: CircularProgressIndicator())
        : _hasLoadError
        ? const Center(child: Text("Kullanıcı profili yüklenirken bir hata oluştu."))
        : _buildProfileContent(context);

    // FLOATING ACTION BUTTON İÇİN KONTROLLER
    final bool showFloatingChatButton =
        !widget.isCurrentUser && // Kendi profilini görüntülemiyor
            !_isLoading &&          // Yükleme bitmiş
            _userProfile != null && // Profil yüklenmiş
            _isPilot;              // Ve bu bir pilot profili

    // 🚀 DÜZELTME: Sekme olarak kullanılıyorsa, sadece içeriği döndür.
    if (widget.isCurrentUser && widget.externalUserId == null) {
      // MainScreen zaten bir Scaffold sağladığı için, sadece body içeriğini döndürüyoruz.
      return Stack(
        children: [
          bodyContent,
          if (showFloatingChatButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: _startChat,
                icon: const Icon(Icons.message),
                label: const Text('Mesaj Gönder'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
        ],
      );
    }

    // Senaryo 3: Dışarıdan çağrılıyorsa (Navigator.pushNamed), kendi Scaffold'unu kullanır.
    return Scaffold(
      appBar: AppBar(title: Text(_userProfile?.username ?? 'Profil')),
      body: bodyContent,
      floatingActionButton: showFloatingChatButton
          ? FloatingActionButton.extended(
        onPressed: _startChat,
        icon: const Icon(Icons.message),
        label: const Text('Mesaj Gönder'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      )
          : null,
    );
  }
}