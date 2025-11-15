// lib/screens/auth_screen.dart (GÜNCELLENMİŞ)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _username = '';

  bool _isLoginMode = true;
  bool _isLoading = false;

  // 🎉 YENİ WIDGET: I DRONE Logo/Başlık (Auth Screen için Mavi Renkli)
  Widget _buildIDroneLogoTitle(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        // İKON
        Icon(
          Icons.satellite_alt, // MainScreen ile aynı ikon
          color: primaryColor,
          size: 60, // Daha büyük
        ),
        const SizedBox(height: 5),
        // BAŞLIK
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'I',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: ' DRONE',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final authService = Provider.of<AuthService>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    bool success = false;
    try {
      if (_isLoginMode) {
        success = await authService.login(_email, _password);
      } else {
        success = await authService.register(_email, _password, _username);
      }

      if (success && mounted) {
        // Başarılı olursa ana sayfaya yönlendir
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else if (!success && mounted) {
        String message = _isLoginMode
            ? 'Giriş Başarısız! E-posta veya şifre hatalı.'
            : 'Kayıt Başarısız! E-posta zaten kullanılıyor veya geçersiz şifre.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Uygulamanın ana rengini (mavi) varsayıyoruz.
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Giriş Yap' : 'Kayıt Ol'),
        // 🎉 DÜZELTME: AppBar rengi maviye ayarlandı
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🎉 EKLENDİ: I DRONE Logosu (Formun üstünde)
                  _buildIDroneLogoTitle(context),

                  // Username Alanı (Sadece Kayıt modunda göster)
                  if (!_isLoginMode)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return 'Kullanıcı adı en az 4 karakter olmalıdır.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),

                  // E-posta Alanı
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-posta Adresi'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Geçerli bir e-posta adresi girin.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),

                  // Şifre Alanı
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Şifre'),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Şifre en az 6 karakter olmalıdır.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),

                  const SizedBox(height: 20),

                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        // 🎉 DÜZELTME: Buton rengi maviye ayarlandı
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: Text(_isLoginMode ? 'Giriş Yap' : 'Kayıt Ol'),
                    ),

                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                      });
                    },
                    // 🎉 DÜZELTME: TextButton rengi maviye ayarlandı
                    child: Text(
                      _isLoginMode
                          ? 'Hesabınız yok mu? Kayıt Olun'
                          : 'Zaten hesabınız var mı? Giriş Yapın',
                      style: TextStyle(color: primaryColor),
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
}