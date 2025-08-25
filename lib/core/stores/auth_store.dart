import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;
import 'dart:typed_data';
import '../services/api_service.dart';
import '../../shared/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Pinia store ga o'xshash AuthStore - API chaqiruvlar va ma'lumotlarni saqlash
class AuthStore extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  String? _accessToken;
  String? _refreshToken;

  // Services
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Getters (Pinia'ga o'xshash)
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  
  // Check authentication status directly from storage
  Future<bool> isAuthenticated() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Actions (Pinia actions ga o'xshash)
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  void setTokens({String? accessToken, String? refreshToken}) {
    if (accessToken != null) _accessToken = accessToken;
    if (refreshToken != null) _refreshToken = refreshToken;
    notifyListeners();
  }



  // Initialize store - check if user is already logged in
  Future<void> initialize() async {
    try {
      // Initialize ApiService
      ApiService.init();

      // Check if user is authenticated and get user details if needed
      final isAuth = await isAuthenticated();
      if (isAuth) {
        // Load token to memory for API calls
        _accessToken = await _secureStorage.read(key: 'access_token');
        await getUserDetails();
      }
    } catch (e) {}
  }

  // Login action with API call
  Future<void> login({
    required String email,
    required String password,
    VoidCallback? onSuccess,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/signin/',
        method: 'POST',
        data: {'identifier': email, 'password': password},
        open: true, // Bu endpoint uchun token kerak emas
      );

      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];

      if (accessToken != null) {
        await _secureStorage.write(key: 'access_token', value: accessToken);
        if (refreshToken != null) {
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        }

        setTokens(accessToken: accessToken, refreshToken: refreshToken);

        // Get user details from API
        await getUserDetails();

        // Call success callback
        onSuccess?.call();
      }
    } catch (e) {
      String errorMessage = 'Login failed. Please check your credentials.';

      if (e.toString().contains('400')) {
        errorMessage = 'Invalid email or password.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Unauthorized. Please check your credentials.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }

      setError(errorMessage);
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }

  // Google login action with API call
  Future<void> loginWithGoogle() async {
    setLoading(true);
    setError(null);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setError('Google Sign-In was cancelled');
        return;
      }

      // Get authentication data
      GoogleSignInAuthentication? auth;
      try {
        auth = await googleUser.authentication;
      } catch (authError) {
        setError('Failed to get Google authentication tokens');
        return;
      }

      // TODO: Send Google tokens to your API for verification
      // For now, create a mock user
      final displayName = googleUser.displayName ?? 'Google User';
      final nameParts = displayName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'Google';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'User';
      
      final user = UserModel(
        id: googleUser.id,
        firstName: firstName,
        lastName: lastName,
        email: googleUser.email,
        avatar: googleUser.photoUrl,
        createdAt: DateTime.now(),
      );

      setUser(user);
      setTokens(
        accessToken: 'google_access_token',
        refreshToken: 'google_refresh_token',
      );

      // Get user details from API
      await getUserDetails();
    } catch (e) {
      setError('Google Sign-In failed. Please try again.');
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }

  // Register action with API call
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    VoidCallback? onSuccess,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final data = {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "password_confirm": password,
        "is_agree": true,
      };

      final response = await ApiService.request(
        url: 'auth/signup/',
        method: 'POST',
        data: data,
        open: true, // Bu endpoint uchun token kerak emas
      );
      await login(email: email, password: password, onSuccess: onSuccess);
    } catch (e) {
      String errorMessage = 'Registration failed. Please try again.';

      if (e.toString().contains('400')) {
        errorMessage = 'This email is already registered.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Unauthorized. Please try again.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }

      setError(errorMessage);
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }

  // Get user details from API
  Future<void> getUserDetails() async {
    try {
      final response = await ApiService.request(
        url: 'auth/user-detail/',
        method: 'GET',
      );

      // Parse user data from response
      final userData = response.data;
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        setUser(user);
      }
    } catch (e) {
      developer.log('❌ Get user details error: $e');
    }
  }

  // Logout action (Pinia'ga o'xshash)
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');

      _user = null;
      _accessToken = null;
      _refreshToken = null;
      _error = null;

      notifyListeners();
    } catch (e) {
      developer.log('❌ Logout error: $e');
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }



  // Assign free trial and save to store
  Future<void> assignFreeTrial() async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/assign-free-trial/',
        method: 'POST',
      );
    } catch (e) {
      setError('Failed to assign free trial');
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }

  // Update user profile information
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? avatar,
    Uint8List? avatarBytes,
    VoidCallback? onSuccess,
  }) async {
    setLoading(true);
    setError(null);

    try {
      // If we have avatar bytes or it's a file path/blob URL, we need to handle it as a file upload
      if (avatarBytes != null || (avatar != null && (avatar.startsWith('/') || avatar.startsWith('blob:')))) {
        // This is a file upload
        final Map<String, dynamic> data = {
          'first_name': firstName,
          'last_name': lastName,
        };

        // Add avatar data - we'll handle this in the API service
        if (avatarBytes != null) {
          data['avatar_bytes'] = avatarBytes;
        } else if (avatar != null) {
          data['avatar'] = avatar;
        }

        final response = await ApiService.uploadFile(
          url: 'auth/user-detail/',
          method: 'PUT',
          data: data,
        );

        // Update local user data with the response
        if (_user != null && response.data != null) {
          final userData = response.data;
          if (userData is Map<String, dynamic>) {
            final updatedUser = UserModel.fromJson(userData);
            setUser(updatedUser);
          } else {
            // Fallback to local update
            final updatedUser = _user!.copyWith(
              firstName: firstName,
              lastName: lastName,
              avatar: avatar,
            );
            setUser(updatedUser);
          }
        }
      } else {
        // Regular text update
        final data = {
          'first_name': firstName,
          'last_name': lastName,
          'avatar': avatar?.isEmpty == true ? null : avatar,
        };

        final response = await ApiService.request(
          url: 'auth/user-detail/',
          method: 'PUT',
          data: data,
        );

        // Update local user data
        if (_user != null) {
          final updatedUser = _user!.copyWith(
            firstName: firstName,
            lastName: lastName,
            avatar: avatar?.isEmpty == true ? null : avatar,
          );
          setUser(updatedUser);
        }
      }

      onSuccess?.call();
    } catch (e) {
      String errorMessage = 'Profile update failed. Please try again.';

      if (e.toString().contains('400')) {
        errorMessage = 'Invalid data provided.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Unauthorized. Please login again.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }

      setError(errorMessage);
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }
}
