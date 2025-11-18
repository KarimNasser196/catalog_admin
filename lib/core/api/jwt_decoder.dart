import 'dart:convert';
import 'dart:developer' as developer;

/// ===================== JWT DECODER =====================
/// يفك تشفير JWT Token ويستخرج البيانات منه
class JwtDecoder {
  /// فك تشفير JWT token وإرجاع البيانات
  static Map<String, dynamic>? decode(String token) {
    try {
      final parts = token.split('.');
      
      if (parts.length != 3) {
        developer.log('❌ Invalid JWT format', name: 'JwtDecoder');
        return null;
      }

      // JWT structure: header.payload.signature
      // We need the payload (second part)
      final payload = parts[1];
      
      // Normalize base64 string
      var normalized = base64.normalize(payload);
      
      // Decode from base64
      final resp = utf8.decode(base64.decode(normalized));
      
      // Parse JSON
      final payloadMap = json.decode(resp) as Map<String, dynamic>;
      
      developer.log('✅ JWT decoded successfully', name: 'JwtDecoder');
      developer.log('Payload: $payloadMap', name: 'JwtDecoder');
      
      return payloadMap;
    } catch (e) {
      developer.log('❌ Error decoding JWT: $e', name: 'JwtDecoder');
      return null;
    }
  }

  /// التحقق من صلاحية التوكن (لم ينته بعد)
  static bool isExpired(String token) {
    final decodedToken = decode(token);
    if (decodedToken == null) return true;

    final exp = decodedToken['exp'];
    if (exp == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    return now.isAfter(expiryDate);
  }

  /// الحصول على الوقت المتبقي قبل انتهاء التوكن
  static Duration? getRemainingTime(String token) {
    final decodedToken = decode(token);
    if (decodedToken == null) return null;

    final exp = decodedToken['exp'];
    if (exp == null) return null;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    return expiryDate.difference(now);
  }

  /// استخراج Role من التوكن
  static String? getRole(String token) {
    final decodedToken = decode(token);
    if (decodedToken == null) return null;

    return decodedToken['role'] as String?;
  }

  /// استخراج User ID من التوكن
  static String? getUserId(String token) {
    final decodedToken = decode(token);
    if (decodedToken == null) return null;

    return decodedToken['sub'] as String?;
  }

  /// استخراج Name من التوكن
  static String? getName(String token) {
    final decodedToken = decode(token);
    if (decodedToken == null) return null;

    return decodedToken['name'] as String?;
  }

  /// التحقق من أن User هو Admin
  static bool isAdmin(String token) {
    final role = getRole(token);
    return role?.toLowerCase() == 'admin';
  }
}