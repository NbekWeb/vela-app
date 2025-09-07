import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_styles.dart';
import '../../core/stores/check_in_store.dart';
import '../../core/stores/auth_store.dart';
import '../../shared/widgets/full_width_track_shape.dart';
import '../../pages/generator/direct_ritual_page.dart';

class CheckInModal extends StatefulWidget {
  final VoidCallback? onClose;
  const CheckInModal({super.key, this.onClose});

  @override
  State<CheckInModal> createState() => _CheckInModalState();
}

class _CheckInModalState extends State<CheckInModal> {
  double _sliderValue = 0.5;
  final TextEditingController _descriptionController = TextEditingController();

  String _getMoodText(double value) {
    if (value <= 0.30) {
      return 'Struggling';
    } else if (value <= 0.70) {
      return 'Neutral';
    } else {
      return 'Excellent';
    }
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

  String _getMoodImage(double value) {
    if (value <= 0.30) {
      return 'assets/img/struggling.png';
    } else if (value <= 0.70) {
      return 'assets/img/planet.png';
    } else {
      return 'assets/img/excellent.png';
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

    final authStore = Provider.of<AuthStore>(context, listen: false);
    
    checkInStore.submitCheckIn(
      checkInChoice: checkInChoice,
      description: description,
      authStore: authStore,
      onSuccess: () {
        Navigator.of(context).pop(); // Close modal
      },
    );
  }

  static String _formattedDate() {
    final now = DateTime.now();
    return '${_weekday(now.weekday)}, ${now.month}/${now.day}/${now.year}';
  }

  static String _weekday(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
              padding: AppStyles.paddingModal,
              decoration: AppStyles.frostedGlass,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                // Header with back button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppStyles.white,
                        size: 28,
                      ),
                      onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Daily Check-In',
                        textAlign: TextAlign.center,
                        style: AppStyles.headingMedium,
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 10),
                
                // Subtitle
                Text(
                  'Connect with your inner journey today',
                  style: TextStyle(
                    color: Color(0xFFDCE6F0),
                    fontFamily: 'Satoshi',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  
                  ),
                  textAlign: TextAlign.center,
                ),
                 const SizedBox(height: 20),

                // Check-in form
                const Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formattedDate(),
                  style: const TextStyle(
                    color: Color(0xFFDCE6F0),
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Dynamic mood image
                Image.asset(
                  _getMoodImage(_sliderValue),
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  _getMoodText(_sliderValue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Slider
                SizedBox(
                  width: double.infinity,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      activeTrackColor: Color(0xFFC9DFF4),
                      inactiveTrackColor: Color(0xFFC9DFF4),
                      thumbColor: Color(0xFF3B6EAA),
                      overlayColor: Colors.white24,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7.5,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      trackShape: const FullWidthTrackShape(),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      onChanged: (v) {
                        setState(() {
                          _sliderValue = v;
                        });
                      },
                      min: 0,
                      max: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Struggling',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Neutral',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Excellent',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                Text(
                  'How can Vela support you in this exact moment?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'I\'m overwhelmed about my test — I need help calming down.',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(21, 43, 86, 0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(21, 43, 86, 0.3),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      fillColor: Color.fromRGBO(21, 43, 86, 0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Complete Check-In Button
                Consumer<CheckInStore>(
                  builder: (context, checkInStore, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: checkInStore.isLoading
                            ? null
                            : () {
                                _handleCheckIn(context, checkInStore);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B6EAA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: checkInStore.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Complete Check-In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // Generate New Meditation Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DirectRitualPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Generate New Meditation',
                          style: TextStyle(
                            color: Color(0xFF3B6EAA),
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF3B6EAA),
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
