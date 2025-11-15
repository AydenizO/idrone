// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Uygulamanızın logosu buraya gelebilir
            FlutterLogo(size: 80),
            SizedBox(height: 20),
            Text(
              'IDrone Market',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Yükleniyor...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}