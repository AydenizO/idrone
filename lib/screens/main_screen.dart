// lib/screens/main_screen.dart (NİHAİ VE GÜNCEL KOD)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/enums.dart';
import '../services/auth_service.dart';

// Ekran importları
import 'user_profile_screen.dart';
import 'chat_list_screen.dart';
import 'splash_screen.dart';
import 'new_listing_screen.dart';
import 'listing_list_screen.dart';
import 'serving_listing_screen.dart';
import 'auth_screen.dart';
import 'notifications_screen.dart';


// ************************************************
// 1, 2, 3. KATEGORİ MODELLERİ VE ANASAYFA İÇERİĞİ
// ************************************************

class MainCategory {
  final String title;
  final IconData icon;
  final UserRole destinationRole;

  const MainCategory({required this.title, required this.icon, required this.destinationRole});
}

final List<MainCategory> mockCategories = const [
  MainCategory(title: 'Hava Video ve Fotoğrafçılığı', icon: Icons.videocam, destinationRole: UserRole.pilot),
  MainCategory(title: 'Drone Pazarı', icon: Icons.storefront, destinationRole: UserRole.user),
  MainCategory(title: 'Tarımsal Drone Hizmetleri', icon: Icons.eco, destinationRole: UserRole.pilot),
  MainCategory(title: 'Kargo ve Taşımacılık', icon: Icons.inventory_2, destinationRole: UserRole.pilot),
  MainCategory(title: 'Haritalama ve Modelleme', icon: Icons.map, destinationRole: UserRole.pilot),
  MainCategory(title: 'Reklam Hizmetleri', icon: Icons.campaign, destinationRole: UserRole.pilot),
  MainCategory(title: 'Eğitim ve Lisanslama', icon: Icons.school, destinationRole: UserRole.pilot),
  MainCategory(title: 'Kurumsal Hizmetler', icon: Icons.business_center, destinationRole: UserRole.pilot),
  MainCategory(title: 'Yedek Parça ve Aksesuar', icon: Icons.precision_manufacturing, destinationRole: UserRole.user),
  MainCategory(title: 'Teknik Servis ve Tamir', icon: Icons.build_circle, destinationRole: UserRole.pilot),
];

class GridCategoryItem extends StatelessWidget {
  final MainCategory category;
  final UserRole currentUserRole;
  const GridCategoryItem({super.key, required this.category, required this.currentUserRole});

  @override
  Widget build(BuildContext context) {
    bool isServiceCategory = category.destinationRole == UserRole.pilot;
    bool isMarketplaceCategory = category.destinationRole == UserRole.user;

    void navigateToDestination() {
      if (isServiceCategory) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ServingListingScreen(categoryTitle: category.title),
        ));
      } else if (isMarketplaceCategory) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ListingListScreen(categoryTitle: category.title),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ListingListScreen(categoryTitle: category.title),
        ));
      }
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: navigateToDestination,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: Theme.of(context).primaryColor, size: 40),
              const SizedBox(height: 10),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreenHomeContent extends StatelessWidget {
  const MainScreenHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthService'ten rol bilgisi çekilir
    final currentUserRole = Provider.of<AuthService>(context, listen: false).currentUserRole;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Hizmet veya ürün ara...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onTap: () {
                debugPrint('Arama çubuğu tıklandı.');
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(12.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return GridCategoryItem(
                  category: mockCategories[index],
                  currentUserRole: currentUserRole,
                );
              },
              childCount: mockCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, 50),
            child: Text(
              'Günün İlanları veya Öne Çıkanlar buraya gelecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}


// ************************************************
// 4. MAINSCREEN (Navigasyon ve Rol Kontrolü) - SON HALİ
// ************************************************

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // İndeksler: 0=Anasayfa, 1=Sohbet, 2=Profil
  int _selectedIndex = 0;

  // Profil aksiyonlarını almak için GlobalKey
  final GlobalKey<UserProfileScreenState> _profileScreenKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Liste 3 elemanlıdır: Anasayfa, Sohbet, Profil.
    _screens = <Widget>[
      const MainScreenHomeContent(),              // Index 0
      const ChatListScreen(),                     // Index 1
      UserProfileScreen(key: _profileScreenKey),  // Index 2
    ];
  }

  // ✅ DÜZELTME: Logo, Profil sekmesi dahil her zaman görünür.
  Widget _buildIDroneLogoTitle() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ICON BURADA
        Icon(Icons.satellite_alt, color: Colors.white, size: 28),
        SizedBox(width: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'I', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              // YAZI BURADA
              TextSpan(text: ' DRONE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // Düzeltilmiş Dinamik AppBar
  PreferredSizeWidget _buildDynamicAppBar() {
    final Widget titleWidget = _buildIDroneLogoTitle();
    List<Widget> actions = [];

    // Bildirim Butonu her zaman görünür
    actions.add(
      IconButton(
        icon: const Icon(Icons.notifications_none),
        onPressed: () {
          Navigator.of(context).pushNamed(NotificationsScreen.routeName);
        },
      ),
    );

    // Profil sekmesinde (Index 2) özel aksiyonları (Düzenle/Kaydet) ekle
    if (_selectedIndex == 2) {
      final state = _profileScreenKey.currentState;
      if (state != null) {
        // UserProfileScreen'deki aksiyonları çeker
        final AppBar? profileAppBar = state.buildProfileAppBarActions(context);
        if (profileAppBar != null && profileAppBar.actions != null) {
          actions.addAll(profileAppBar.actions!);
        }
      }
    }

    return AppBar(
      title: titleWidget,
      centerTitle: true,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // İlan Ekleme Mantığı (Şu an kullanılmıyor, ancak mantık korunur)
  void _navigateToAddListing() {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (!authService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlan eklemek için lütfen giriş yapın.')),
      );
    } else if (authService.currentUserRole != UserRole.pilot) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sadece Pilot rolüne sahip kullanıcılar ilan ekleyebilir.')),
      );
      setState(() {
        _selectedIndex = 2; // Profil sayfasına yönlendir
      });
    } else {
      Navigator.of(context).pushNamed(NewListingScreen.routeName);
    }
  }


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return const SplashScreen();
    }

    // BottomNavigationBar 3 öğeli.
    List<BottomNavigationBarItem> navItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Sohbet'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    return Scaffold(
      appBar: _buildDynamicAppBar(),

      // Body içeriği doğru indeksi kullanır.
      body: _screens.elementAt(_selectedIndex),

      // FloatingActionButton kaldırıldı.

      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}