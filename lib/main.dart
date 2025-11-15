// lib/main.dart (IDrone Market Uygulaması - PaymentScreen EKLENDİ)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Servisler
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/profile_service.dart';

// Ekranlar
import 'screens/main_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/pilot_service_management_screen.dart';
// 🚀 YENİ İMPORT: Ödeme Ekranı Eklendi
import 'screens/payment_screen.dart';

// Main kısmında bazı değişiklikler yapılacak
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => ChatService()),
        Provider(create: (_) => ProfileService()),
      ],
      child: const IDroneMarketApp(),
    ),
  );
}

class IDroneMarketApp extends StatelessWidget {
  const IDroneMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IDrone',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.lightBlue,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
              .copyWith(secondary: Colors.cyan),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey,
          )
      ),

      home: Consumer<AuthService>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const SplashScreen();
          }
          if (auth.isAuthenticated) {
            return const MainScreen();
          }
          return const AuthScreen();
        },
      ),

      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        ChatListScreen.routeName: (context) => const ChatListScreen(),
        NotificationsScreen.routeName: (context) => const NotificationsScreen(),
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),

        // 🚀 YENİ ROTA: Ödeme Ekranı Eklendi
        PaymentScreen.routeName: (context) => const PaymentScreen(),

        PilotServiceManagementScreen.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Map<String, dynamic> && args.containsKey('currentPilotProfile')) {
            return PilotServiceManagementScreen(
              currentPilotProfile: args['currentPilotProfile'],
            );
          }
          throw Exception('PilotServiceManagementScreen rotası için gerekli UserProfile argümanı eksik veya hatalı.');
        },


        ChatScreen.routeName: (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;

          return ChatScreen(
            conversationId: args['conversationId'] as String,
            recipientName: args['recipientName'] as String,
            listingTitle: args['listingTitle'] as String,
          );
        },
      },
    );
  }
}