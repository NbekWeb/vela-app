import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/svg_icon.dart';

class NeuroplasticityButton extends StatefulWidget {
  const NeuroplasticityButton({super.key});

  @override
  State<NeuroplasticityButton> createState() => _NeuroplasticityButtonState();
}

class _NeuroplasticityButtonState extends State<NeuroplasticityButton> {
  bool _showCard = false;
  String _neuroplasticityContent = 'Each time you reflect, reframe, and affirm your goals, you strengthen synaptic connections in the prefrontal cortex and reinforce identity-based neural pathways.You’re literally reshaping your brain toward your dream life.';

  void _showNeuroplasticityModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3B6EAA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Neuroplasticity',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: TextEditingController(text: _neuroplasticityContent),
            maxLines: 5,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your neuroplasticity content...',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontFamily: 'Satoshi',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              _neuroplasticityContent = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontFamily: 'Satoshi',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title outside the card
          Row(
            children: [
              Text(
                'Neuroplasticity Activated',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _showNeuroplasticityModal,
                child: const SvgIcon(
                  assetName: 'assets/icons/edit.svg',
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Card with internal title
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(164, 199, 234, 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Internal title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You just sparked change in your brain',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Content
                Center(
                  child: Text(
                    _neuroplasticityContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Satoshi',
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showCard = true;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF3B6EAA),
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(
              assetName: 'assets/icons/brain.svg',
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Neuroplasticity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 