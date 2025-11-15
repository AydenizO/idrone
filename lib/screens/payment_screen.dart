// lib/screens/payment_screen.dart (Pilot Üyeliği Ödeme Simülasyonu)

import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';

  const PaymentScreen({super.key});

  // Basit ödeme simülasyonu
  void _simulatePayment(BuildContext context) {
    // Gerçekte burada bir API çağrısı ve ödeme sağlayıcısı yönlendirmesi olurdu.
    // Simülasyon olduğu için gecikme ekliyoruz.

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Ödeme İşleniyor..."),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2)).then((_) {
      // Yükleniyor dialogunu kapat
      Navigator.of(context).pop();

      // Başarı durumunu göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilot Üyeliği Başarıyla Aktive Edildi!'),
          backgroundColor: Colors.green.shade700,
        ),
      );

      // Ana ekrana geri dön (Pilot Üyeliği etkinleşti, profil yenilenebilir.)
      // Note: Gerçekte bu aşamada ProfileService update edilmeli ve ProfileScreen yenilenmelidir.
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilot Üyeliği Ödeme Sayfası'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bilgi Kutusu
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I DRONE Pilot Üyeliği',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '30 Günlük Sınırsız İlan Yayınlama ve Mesajlaşma Yetkisi',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Toplam Tutar:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('399 TL', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Ödeme Yöntemi Alanı (Simülasyon)
            Text(
              'Ödeme Yöntemi Seçimi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.credit_card, size: 30, color: Colors.green),
                  SizedBox(width: 15),
                  Text('Sanal Kredi Kartı (Simülasyon)'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Ödeme Butonu
            ElevatedButton(
              onPressed: () => _simulatePayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                '399 TL Ödeyerek Üyeliği Aktive Et',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}