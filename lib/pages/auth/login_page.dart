import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../styles/base_styles.dart';
import '../../styles/pages/login_page_styles.dart';
import '../../shared/widgets/how_work_modal.dart';
import '../../shared/widgets/terms_agreement.dart';
import '../../shared/widgets/custom_toast.dart';
import '../../core/stores/auth_store.dart';
import '../../shared/widgets/notification_handler.dart';
import '../../shared/widgets/google_signin_button.dart';
import '../../shared/widgets/apple_signin_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late KeyboardVisibilityController _keyboardVisibilityController;

  @override
  void initState() {
    super.initState();
    _keyboardVisibilityController = KeyboardVisibilityController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  // Apple Sign-In handler
  Future<void> _handleAppleSignIn() async {
    print('🍎 Apple Sign-In button pressed!');
    
    final authStore = context.read<AuthStore>();
    print('🍎 AuthStore loaded: ${authStore.isLoading}');
    
    await authStore.loginWithApple(
      onSuccess: () async {
        print('🍎 Existing user - redirecting to dashboard');
        
        if (mounted) {
          ToastService.showSuccessToast(
            context, 
            message: 'Welcome back!'
          );
          
          // Request notification permission and send device token
          await NotificationHandler.requestNotificationPermission();
          
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
      onNewUser: () async {
        print('🍎 Profile incomplete - redirecting to appropriate step');
        
        if (mounted) {
          ToastService.showSuccessToast(
            context, 
            message: 'Welcome! Let\'s complete your profile'
          );
          
          // Save "first" variable to localStorage as true for new users
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('first', true);
          } catch (e) {
            // Error saving first variable
          }
          
          // Request notification permission and send device token
          await NotificationHandler.requestNotificationPermission();
          
          // Get the appropriate redirect route based on profile completion
          final authStore = context.read<AuthStore>();
          final redirectRoute = await authStore.getRedirectRoute();
          Navigator.pushReplacementNamed(context, redirectRoute);
        }
      },
    );
  }

  // Google Sign-In handler
  Future<void> _handleGoogleSignIn() async {
    print('🔍 Google Sign-In button pressed!');
    
    final authStore = context.read<AuthStore>();
    print('🔍 AuthStore loaded: ${authStore.isLoading}');
    
    await authStore.loginWithGoogle(
      onSuccess: () async {
        print('🔍 Existing user - redirecting to dashboard');
        
        if (mounted) {
          ToastService.showSuccessToast(
            context, 
            message: 'Welcome back!'
          );
          
          // Request notification permission and send device token
          await NotificationHandler.requestNotificationPermission();
          
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
      onNewUser: () async {
        print('🔍 Profile incomplete - redirecting to appropriate step');
        
        if (mounted) {
          ToastService.showSuccessToast(
            context, 
            message: 'Welcome! Let\'s complete your profile'
          );
          
          // Save "first" variable to localStorage as true for new users
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('first', true);
          } catch (e) {
            // Error saving first variable
          }
          
          // Request notification permission and send device token
          await NotificationHandler.requestNotificationPermission();
          
          // Get the appropriate redirect route based on profile completion
          final authStore = context.read<AuthStore>();
          final redirectRoute = await authStore.getRedirectRoute();
          Navigator.pushReplacementNamed(context, redirectRoute);
        }
      },
    );

    print('🔍 Google Sign-In completed, error: ${authStore.error}');
    
    // Handle error if success callback wasn't called
    if (authStore.error != null && mounted) {
      ToastService.showWarningToast(context, message: authStore.error!);
    }
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authStore = context.read<AuthStore>();
    await authStore.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    final isAuthenticated = await authStore.isAuthenticated();
    if (isAuthenticated && mounted) {
      // Request notification permission and send device token
      await NotificationHandler.requestNotificationPermission();

      // Get the appropriate redirect route based on profile completion
      final redirectRoute = await authStore.getRedirectRoute();
      Navigator.pushReplacementNamed(context, redirectRoute);
    } else if (authStore.error != null && mounted) {
      ToastService.showErrorToast(context, message: authStore.error!);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        textInputAction: label == 'Email address'
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: label == 'Email address'
            ? (_) => FocusScope.of(context).nextFocus()
            : (_) => FocusScope.of(context).unfocus(),
        keyboardType: label == 'Email address'
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: Colors.white,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: LoginPageStyles.subtitleStyle.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: LoginPageStyles.subtitleStyle.copyWith(
            color: Color(0xFFDCE6F0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: LoginPageStyles.translucentBackground,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          isDense: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(26, 218, 3, 3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: LoginPageStyles.borderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: LoginPageStyles.borderColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(onTap: onSuffixTap, child: suffixIcon)
              : null,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: KeyboardVisibilityBuilder(
              controller: _keyboardVisibilityController,
              builder: (context, isKeyboardVisible) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      const Positioned.fill(child: StarsAnimation()),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: isKeyboardVisible ? 0 : 0,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    bottom: isKeyboardVisible ? 20 : 0,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const SizedBox(height: 24),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: BaseStyles.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    // Check if there's a previous route
                                                    if (Navigator.of(
                                                      context,
                                                    ).canPop()) {
                                                      Navigator.of(
                                                        context,
                                                      ).pushReplacementNamed(
                                                        '/onboarding-1',
                                                      );
                                                      // Navigator.of(context).pop();
                                                    } else {
                                                      // If no previous route, navigate to onboarding
                                                      Navigator.of(
                                                        context,
                                                      ).pushReplacementNamed(
                                                        '/onboarding-1',
                                                      );
                                                    }
                                                  },
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/icons/logo.svg',
                                                      width: 60,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.info_outline,
                                                    color: BaseStyles.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    openPopupFromTop(
                                                      context,
                                                      const HowWorkModal(),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 180),
                                            Center(
                                              child: Text(
                                                'Continue to sign in',
                                                style: LoginPageStyles
                                                    .titleStyle
                                                    .copyWith(
                                                      fontSize: 36,
                                                      color: Colors.white,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Center(
                                              child: Text(
                                                "If you already have an account, we'll log you in.",
                                                style: LoginPageStyles
                                                    .subtitleStyle
                                                    .copyWith(
                                                      color: Color(0xFFF2EFEA),
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 36),
                                            _buildTextField(
                                              label: 'Email address',
                                              controller: _emailController,
                                              validator:
                                                  Validators.validateEmail,
                                            ),
                                            _buildTextField(
                                              label: 'Password',
                                              controller: _passwordController,
                                              obscure: _obscurePassword,
                                              validator:
                                                  Validators.validatePassword,
                                              suffixIcon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Color(0xFFF2EFEA),
                                              ),
                                              onSuffixTap: () {
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              height: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF3C6EAB,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                onPressed: authStore.isLoading
                                                    ? null
                                                    : _handleEmailLogin,
                                                child: authStore.isLoading
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(Colors.white),
                                                        ),
                                                      )
                                                    : const Text(
                                                        'Login',
                                                        style: LoginPageStyles
                                                            .orContinueStyle,
                                                      ),
                                              ),
                                            ),
                                            // Social Sign-In Buttons faqat mobile platformalar uchun
                                            if (!kIsWeb) ...[
                                              const SizedBox(height: 20),
                                              // Divider with "or continue with" text
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Text(
                                                    '- or continue with -',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFF2EFEA,
                                                      ),
                                                      fontSize: 16,
                                                      fontFamily: 'Satoshi',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              // Social Sign-In Buttons in a row
                                              Row(
                                                children: [
                                                  // Google Sign-In Button
                                                  Expanded(
                                                    child: GoogleSignInButton(
                                                      onPressed: _handleGoogleSignIn,
                                                      isLoading: authStore.isLoading,
                                                    ),
                                                  ),
                                                  if (Platform.isIOS) ...[
                                                    const SizedBox(width: 16),
                                                    // Apple Sign-In Button (iOS only)
                                                    Expanded(
                                                      child: AppleSignInButton(
                                                        onPressed: _handleAppleSignIn,
                                                        isLoading: authStore.isLoading,
                                                        text: '', // Icon only
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/register',
                                                    );
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text:
                                                          "Don't have an account? ",
                                                      style: LoginPageStyles
                                                          .subtitleStyle
                                                          .copyWith(
                                                            color: Color(
                                                              0xFFDCE6F0,
                                                            ),
                                                          ),
                                                      children: [
                                                        TextSpan(
                                                          text: 'Sign up',
                                                          style: LoginPageStyles
                                                              .orContinueStyle
                                                              .copyWith(
                                                                color: Color(
                                                                  0xFFDCE6F0,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                        SizedBox(
                                          height: isKeyboardVisible
                                              ? 20
                                              : MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isKeyboardVisible)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 40,
                          child: Center(child: const TermsAgreement()),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void openPopupFromTop(BuildContext context, Widget child) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha((0.3 * 255).toInt()),
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
