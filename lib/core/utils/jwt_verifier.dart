import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';

/// JWT Verifier for Apple ID tokens
/// This class provides client-side verification of Apple ID tokens without requiring a backend
class JWTVerifier {
  static const String _appleKeysUrl = 'https://appleid.apple.com/auth/keys';
  static const String _appleIssuer = 'https://appleid.apple.com';
  
  // Cache for Apple's public keys
  static Map<String, Map<String, dynamic>>? _cachedKeys;
  static DateTime? _keysCacheTime;
  static const Duration _cacheExpiry = Duration(hours: 1);

  /// Verify an Apple ID token
  /// Returns the decoded payload if verification is successful, null otherwise
  static Future<Map<String, dynamic>?> verifyAppleIdToken(
    String token, {
    required String expectedAudience, // Your app's bundle ID
    bool verifySignature = true,
    bool verifyExpiration = true,
    bool verifyIssuer = true,
  }) async {
    try {
      // Parse the JWT token
      final parts = token.split('.');
      if (parts.length != 3) {
        print('❌ Invalid JWT format');
        return null;
      }

      final header = _decodeBase64Url(parts[0]);
      final payload = _decodeBase64Url(parts[1]);
      final signature = parts[2];

      // Parse header and payload
      final headerMap = json.decode(header) as Map<String, dynamic>;
      final payloadMap = json.decode(payload) as Map<String, dynamic>;

      print('🔍 JWT Header: $headerMap');
      print('🔍 JWT Payload: $payloadMap');

      // Verify issuer
      if (verifyIssuer) {
        final issuer = payloadMap['iss'] as String?;
        if (issuer != _appleIssuer) {
          print('❌ Invalid issuer: $issuer');
          return null;
        }
      }

      // Verify audience
      final audience = payloadMap['aud'] as String?;
      if (audience != expectedAudience) {
        print('❌ Invalid audience: $audience, expected: $expectedAudience');
        return null;
      }

      // Verify expiration
      if (verifyExpiration) {
        final exp = payloadMap['exp'] as int?;
        if (exp == null) {
          print('❌ No expiration time in token');
          return null;
        }
        
        final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expirationTime)) {
          print('❌ Token has expired: $expirationTime');
          return null;
        }
      }

      // Verify signature
      if (verifySignature) {
        final isValid = await _verifySignature(
          parts[0], // header
          parts[1], // payload
          signature,
          headerMap,
        );
        
        if (!isValid) {
          print('❌ Invalid signature');
          return null;
        }
      }

      print('✅ JWT token verification successful');
      return payloadMap;
    } catch (e) {
      print('❌ JWT verification error: $e');
      return null;
    }
  }

  /// Decode base64url encoded string
  static String _decodeBase64Url(String input) {
    // Add padding if needed
    final padded = input + '=' * (4 - input.length % 4);
    final decoded = base64Url.decode(padded);
    return utf8.decode(decoded);
  }

  /// Verify JWT signature using Apple's public keys
  static Future<bool> _verifySignature(
    String header,
    String payload,
    String signature,
    Map<String, dynamic> headerMap,
  ) async {
    try {
      final kid = headerMap['kid'] as String?;
      final alg = headerMap['alg'] as String?;

      if (kid == null || alg == null) {
        print('❌ Missing kid or alg in header');
        return false;
      }

      if (alg != 'RS256') {
        print('❌ Unsupported algorithm: $alg');
        return false;
      }

      // Get Apple's public keys
      final keys = await _getApplePublicKeys();
      if (keys == null) {
        print('❌ Failed to get Apple public keys');
        return false;
      }

      final keyData = keys[kid];
      if (keyData == null) {
        print('❌ Key not found for kid: $kid');
        return false;
      }

      // Verify signature
      final message = '$header.$payload';
      final signatureBytes = base64Url.decode(signature + '=' * (4 - signature.length % 4));
      
      return _verifyRSASignature(
        message,
        signatureBytes,
        keyData['n'] as String,
        keyData['e'] as String,
      );
    } catch (e) {
      print('❌ Signature verification error: $e');
      return false;
    }
  }

  /// Get Apple's public keys with caching
  static Future<Map<String, Map<String, dynamic>>?> _getApplePublicKeys() async {
    try {
      // Check cache first
      if (_cachedKeys != null && 
          _keysCacheTime != null && 
          DateTime.now().difference(_keysCacheTime!) < _cacheExpiry) {
        return _cachedKeys;
      }

      // Fetch keys from Apple
      final response = await http.get(Uri.parse(_appleKeysUrl));
      if (response.statusCode != 200) {
        print('❌ Failed to fetch Apple keys: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final keys = data['keys'] as List<dynamic>;

      // Convert to map with kid as key
      final keysMap = <String, Map<String, dynamic>>{};
      for (final key in keys) {
        final keyMap = key as Map<String, dynamic>;
        final kid = keyMap['kid'] as String;
        keysMap[kid] = keyMap;
      }

      // Cache the keys
      _cachedKeys = keysMap;
      _keysCacheTime = DateTime.now();

      print('✅ Fetched ${keysMap.length} Apple public keys');
      return keysMap;
    } catch (e) {
      print('❌ Error fetching Apple keys: $e');
      return null;
    }
  }

  /// Verify RSA signature
  static bool _verifyRSASignature(
    String message,
    Uint8List signature,
    String modulus,
    String exponent,
  ) {
    try {
      // Decode base64url encoded modulus and exponent
      final n = _base64UrlToBigInt(modulus);
      final e = _base64UrlToBigInt(exponent);

      // Create RSA public key
      final rsaPublicKey = RSAPublicKey(n, e);

      // Create RSA engine
      final rsaEngine = RSAEngine();
      rsaEngine.init(false, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));

      // Hash the message
      final messageBytes = utf8.encode(message);
      final digest = sha256.convert(messageBytes);
      final digestBytes = digest.bytes;

      // Verify signature
      final decrypted = rsaEngine.process(signature);
      
      // Parse PKCS#1 v1.5 padding
      if (decrypted.length < 2 || decrypted[0] != 0x00 || decrypted[1] != 0x01) {
        return false;
      }

      // Find the separator (0x00)
      int separatorIndex = -1;
      for (int i = 2; i < decrypted.length; i++) {
        if (decrypted[i] == 0x00) {
          separatorIndex = i;
          break;
        }
        if (decrypted[i] != 0xFF) {
          return false; // Invalid padding
        }
      }

      if (separatorIndex == -1 || separatorIndex + 1 >= decrypted.length) {
        return false;
      }

      // Extract the hash
      final extractedHash = decrypted.sublist(separatorIndex + 1);
      
      // Compare hashes
      return _constantTimeCompare(digestBytes, extractedHash);
    } catch (e) {
      print('❌ RSA signature verification error: $e');
      return false;
    }
  }

  /// Convert base64url to BigInt
  static BigInt _base64UrlToBigInt(String input) {
    final padded = input + '=' * (4 - input.length % 4);
    final bytes = base64Url.decode(padded);
    return BigInt.parse('0x${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}');
  }

  /// Constant time comparison to prevent timing attacks
  static bool _constantTimeCompare(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Simple JWT payload decoder (without verification)
  /// Use this for debugging or when you trust the token source
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = _decodeBase64Url(parts[1]);
      return json.decode(payload) as Map<String, dynamic>;
    } catch (e) {
      print('❌ JWT decode error: $e');
      return null;
    }
  }

  /// Check if token is expired (without full verification)
  static bool isTokenExpired(String token) {
    try {
      final payload = decodePayload(token);
      if (payload == null) return true;
      
      final exp = payload['exp'] as int?;
      if (exp == null) return true;
      
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationTime);
    } catch (e) {
      return true;
    }
  }
}

