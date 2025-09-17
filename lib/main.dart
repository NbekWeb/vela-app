import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_constants.dart';
import 'shared/themes/app_theme.dart';
import 'core/stores/auth_store.dart';
import 'core/stores/meditation_store.dart';
import 'core/stores/like_store.dart';
import 'core/stores/check_in_store.dart';
import 'pages/loading_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/dashboard/main.dart';
import 'pages/auth/starter_page.dart';
import 'pages/auth/onboarding_page_1.dart';
import 'pages/auth/onboarding_page_2.dart';
import 'pages/auth/onboarding_page_3.dart';
import 'pages/auth/onboarding_page_4.dart';
import 'pages/plan_page.dart';
import 'pages/generator/generator_page.dart';
import 'pages/vault_page.dart';
import 'pages/dashboard/my_meditations_page.dart';
import 'pages/dashboard/archive_page.dart';
import 'pages/dashboard/reminders_page.dart';
import 'pages/edit_info_page.dart';
import 'pages/dashboard/components/dashboard_audio_player.dart';
import 'core/utils/video_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

// Global navigator key for API service
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Global variable to store meditation ID for audio player
String? globalMeditationId;

// Global variable to navigate to profile tab
bool shouldNavigateToProfile = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize stores
  final authStore = AuthStore();
  final meditationStore = MeditationStore();
  final likeStore = LikeStore();
  final checkInStore = CheckInStore();

  await authStore.initialize();
  await meditationStore.initialize();

  // Preload videos before app starts
  await VideoLoader.initializeVideos();

  // Check if user is authenticated using the store method
  String initialRoute = '/loading';
  final isAuthenticated = await authStore.isAuthenticated();
  if (isAuthenticated) {
    // Still go to loading screen to check authentication and profile completion
    initialRoute = '/loading';
  }

  runApp(
    MyApp(
      authStore: authStore,
      meditationStore: meditationStore,
      likeStore: likeStore,
      checkInStore: checkInStore,
      initialRoute: initialRoute,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthStore authStore;
  final MeditationStore meditationStore;
  final LikeStore likeStore;
  final CheckInStore checkInStore;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.authStore,
    required this.meditationStore,
    required this.likeStore,
    required this.checkInStore,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authStore),
          ChangeNotifierProvider.value(value: meditationStore),
          ChangeNotifierProvider.value(value: likeStore),
          ChangeNotifierProvider.value(value: checkInStore),
        ],
        child: ScreenUtilInit(
          designSize: Size(
            390,
            844,
          ), // ← здесь укажи размер твоего дизайна (из Figma и т.п.)
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: AppConstants.appName,
              theme: AppTheme.lightTheme.copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                    TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                  },
                ),
              ),
              darkTheme: AppTheme.darkTheme.copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                    TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
              routes: {
                '/loading': (context) => const LoadingScreen(),
                '/starter': (context) => const StarterPage(),
                '/onboarding-1': (context) => const OnboardingPage1(),
                '/onboarding-2': (context) => const OnboardingPage2(),
                '/onboarding-3': (context) => const OnboardingPage3(),
                '/onboarding-4': (context) => const OnboardingPage4(),
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),
                '/plan': (context) => const PlanPage(),
                '/generator': (context) => const GeneratorPage(),
                '/vault': (context) => const VaultPage(),
                '/dashboard': (context) => const DashboardMainPage(),
                '/my-meditations': (context) => MyMeditationsPage(
                  onAudioPlay: (meditationId) {
                    globalMeditationId = meditationId;
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                '/archive': (context) => const ArchivePage(),
                '/reminders': (context) => const RemindersPage(),
                '/edit-info': (context) => const EditInfoPage(),
                '/audio-player': (context) {
                  final args =
                      ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>?;
                  return DashboardAudioPlayer(
                    meditationId: args?['meditationId'] ?? '',
                    title: args?['title'],
                    description: args?['description'],
                    imageUrl: args?['imageUrl'],
                  );
                },
              },
            );
          },
        ),
      ),
    );
  }
}
