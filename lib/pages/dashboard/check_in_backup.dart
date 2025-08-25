import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/check_in_store.dart';
import '../../core/stores/auth_store.dart';
import 'components/already_checked_in_widget.dart';
import 'components/check_in_form_widget.dart';

class DashboardCheckInPage extends StatefulWidget {
  const DashboardCheckInPage({super.key});

  @override
  State<DashboardCheckInPage> createState() => _DashboardCheckInPageState();
}

class _DashboardCheckInPageState extends State<DashboardCheckInPage> {
  double _sliderValue = 0.5;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user details when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      authStore.getUserDetails();
    });
  }

  bool _hasCheckedInToday() {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final user = authStore.user;

    // If user has any check-ins, consider them as already checked in
    if (user == null || user.checkIns.isEmpty) {
      return false;
    }

    // Return true if checkIns array has any length greater than 0
    return user.checkIns.isNotEmpty;
  }

  String _getCheckInChoice(double value) {
    if (value <= 0.30) {
      return 'struggling';
    } else if (value <= 0.70) {
      return 'neutral';
    } else {
      return 'excellent';
    }
  }

  void _handleCheckIn(BuildContext context, CheckInStore checkInStore) {
    final checkInChoice = _getCheckInChoice(_sliderValue);
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a description',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF2EFEA),
        textColor: const Color(0xFF3B6EAA),
      );
      return;
    }

    checkInStore.submitCheckIn(
      checkInChoice: checkInChoice,
      description: description,
      onSuccess: () {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.sp, 0.sp, 0.sp, 0.sp),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back arrow in a circle, size 24x24
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(3, 0),
                            child: Image.asset(
                              'assets/img/logo.png',
                              width: 60,
                              height: 39,
                            ),
                          ),
                          // Info icon on the right, size 24x24
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Title
                    Text(
                      'Daily Check-In ',
                      style: TextStyle(
                        fontFamily: 'Canela',
                        fontSize: 36.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Connect with your inner journey today',
                      style: TextStyle(
                        color: Color(0xFFDCE6F0),
                        fontFamily: 'Satoshi',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 26),
                    // Card
                    Consumer<AuthStore>(
                      builder: (context, authStore, child) {
                        // Show loading state while user data is being fetched
                        if (authStore.isLoading || authStore.user == null) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height - 500) / 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        final hasCheckedInToday = _hasCheckedInToday();

                        return Container(
                          margin: hasCheckedInToday 
                            ? EdgeInsets.only(
                                top: (MediaQuery.of(context).size.height - 500) / 2,
                              )
                            : EdgeInsets.only(top: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: hasCheckedInToday 
                                ? const AlreadyCheckedInWidget()
                                : CheckInFormWidget(
                                    sliderValue: _sliderValue,
                                    onSliderChanged: (value) {
                                      setState(() {
                                        _sliderValue = value;
                                      });
                                    },
                                    descriptionController: _descriptionController,
                                    onCheckIn: () {
                                      final checkInStore = Provider.of<CheckInStore>(context, listen: false);
                                      _handleCheckIn(context, checkInStore);
                                    },
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
