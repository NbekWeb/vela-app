import 'package:flutter/material.dart';
import 'package:vela/shared/widgets/stars_animation.dart';

class ZeroGenerator extends StatefulWidget {
  final VoidCallback? onNext;
  const ZeroGenerator({super.key, this.onNext});

  @override
  State<ZeroGenerator> createState() => _ZeroGeneratorState();
}

class _ZeroGeneratorState extends State<ZeroGenerator> {
  @override
  void initState() {
    super.initState();
  }

  //  void initState() {
  //   super.initState();
  //  if (widget.onNext != null) {
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (mounted) widget.onNext!();
  //     });
  //   }
  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const StarsAnimation(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Take a quiet moment to connect with yourself',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                      height: 1.15,
                      letterSpacing: -0.5,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'These questions activate the parts of your brain responsible for vision, clarity, and motivation.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "You're about to build a blueprint for your dream life.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFFF2EFEA),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,

                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return const Color(0xFF3B6EAA).withOpacity(0.5);
                        }
                        return const Color(0xFF3B6EAA);
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.white.withOpacity(0.7);
                        }
                        return Colors.white;
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    onPressed: () {
                      widget.onNext!();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF2EFEA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
