// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

// Kendi tanımladığımız istisnaları import et
import 'api_exceptions.dart';

// Gerçek bir HTTP kütüphanesi kullanıldığında (örneğin 'package:http/http.dart' as http;)
// Ancak burada sadece simülasyon yapıyoruz.

class ApiService {
  // Uygulamanızın temel API URL'si
  static const String _baseUrl = 'https://idrone-market.com/api/v1/';

  const ApiService();

  // İstisna türüne göre hata fırlatmayı sağlayan yardımcı metot
  dynamic _returnResponse(int statusCode, dynamic responseBody) {
    switch (statusCode) {
      case 200:
      case 201:
      // Başarılı istekler
        return responseBody;
      case 400:
        throw BadRequestException(responseBody['message'], statusCode);
      case 401:
        throw UnauthorisedException(responseBody['message'], statusCode);
      case 403:
        throw ForbiddenException(responseBody['message'] ?? 'Bu işleme yetkiniz yok.', statusCode);
      case 404:
        throw NotFoundException(responseBody['message'] ?? 'Aradığınız sayfa/kaynak bulunamadı.', statusCode);
      case 500:
        throw InternalServerErrorException(responseBody['message'], statusCode);
      default:
        throw UnknownApiException(
          'API isteği başarısız oldu: HTTP $statusCode',
          statusCode,
        );
    }
  }

  // GET isteği simülasyonu
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = '$_baseUrl$endpoint';
    debugPrint('API GET İsteği: $url');

    try {
      await Future.delayed(const Duration(milliseconds: 700)); // Ağ gecikmesi simülasyonu

      // Simülasyon verisi (Gerçek uygulamada http.get() kullanılır)
      int mockStatusCode = 200;
      Map<String, dynamic> mockResponse = {'message': 'Veriler başarıyla çekildi.', 'data': []};

      // Hata Simülasyonu Örneği:
      if (endpoint.contains('error404')) {
        mockStatusCode = 404;
        mockResponse = {'message': 'İstenen kaynak bulunamadı.'};
      }

      // Yanıtı işleme
      return _returnResponse(mockStatusCode, mockResponse);

    } on SocketException {
      // Cihazda internet yoksa fırlatılır
      throw FetchDataException('Sunucuya ulaşılamıyor. Ağ bağlantınızı kontrol edin.');
    } on TimeoutException {
      // İstek çok uzun sürerse
      throw TimeoutException('İstek zaman aşımına uğradı.');
    } catch (e) {
      // Diğer bilinmeyen hatalar
      rethrow;
    }
  }

  // POST isteği simülasyonu
  Future<Map<String, dynamic>> post(String endpoint, {required Map<String, dynamic> body}) async {
    final url = '$_baseUrl$endpoint';
    debugPrint('API POST İsteği: $url, Body: ${jsonEncode(body)}');

    try {
      await Future.delayed(const Duration(milliseconds: 900)); // Ağ gecikmesi simülasyonu

      // Simülasyon verisi (Gerçek uygulamada http.post() kullanılır)
      int mockStatusCode = 201; // Başarılı oluşturma
      Map<String, dynamic> mockResponse = {'message': 'Kayıt başarıyla oluşturuldu.', 'id': 'new_${DateTime.now().millisecond}'};

      // Hata Simülasyonu Örneği:
      if (body.containsKey('fail_auth')) {
        mockStatusCode = 401;
        mockResponse = {'message': 'Giriş bilgileri hatalı.'};
      }

      // Yanıtı işleme
      return _returnResponse(mockStatusCode, mockResponse);

    } on SocketException {
      throw FetchDataException('Sunucuya ulaşılamıyor. Ağ bağlantınızı kontrol edin.');
    } catch (e) {
      rethrow;
    }
  }

// PUT, DELETE vb. metodlar da bu yapıya benzer şekilde eklenebilir.
}