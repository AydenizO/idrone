// lib/screens/checkout_screen.dart (YENİ DOSYA)

import 'package:flutter/material.dart';
import '../models/listing_item.dart';

class CheckoutScreen extends StatelessWidget {
  final ListingItem listing;

  const CheckoutScreen({super.key, required this.listing});

  // Mock değerler
  final double shippingFee = 10.00;
  final double serviceFee = 5.00;

  @override
  Widget build(BuildContext context) {
    double subtotal = listing.price;
    double total = subtotal + shippingFee + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Onayı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎉 Ürün Özeti
            Text('Satın Alınan Ürün', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.network(
                listing.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(listing.title),
              subtitle: Text('Satıcı: ${listing.sellerId}'),
              trailing: Text(
                '\$${listing.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // 🎉 Özet Hesaplama
            Text('Ödeme Özeti', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            _buildSummaryRow(context, 'Ürün Fiyatı:', listing.price, isTotal: false),
            _buildSummaryRow(context, 'Kargo Ücreti:', shippingFee, isTotal: false),
            _buildSummaryRow(context, 'Hizmet Bedeli:', serviceFee, isTotal: false),

            const Divider(height: 20, thickness: 2),

            // 🎉 Toplam
            _buildSummaryRow(context, 'TOPLAM ÖDENECEK:', total, isTotal: true),

            const SizedBox(height: 30),

            // 🎉 Mock Adres Bilgisi
            Text('Teslimat Adresi', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Mock Kullanıcı Adresi'),
                subtitle: Text('Sokak No: 15, Blok: C, Istanbul / Türkiye'),
                trailing: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            // Gerçek uygulamada ödeme API'si burada çağrılır.
            _showOrderSuccess(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: Text('SATIN ALMAYI TAMAMLA (\$${total.toStringAsFixed(2)})'),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String title, double amount, {required bool isTotal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)
                : null,
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)
                : const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  void _showOrderSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Sipariş Başarılı!'),
          content: const Text('Satın alma işleminiz başarıyla tamamlandı. Detayları siparişlerinizde bulabilirsiniz.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                // Ana sayfaya veya siparişler ekranına git
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}