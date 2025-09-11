import 'jwt_verifier.dart';

/// Example usage of JWT Verifier with your Apple ID token
class JWTExample {
  /// Test the JWT verifier with your provided token
  static Future<void> testJWTVerification() async {
    // Your provided Apple ID token
    const token = 'eyJraWQiOiJVYUlJRlkyZlc0IiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLm5iZWtkZXYudmVsYSIsImV4cCI6MTc1NzMyMzk3MiwiaWF0IjoxNzU3MjM3NTcyLCJzdWIiOiIwMDEyMTkuYjVhOWIwN2ExYTg2NDRjMmE2MzNjZjhmOGNhNzc3NmIuMDkyNyIsImNfaGFzaCI6Iko5OUxmeFFnUXV0OFYxVXRjRXZ5LVEiLCJlbWFpbCI6Im5iZWtkZXZAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF1dGhfdGltZSI6MTc1NzIzNzU3Miwibm9uY2Vfc3VwcG9ydGVkIjp0cnVlfQ.NZuz55Z1-jdfQcmqzzxyzZ5pSfGuTGFthpuwNjawm8-6rkKkyMsZTyt2AIOuXSl9IJiiXXdgBF71gdA-QyV3j2hHngYL-7vXnwfKNctvWgQ0tB9JJ-FZ4OG8EX8UtMU5rG1eBCAt8lLerHftsrCAjR97Y3b15-rXnvysDrYLhxYo5y6pbrEWdYudM3Hz_mbcxZTB6TdV2rSgrj9mOL4Kb0KJ6PreVuG_YJx_Q3Tk9A79AyeGCPYKJcnL5BFI4gJyx7ZaJw9SGfSLNyU-kef0yWVONEg6RZ9g_BXZ1Ry2xXEP3jutGXnrpjF9M8OtFVmcizWpA25fnBnqeEcdrdB-yQUQ';
    
    print('🔍 Testing JWT verification...');
    
    // First, let's decode the payload without verification to see what's inside
    final payload = JWTVerifier.decodePayload(token);
    if (payload != null) {
      print('📋 JWT Payload (unverified):');
      payload.forEach((key, value) {
        print('  $key: $value');
      });
      
      // Check if token is expired
      final isExpired = JWTVerifier.isTokenExpired(token);
      print('⏰ Token expired: $isExpired');
      
      if (isExpired) {
        print('❌ Token has expired, verification will fail');
        return;
      }
    }
    
    // Now let's verify the token
    print('\n🔐 Verifying JWT token...');
    final verifiedPayload = await JWTVerifier.verifyAppleIdToken(
      token,
      expectedAudience: 'com.nbekdev.vela', // Your app's bundle ID
      verifySignature: true,
      verifyExpiration: true,
      verifyIssuer: true,
    );
    
    if (verifiedPayload != null) {
      print('✅ JWT Token verification successful!');
      print('📋 Verified Payload:');
      verifiedPayload.forEach((key, value) {
        print('  $key: $value');
      });
      
      // Extract useful information
      final email = verifiedPayload['email'] as String?;
      final emailVerified = verifiedPayload['email_verified'] as bool?;
      final sub = verifiedPayload['sub'] as String?;
      final authTime = verifiedPayload['auth_time'] as int?;
      final exp = verifiedPayload['exp'] as int?;
      final iat = verifiedPayload['iat'] as int?;
      
      print('\n📊 Extracted Information:');
      print('  Email: $email');
      print('  Email Verified: $emailVerified');
      print('  Subject (User ID): $sub');
      print('  Auth Time: ${authTime != null ? DateTime.fromMillisecondsSinceEpoch(authTime * 1000) : 'N/A'}');
      print('  Issued At: ${iat != null ? DateTime.fromMillisecondsSinceEpoch(iat * 1000) : 'N/A'}');
      print('  Expires At: ${exp != null ? DateTime.fromMillisecondsSinceEpoch(exp * 1000) : 'N/A'}');
      
    } else {
      print('❌ JWT Token verification failed');
    }
  }
  
  /// Test with different verification options
  static Future<void> testWithDifferentOptions() async {
    const token = 'eyJraWQiOiJVYUlJRlkyZlc0IiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLm5iZWtkZXYudmVsYSIsImV4cCI6MTc1NzMyMzk3MiwiaWF0IjoxNzU3MjM3NTcyLCJzdWIiOiIwMDEyMTkuYjVhOWIwN2ExYTg2NDRjMmE2MzNjZjhmOGNhNzc3NmIuMDkyNyIsImNfaGFzaCI6Iko5OUxmeFFnUXV0OFYxVXRjRXZ5LVEiLCJlbWFpbCI6Im5iZWtkZXZAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF1dGhfdGltZSI6MTc1NzIzNzU3Miwibm9uY2Vfc3VwcG9ydGVkIjp0cnVlfQ.NZuz55Z1-jdfQcmqzzxyzZ5pSfGuTGFthpuwNjawm8-6rkKkyMsZTyt2AIOuXSl9IJiiXXdgBF71gdA-QyV3j2hHngYL-7vXnwfKNctvWgQ0tB9JJ-FZ4OG8EX8UtMU5rG1eBCAt8lLerHftsrCAjR97Y3b15-rXnvysDrYLhxYo5y6pbrEWdYudM3Hz_mbcxZTB6TdV2rSgrj9mOL4Kb0KJ6PreVuG_YJx_Q3Tk9A79AyeGCPYKJcnL5BFI4gJyx7ZaJw9SGfSLNyU-kef0yWVONEg6RZ9g_BXZ1Ry2xXEP3jutGXnrpjF9M8OtFVmcizWpA25fnBnqeEcdrdB-yQUQ';
    
    print('\n🔍 Testing with different verification options...');
    
    // Test 1: Only decode payload (no verification)
    print('\n1️⃣ Decode only (no verification):');
    final payload = JWTVerifier.decodePayload(token);
    if (payload != null) {
      print('✅ Payload decoded successfully');
      print('  Email: ${payload['email']}');
      print('  Subject: ${payload['sub']}');
    }
    
    // Test 2: Verify without signature (for expired tokens)
    print('\n2️⃣ Verify without signature (for expired tokens):');
    final verifiedWithoutSig = await JWTVerifier.verifyAppleIdToken(
      token,
      expectedAudience: 'com.nbekdev.vela',
      verifySignature: false, // Skip signature verification
      verifyExpiration: false, // Skip expiration check
      verifyIssuer: true,
    );
    if (verifiedWithoutSig != null) {
      print('✅ Token verified without signature');
    } else {
      print('❌ Token verification failed even without signature');
    }
    
    // Test 3: Verify with signature but without expiration
    print('\n3️⃣ Verify with signature but without expiration:');
    final verifiedWithoutExp = await JWTVerifier.verifyAppleIdToken(
      token,
      expectedAudience: 'com.nbekdev.vela',
      verifySignature: true,
      verifyExpiration: false, // Skip expiration check
      verifyIssuer: true,
    );
    if (verifiedWithoutExp != null) {
      print('✅ Token verified with signature but without expiration check');
    } else {
      print('❌ Token verification failed');
    }
  }
}





