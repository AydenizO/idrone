// lib/screens/subscription_wall_screen.dart

import 'package:flutter/material.dart';

class SubscriptionWallScreen extends StatelessWidget {
  const SubscriptionWallScreen({super.key});
  static const routeName = '/subscription-wall';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erişim Kısıtlaması')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_person,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Kontrol Paneli Erişiminiz Kısıtlanmıştır',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Pazar yerinde ilan yayınlamaya ve hizmet vermeye devam etmek için IDrone Premium üyeliğinizi yenilemeniz gerekmektedir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Abonelik Bilgisi Kutusu
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Column(
                  children: [
                    Text('Mevcut Durum: Abonelik Bitmiş', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 5),
                    Text('Üyeliğinizin bitiş tarihi: XXXXXX', style: TextStyle(fontSize: 14)), // Gerçek veri burada gösterilmeli
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Abonelik Satın Alma Butonu
              ElevatedButton.icon(
                icon: const Icon(Icons.workspace_premium),
                label: const Text('Şimdi Aboneliği Yenile/Satın Al', style: TextStyle(fontSize: 16)),
                onPressed: () => debugPrint('Ödeme sayfasına yönlendir'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => debugPrint('Müşteri Hizmetleri ile iletişime geç'),
                child: const Text('Sorun yaşıyorsanız bize ulaşın'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}