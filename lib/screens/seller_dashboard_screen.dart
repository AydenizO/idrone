// lib/screens/seller_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../models/user_profile.dart'; // UserProfile ve ServiceDetail içerir
import '../services/profile_service.dart';
import '../constants/enums.dart';

class SellerDashboardScreen extends StatefulWidget {
  final String userId;
  final UserProfile? userProfile;

  const SellerDashboardScreen({super.key, required this.userId, this.userProfile});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    if (widget.userProfile != null) {
      _profileFuture = Future.value(widget.userProfile);
    } else {
      _profileFuture = ProfileService().fetchUserProfile(widget.userId);
    }
  }

  // İş Planı kartı için yardımcı metot
  Widget _buildBusinessPlanCard(UserProfile profile) {
    String planName;
    Color planColor;
    // ⚠️ DÜZELTME: Kullanılmayan 'features' değişkeni kaldırıldı.
    // String features;

    switch (profile.plan) {
      case SubscriptionPlan.pro:
        planName = 'PRO Üyelik';
        planColor = Colors.amber.shade700;
        // features = 'Sınırsız İlan, Öne Çıkarma, Özel Destek.'; // Kaldırıldı
        break;
      case SubscriptionPlan.basic:
        planName = 'Temel Üyelik';
        planColor = Colors.lightBlue.shade300;
        // features = '5 İlan Hakkı, Temel Destek.'; // Kaldırıldı
        break;
      case SubscriptionPlan.free:
      default:
        planName = 'Ücretsiz Üyelik';
        planColor = Colors.grey.shade400;
        // features = '1 İlan Hakkı, Standart Destek.'; // Kaldırıldı
        break;
    }

    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.workspace_premium, color: planColor),
        title: Text(planName, style: TextStyle(fontWeight: FontWeight.bold, color: planColor)),
        subtitle: Text('Abonelik Bitişi: ${profile.registrationDate.add(const Duration(days: 365)).toLocal().toString().split(' ')[0]}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Abonelik yönetimi sayfasına git
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abonelik yönetimine yönlendiriliyor...')),
          );
        },
      ),
    );
  }

  // Hizmet listesi kartı
  Widget _buildServicesCard(UserProfile profile) {
    // KRİTİK DÜZELTME: user.sellerProfile yerine doğrudan UserProfile alanları
    final services = profile.servicesOffered ?? [];

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Sunulan Hizmetler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // ℹ️ İyileştirme: Unnecessary use of 'toList' kaldırılabilir, ancak kodun bütünlüğünü koruduk.
          ...services.map((service) => ListTile(
            leading: const Icon(Icons.settings_suggest, color: Colors.teal),
            title: Text('${service.category} - ${service.device}'),
            subtitle: Text(service.priceInfo),
            trailing: const Icon(Icons.edit, size: 18),
            onTap: () {
              // TODO: Hizmet düzenleme sayfasına git
            },
          )).toList(),
          if (services.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text('Henüz eklenmiş hizmetiniz yok.'),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Yeni Hizmet Ekle'),
                onPressed: () {
                  // TODO: Yeni hizmet ekleme sayfasına git
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Dashboard içeriği
  Widget _buildDashboardContent(UserProfile profile) {
    final businessName = profile.businessName;

    if (!profile.isPilot) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Bu sayfa yalnızca pilot (hizmet veren) kullanıcılar içindir.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // İşletme Adı ve Derecelendirme
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName ?? 'İşletme Adı Yok',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade800),
                    Text('${profile.rating.toStringAsFixed(1)} (${profile.totalReviews} yorum)'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),

        // İş Planı
        _buildBusinessPlanCard(profile),
        const SizedBox(height: 15),

        // Hizmetler
        _buildServicesCard(profile),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilot Kontrol Paneli'),
        centerTitle: true,
      ),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Profil yüklenemedi.'));
          }

          final user = snapshot.data!;
          return _buildDashboardContent(user);
        },
      ),
    );
  }
}