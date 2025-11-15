// lib/services/api_exceptions.dart

// Tüm özel API istisnalarının türediği temel sınıf
abstract class ApiException implements Exception {
  final String message;
  final String? prefix;
  final int? statusCode;

  ApiException(this.message, [this.prefix, this.statusCode]);

  @override
  String toString() {
    return '$prefix$message';
  }
}

// 1. Ağ Bağlantı Hatası (Cihazın interneti yok)
class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message ?? 'İletişim hatası. İnternet bağlantınızı kontrol edin.', 'Network Error: ');
}

// 2. Kötü İstek (400 Bad Request)
class BadRequestException extends ApiException {
  BadRequestException([String? message, int? statusCode])
      : super(message ?? 'Geçersiz istek. Girdiğiniz bilgileri kontrol edin.', 'Bad Request: ', statusCode);
}

// 3. Yetkilendirme Hatası (401 Unauthorized)
class UnauthorisedException extends ApiException {
  UnauthorisedException([String? message, int? statusCode])
      : super(message ?? 'Yetkilendirme başarısız. Lütfen tekrar giriş yapın.', 'Unauthorized: ', statusCode);
}

// 4. Yasaklanmış Erişim Hatası (403 Forbidden - Abonelik Duvarı, İzin Eksikliği)
class ForbiddenException extends ApiException {
  ForbiddenException([String? message, int? statusCode])
      : super(message ?? 'Bu kaynağa erişim izniniz yok (Abonelik gerekebilir).', 'Forbidden: ', statusCode);
}

// 5. Kaynak Bulunamadı Hatası (404 Not Found)
class NotFoundException extends ApiException {
  NotFoundException([String? message, int? statusCode])
      : super(message ?? 'Aradığınız kaynak bulunamadı.', 'Not Found: ', statusCode);
}

// 6. Sunucu Hatası (500 Internal Server Error)
class InternalServerErrorException extends ApiException {
  InternalServerErrorException([String? message, int? statusCode])
      : super(message ?? 'Sunucu tarafında beklenmedik bir hata oluştu.', 'Server Error: ', statusCode);
}

// 7. Zaman Aşımı Hatası
class TimeoutException extends ApiException {
  TimeoutException([String? message])
      : super(message ?? 'API isteği zaman aşımına uğradı. Tekrar deneyin.', 'Timeout: ');
}

// 8. Bilinmeyen veya Haritalanmamış Hata (Farklı bir HTTP kodu döndüğünde)
class UnknownApiException extends ApiException {
  UnknownApiException([String? message, int? statusCode])
      : super(message ?? 'Bilinmeyen bir API hatası oluştu.', 'Unknown API Error: ', statusCode);
}