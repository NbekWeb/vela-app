import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:io';
import '../services/api_service.dart';
import '../../shared/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Pinia store ga o'xshash AuthStore - API chaqiruvlar va ma'lumotlarni saqlash
class AuthStore extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  String? _accessToken;
  String? _refreshToken;

  // Services
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // iOS uchun soddalashtirilgan sozlamalar
    signInOption: SignInOption.standard,
  );
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Global variable for ID token
  static String? _lastIdToken;
  static String? get lastIdToken => _lastIdToken;

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

  // Check if user profile is complete
  bool isProfileComplete() {
    if (_user == null) return false;

    // Check if essential profile fields are filled
    final hasGender = _user!.gender != null && _user!.gender!.isNotEmpty;
    final hasAgeRange = _user!.ageRange != null && _user!.ageRange!.isNotEmpty;
    final hasDream = _user!.dream != null && _user!.dream!.isNotEmpty;
    final hasGoals = _user!.goals != null && _user!.goals!.isNotEmpty;
    final hasHappiness =
        _user!.happiness != null && _user!.happiness!.isNotEmpty;

    return hasGender && hasAgeRange && hasDream && hasGoals && hasHappiness;
  }

  // Check if user has selected a plan
  Future<bool> hasSelectedPlan() async {
    try {
      final planType = await _secureStorage.read(key: 'plan_type');
      return planType != null && planType.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get the appropriate redirect route based on profile completion
  Future<String> getRedirectRoute() async {
    if (!isProfileComplete()) {
      // If profile is not complete, check which step to start from
      if (_user?.gender == null || _user!.gender!.isEmpty) {
        return '/generator'; // Start from gender step
      }
      return '/generator'; // Continue from where they left off
    }

    final hasPlan = await hasSelectedPlan();
    if (!hasPlan) {
      return '/plan'; // Need to select a plan
    }

    return '/dashboard'; // Profile is complete, go to dashboard
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

    // Update API Service memory token
    if (accessToken != null) {
      try {
        ApiService.setMemoryToken(accessToken);
      } catch (e) {
        print('🔍 Error setting memory token: $e');
      }
    }

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

        // Update API Service memory token
        if (_accessToken != null) {
          ApiService.setMemoryToken(_accessToken);
        }

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
        try {
          await _secureStorage.write(key: 'access_token', value: accessToken);
          if (refreshToken != null) {
            await _secureStorage.write(
              key: 'refresh_token',
              value: refreshToken,
            );
          }
        } catch (e) {
          // If token already exists, delete it first then write
          if (e.toString().contains('already exists')) {
            await _secureStorage.delete(key: 'access_token');
            await _secureStorage.write(key: 'access_token', value: accessToken);
            if (refreshToken != null) {
              await _secureStorage.delete(key: 'refresh_token');
              await _secureStorage.write(
                key: 'refresh_token',
                value: refreshToken,
              );
            }
          }
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
  Future<void> loginWithGoogle({
    VoidCallback? onSuccess,
    VoidCallback? onNewUser, // Yangi user uchun callback
  }) async {
    // Web platformasi uchun Google Sign-In o'chirilgan
    if (kIsWeb) {
      setError('Google Sign-In is not available on web platform');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log('❌ Google Sign-In was cancelled');
        setError('Google Sign-In was cancelled');
        return;
      }

      // Get authentication data
      GoogleSignInAuthentication? auth;
      try {
        auth = await googleUser.authentication;
      } catch (authError) {
        developer.log('❌ Auth error: $authError');
        return;
      }

      // Firebase Authentication bilan sign-in qilish (faqat mobile platformalar uchun)
      if (auth.idToken != null && !kIsWeb) {
        try {
          developer.log('🔍 Firebase Authentication bilan sign-in qilish...');

          // Firebase credential yaratish
          final credential = GoogleAuthProvider.credential(
            idToken: auth.idToken,
            accessToken: auth.accessToken,
          );

          // Firebase Authentication bilan sign-in
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(credential);
          final firebaseUser = userCredential.user;

          if (firebaseUser != null) {
            // ID token'ni global variable'ga saqlash
            _lastIdToken = auth.idToken;

            // Firebase ID token'ni olish
            final firebaseIdToken = await firebaseUser.getIdToken();

            // Firebase login API ga so'rov yuborish
            try {
              final response = await ApiService.request(
                url: 'auth/firebase/login/',
                method: 'POST',
                data: {'firebase_id_token': firebaseIdToken},
                open: true, // Bu endpoint uchun token kerak emas
              );

              // Backend token'ni saqlash
              if (response.data['access_token'] != null) {
                await _secureStorage.write(
                  key: 'access_token',
                  value: response.data['access_token'],
                );
                setTokens(accessToken: response.data['access_token']);

                // User details'ni olish
                await getUserDetails();

                // Check profile completion and redirect accordingly
                final redirectRoute = await getRedirectRoute();
                if (redirectRoute == '/dashboard') {
                  // Profile is complete - go to dashboard
                  onSuccess?.call();
                } else {
                  // Profile incomplete - go to appropriate step
                  onNewUser?.call();
                }
              }
            } catch (e) {
              setError('Firebase authentication failed. Please try again.');
            }
          } else {
            setError('Firebase Authentication failed. User is null.');
          }
        } catch (firebaseError) {
          developer.log('❌ Firebase Authentication error: $firebaseError');
          setError('Firebase Authentication failed: $firebaseError');
        }
      } else {
        setError('Google ID Token is null. Cannot authenticate.');
      }
    } catch (e) {
      String errorMessage = 'Google Sign-In failed. Please try again.';

      if (e.toString().contains('12501')) {
        errorMessage = 'Google Sign-In was cancelled by user.';
      } else if (e.toString().contains('12500')) {
        errorMessage =
            'Google Sign-In failed. Please check your internet connection.';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Invalid Google credentials.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Unauthorized. Please try again.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      } else if (e.toString().contains('configuration')) {
        errorMessage =
            'Google Sign-In configuration error. Please restart the app.';
      } else if (Platform.isIOS) {
        // iOS uchun maxsus xatoliklar
        if (e.toString().contains('12501')) {
          errorMessage = 'Google Sign-In was cancelled by user.';
        } else if (e.toString().contains('12500')) {
          errorMessage =
              'Google Sign-In failed. Please check your internet connection.';
        } else if (e.toString().contains('network')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (e.toString().contains('sign_in_failed')) {
          errorMessage = 'Google Sign-In failed. Please try again.';
        } else if (e.toString().contains('sign_in_canceled')) {
          errorMessage = 'Google Sign-In was cancelled.';
        } else {
          errorMessage = 'Google Sign-In failed. Please try again.';
        }
      }

      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  }

  // Apple Sign In
  Future<void> loginWithApple({
    VoidCallback? onSuccess,
    VoidCallback? onNewUser, // Yangi user uchun callback
  }) async {
    setLoading(true);
    setError(null);

    try {
      // Apple Sign In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) {
        developer.log('❌ Apple Sign-In failed: No identity token');
        setError('Apple Sign-In failed: No identity token');
        return;
      }

      // Firebase Authentication bilan sign-in qilish
      try {
        developer.log('🔍 Firebase Authentication bilan Apple sign-in qilish...');

        // Firebase credential yaratish
        final firebaseCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        // Firebase Authentication bilan sign-in
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(firebaseCredential);
        final firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // ID token'ni global variable'ga saqlash
          _lastIdToken = credential.identityToken;

          // Firebase ID token'ni olish
          final firebaseIdToken = await firebaseUser.getIdToken();

          // Firebase login API ga so'rov yuborish
          try {
            final response = await ApiService.request(
              url: 'auth/firebase/login/',
              method: 'POST',
              data: {'firebase_id_token': firebaseIdToken},
              open: true, // Bu endpoint uchun token kerak emas
            );

            // Backend token'ni saqlash
            if (response.data['access_token'] != null) {
              await _secureStorage.write(
                key: 'access_token',
                value: response.data['access_token'],
              );
              setTokens(accessToken: response.data['access_token']);

              // User details'ni olish
              await getUserDetails();

              // Check profile completion and redirect accordingly
              final redirectRoute = await getRedirectRoute();
              if (redirectRoute == '/dashboard') {
                // Profile is complete - go to dashboard
                onSuccess?.call();
              } else {
                // Profile incomplete - go to appropriate step
                onNewUser?.call();
              }
            }
          } catch (e) {
            setError('Firebase authentication failed. Please try again.');
          }
        } else {
          setError('Firebase Authentication failed. User is null.');
        }
      } catch (firebaseError) {
        developer.log('❌ Firebase Authentication error: $firebaseError');
        setError('Firebase Authentication failed: $firebaseError');
      }
    } catch (e) {
      String errorMessage = 'Apple Sign-In failed. Please try again.';

      if (e.toString().contains('SignInWithAppleAuthorizationException')) {
        if (e.toString().contains('canceled')) {
          errorMessage = 'Apple Sign-In was cancelled by user.';
        } else if (e.toString().contains('failed')) {
          errorMessage = 'Apple Sign-In failed. Please try again.';
        } else if (e.toString().contains('invalidResponse')) {
          errorMessage = 'Invalid Apple Sign-In response.';
        } else if (e.toString().contains('notHandled')) {
          errorMessage = 'Apple Sign-In not handled.';
        } else if (e.toString().contains('unknown')) {
          errorMessage = 'Unknown Apple Sign-In error.';
        }
      }

      setError(errorMessage);
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

      await ApiService.request(
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
        
        // Check if user has gender, if not redirect to gender selection
        if (user.gender == null || user.gender!.isEmpty) {
          developer.log('🔍 User gender is missing, redirecting to gender selection');
          // This will be handled by getRedirectRoute() in the calling function
        }
      }
    } catch (e) {
      developer.log('❌ Get user details error: $e');
    }
  }

  // Facebook login action with API call
  Future<void> loginWithFacebook({
    VoidCallback? onSuccess,
    VoidCallback? onNewUser,
  }) async {
    // Web platformasi uchun Facebook Sign-In o'chirilgan
    if (kIsWeb) {
      setError('Facebook Sign-In is not available on web platform');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // Facebook Sign-In with Standard Login (non-limited) to get full access token
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        // Use Standard Login to get full access token (not Limited Login)
      );

      if (result.status == LoginStatus.success) {
        // Get user data from Facebook
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        // Get the standard access token
        try {
          // Get current access token
          final currentToken = await FacebookAuth.instance.accessToken;

          // Try to get token as string
          if (currentToken != null) {
            // Prepare data for auth/facebook/register/ endpoint
            final registerData = {
              "first_name": userData['name']?.split(' ').first ?? '',
              "last_name": userData['name']?.split(' ').skip(1).join(' ') ?? '',
              "email": userData['email'] ?? '',
            };

            // Send request to auth/facebook/register/ endpoint
            final response = await ApiService.request(
              url: 'auth/facebook/register/',
              method: 'POST',
              data: registerData,
              open: true,
            );

            // Store access token from response
            if (response.data['access_token'] != null) {
              try {
                await _secureStorage.write(
                  key: 'access_token',
                  value: response.data['access_token'],
                );
                setTokens(accessToken: response.data['access_token']);
              } catch (e) {
                // If token already exists, delete it first then write
                if (e.toString().contains('already exists')) {
                  await _secureStorage.delete(key: 'access_token');
                  await _secureStorage.write(
                    key: 'access_token',
                    value: response.data['access_token'],
                  );
                  setTokens(accessToken: response.data['access_token']);
                } else {
                  print('❌ Error storing access token: $e');
                }
              }

              // Get user details to determine if new or existing user
              await getUserDetails();

              // Check profile completion and redirect accordingly
              final redirectRoute = await getRedirectRoute();
              if (redirectRoute == '/dashboard') {
                // Profile is complete - go to dashboard
                onSuccess?.call();
              } else {
                // Profile incomplete - go to appropriate step
                onNewUser?.call();
              }
            } else {
              print('❌ No access token in response');
            }
          }
        } catch (e) {
          print('🔍 Error getting current token: $e');
        }
      } else if (result.status == LoginStatus.cancelled) {
        setError('Facebook Sign-In was cancelled');
      } else {
        setError('Facebook Sign-In failed: ${result.message}');
      }
    } catch (e) {
      String errorMessage = 'Facebook Sign-In failed. Please try again.';

      if (e.toString().contains('cancelled')) {
        errorMessage = 'Facebook Sign-In was cancelled by user.';
      } else if (e.toString().contains('network')) {
        errorMessage =
            'Facebook Sign-In failed. Please check your internet connection.';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Facebook permissions denied. Please try again.';
      } else if (e.toString().contains('configuration')) {
        errorMessage =
            'Facebook Sign-In configuration error. Please restart the app.';
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = 'Facebook authentication token issue. Please try again.';
      }

      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  }

  // Logout action (Pinia'ga o'xshash)
  Future<void> logout() async {
    try {
      // Faqat mobile platformalar uchun social auth logout
      if (!kIsWeb) {
        await _googleSignIn.signOut();
        await FacebookAuth.instance.logOut();
      }

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

  // Get Firebase ID Token (faqat mobile platformalar uchun)
  Future<String?> getFirebaseIdToken() async {
    if (kIsWeb) {
      print('🔍 Firebase ID Token not available on web platform');
      return null;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final idToken = await currentUser.getIdToken();
        return idToken;
      } else {
        print('🔍 No Firebase user logged in');
        return null;
      }
    } catch (e) {
      print('🔍 Error getting Firebase ID Token: $e');
      return null;
    }
  }

  // Assign free trial and save to store
  Future<void> assignFreeTrial() async {
    setLoading(true);
    setError(null);

    try {
      await ApiService.request(url: 'auth/assign-free-trial/', method: 'POST');
    } catch (e) {
      setError('Failed to assign free trial');
      // Toast will be shown from the UI layer
    } finally {
      setLoading(false);
    }
  }

  // Helper method to format age range to required format
  String _formatAgeRange(String ageRange) {
    try {
      int age = int.parse(ageRange);

      if (age >= 18 && age <= 24) {
        return '18-24';
      } else if (age >= 25 && age <= 34) {
        return '25-34';
      } else if (age >= 35 && age <= 44) {
        return '35-44';
      } else if (age >= 45 && age <= 54) {
        return '45-54';
      } else {
        return '55-64';
      }
    } catch (e) {
      // If parsing fails, return default value
      return '55-64';
    }
  }

  // Update user detail information (gender, age_range, dream, goals, happiness)
  Future<void> updateUserDetail({
    required String gender,
    required String ageRange,
    required String dream,
    required String goals,
    required String happiness,
    VoidCallback? onSuccess,
  }) async {
    setLoading(true);
    setError(null);

    try {
      // Format age range to required format
      String formattedAgeRange = _formatAgeRange(ageRange);

      final requestData = {
        'gender': gender,
        'age_range': formattedAgeRange,
        'dream': dream,
        'goals': goals,
        'happiness': happiness,
      };

      // Ensure token is in API Service memory
      if (_accessToken != null) {
        ApiService.setMemoryToken(_accessToken);
      }

      // Re-initialize API Service to ensure interceptors work
      ApiService.init();

      final response = await ApiService.request(
        url: 'auth/user-detail-update/',
        method: 'PUT',
        data: requestData,
        open: false, // Token required
      );

      if (response.statusCode == 200) {
        // Update local user data
        if (_user != null) {
          final updatedUser = _user!.copyWith(
            gender: gender,
            ageRange: ageRange,
            dream: dream,
            goals: goals,
            happiness: happiness,
          );
          setUser(updatedUser);
        }

        // Show success toast
        Fluttertoast.showToast(
          msg: 'User details updated successfully!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        onSuccess?.call();
      }
    } catch (e) {
      developer.log('❌ Update user detail error: $e');

      setError('Failed to update user details');

      // Show error toast
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
      if (avatarBytes != null ||
          (avatar != null &&
              (avatar.startsWith('/') || avatar.startsWith('blob:')))) {
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

        await ApiService.request(
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

  // Get profile data with life_visions from API
  Future<List<LifeVision>> getProfileDataWithLifeVisions() async {
    try {
      final response = await ApiService.request(
        url: 'auth/life-vision/',
        method: 'GET',
      );

      // Parse response data
      final responseData = response.data;

      // Handle direct array response from API
      if (responseData != null && responseData is List) {
        final lifeVisions = responseData
            .map((vision) => LifeVision.fromJson(vision))
            .toList();

        return lifeVisions;
      }

      return [];
    } catch (e) {
      developer.log('❌ Get profile data with life visions error: $e');
      return [];
    }
  }

  // Create a new LifeVision with POST request
  Future<LifeVision?> createLifeVision({
    required String title,
    required String description,
    required String visionType,
  }) async {
    try {
      // Validate visionType
      if (!['north_star', 'goal', 'dream'].contains(visionType)) {
        throw Exception('Invalid visionType');
      }

      print('🌐 CALLING POST API: auth/life-vision/create/');
      final response = await ApiService.request(
        url: 'auth/life-vision/create/',
        method: 'POST',
        data: {
          'live_vision': title,
          'dreams_realized': description,
          'vision_type': [visionType],
        },
      );

      final responseData = response.data;

      if (responseData != null) {
        final newVision = LifeVision.fromJson(responseData);
        return newVision;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Update a specific LifeVision's visionType
  Future<LifeVision?> updateLifeVisionType({
    required int visionId,
    required List<String> newVisionType,
  }) async {
    try {
      // Validate newVisionType
      for (String type in newVisionType) {
        if (!['north_star', 'goal', 'dream'].contains(type)) {
          throw Exception('Invalid visionType: $type');
        }
      }

      final response = await ApiService.request(
        url: 'auth/life-vision/$visionId/',
        method: 'PUT',
        data: {
          'vision_type': newVisionType,
          'live_vision': '',
          'dreams_realized': '',
        },
      );

      final responseData = response.data;

      if (responseData != null) {
        // Assuming the API returns the updated LifeVision object
        final updatedVision = LifeVision.fromJson(responseData);
        return updatedVision;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
