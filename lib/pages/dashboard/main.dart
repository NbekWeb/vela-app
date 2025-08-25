import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../main.dart' show globalMeditationId;
import 'home.dart';
import 'vault.dart';
import 'check_in.dart';
import 'profile.dart';
import 'settings_page.dart';
import 'edit_info_page.dart';
import 'reminders_page.dart';
import 'components/home_icon.dart';
import 'components/vault_icon.dart';
import '../../shared/widgets/svg_icon.dart';
import 'components/check_icon.dart';
import 'components/profile_icon.dart';
import 'components/dashboard_audio_player.dart';
import '../generator/direct_ritual_page.dart';

class DashboardMainPage extends StatefulWidget {
  const DashboardMainPage({super.key});

  @override
  State<DashboardMainPage> createState() => DashboardMainPageState();
}

class DashboardMainPageState extends State<DashboardMainPage> {
  int _selectedIndex = 0;
  String? _currentAudioId;

  void navigateToSettings() {
    setState(() {
      _selectedIndex = 4;
    });
  }

  void navigateToProfile() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  void navigateToEditInfo() {
    setState(() {
      _selectedIndex = 5;
    });
  }

  void navigateToReminders() {
    setState(() {
      _selectedIndex = 6;
    });
  }

  @override
  void initState() {
    super.initState();
    // Check if there's a global meditation ID to play
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (globalMeditationId != null) {
        showAudioPlayer(globalMeditationId!);
        globalMeditationId = null; // Clear the global variable
      }
    });
  }

  List<Widget> get _pages => [
    DashboardHomePage(),
    DashboardVaultPage(
      onAudioPlay: (meditationId) {
        setState(() {
          _currentAudioId = meditationId;
          _selectedIndex = 7; // Audio player is now at index 7
        });
      },
    ),
    DashboardCheckInPage(),
    DashboardProfilePage(),
    SettingsPage(),
    EditInfoPage(),
    RemindersPage(),
    if (_currentAudioId != null)
      DashboardAudioPlayer(meditationId: _currentAudioId!),
  ];

  void showAudioPlayer(String meditationId) {
    setState(() {
      _currentAudioId = meditationId;
      _selectedIndex = 7; // Audio player is now at index 7
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Color(0xFFA4C6EB)),

        Scaffold(
          body: _pages[_selectedIndex],
          backgroundColor: _selectedIndex == 0
              ? Color(0xFF5799D6)
              : Colors.transparent, // Home page uchun rang, boshqalari uchun transparent
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(bottom: 0),
            padding:
                !kIsWeb && (Theme.of(context).platform == TargetPlatform.iOS)
                ? EdgeInsets.only(
                    top: 10,
                    bottom: 5 + MediaQuery.of(context).viewPadding.bottom,
                    left: 20,
                    right: 20,
                  )
                : const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                  icon: HomeIcon(
                    filled: _selectedIndex == 0,
                    opacity: _selectedIndex == 0 ? 1.0 : 0.5,
                  ),
                  label: 'Home',
                  selected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _NavItem(
                  icon: VaultIcon(
                    filled: _selectedIndex == 1,
                    opacity: _selectedIndex == 1 ? 1.0 : 0.5,
                  ),
                  label: 'Vault',
                  selected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                // Center star button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DirectRitualPage()),
                    );
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(60, 110, 171, 1),
                          Color.fromRGBO(164, 198, 235, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: SvgIcon(
                        assetName: 'assets/menu/star.svg',
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _NavItem(
                  icon: CheckIcon(
                    filled: _selectedIndex == 2,
                    opacity: _selectedIndex == 2 ? 1.0 : 0.5,
                  ),
                  label: 'Check-in',
                  selected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _NavItem(
                  icon: ProfileIcon(
                    filled: _selectedIndex == 3 || _selectedIndex == 4,
                    opacity: (_selectedIndex == 3 || _selectedIndex == 4) ? 1.0 : 0.5,
                  ),
                  label: 'Profile',
                  selected: _selectedIndex == 3 || _selectedIndex == 4,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, // Fixed width for nav items
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                letterSpacing: -0.1.sp,
                color: selected
                    ? Color(0xFF3B6EAA)
                    : Color(0xFF3B6EAA).withValues(alpha: 0.5),
                fontWeight: selected ? FontWeight.bold : FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center align text
            ),
          ],
        ),
      ),
    );
  }
}
