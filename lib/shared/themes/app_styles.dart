import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryBlue = Color.fromARGB(255, 59, 110, 170);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xFFF2EFEA);
  static const Color cream = Color(0xFFF2EFEA);
  static const Color transparentWhite = Color(0x2EFFFFFF);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Canela',
    fontSize: 64,
    color: white,
    height: 1,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Canela',
    fontSize: 36,
    color: Color.fromARGB(255,242, 239, 234),
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Canela',
    fontSize: 28,
    color: white,
    fontWeight: FontWeight.w400,
    letterSpacing: 2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: cream,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: cream,
    fontFamily: 'Satoshi',
    height: 1.25,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontFamily: 'Canela',
    color: white,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: 16,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    color: white,
    decoration: TextDecoration.none,
  );

  static const TextStyle linkText = TextStyle(
    color: Color.fromARGB(255, 242, 239, 234),
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
  );

  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    minimumSize: const Size.fromHeight(56),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  );

  static ButtonStyle modalButton = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: const EdgeInsets.symmetric(vertical: 18),
    elevation: 0,
  );

  // Container Styles
  static BoxDecoration frostedGlass = BoxDecoration(
    color: transparentWhite,
    borderRadius: BorderRadius.circular(16),
  );

  // Spacing
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: 24.0,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: 32.0,
  );
  static const EdgeInsets paddingAll = EdgeInsets.all(16.0);
  static const EdgeInsets paddingModal = EdgeInsets.fromLTRB(24, 32, 24, 32);

  static const SizedBox spacingSmall = SizedBox(height: 16);
  static const SizedBox spacingMedium = SizedBox(height: 20);
  static const SizedBox spacingLarge = SizedBox(height: 32);

  // Border Radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusMedium = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(28));
  static const BorderRadius radiusExtraLarge = BorderRadius.all(
    Radius.circular(30),
  );

  // Shadows
  static List<BoxShadow> shadowLight = [
    BoxShadow(
      color: const Color(0x1A000000),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: const Color(0x26000000),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}

class CustomSelect<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String? hint;

  const CustomSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<T>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: AppStyles.primaryBlue.withAlpha((0.15 * 255).toInt()),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .map(
                      (e) => ListTile(
                        title: Text(
                          e.toString(),
                          style: AppStyles.buttonTextSmall.copyWith(
                            color: value == e
                                ? AppStyles.white
                                : AppStyles.white.withOpacity(0.7),
                            fontWeight: value == e
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(e),
                        selected: value == e,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
        if (result != null && result != value) {
          onChanged(result);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.transparentWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString(), style: AppStyles.buttonTextSmall),
            Icon(Icons.keyboard_arrow_down, color: AppStyles.white),
          ],
        ),
      ),
    );
  }
}
