// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// main.dart dosyanızı import ettiğinizden emin olun (genellikle projenizin adı kullanılır)
import 'package:idrone/main.dart'; // <--- Buradaki 'untitled' sizin projenizin adıdır.

void main() {
  testWidgets('Uygulamanın ana bileşeni test ediliyor', (
    WidgetTester tester,
  ) async {
    // Hata Düzeltildi: MyApp yerine IDroneMarketApp kullanıldı
    await tester.pumpWidget(const IDroneMarketApp());

    // Uygulamanın birincil widget'ının varlığını kontrol edin (Örneğin, MaterialApp)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
