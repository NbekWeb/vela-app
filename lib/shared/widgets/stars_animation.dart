import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StarsAnimation extends StatefulWidget {
  final Color topColor;
  final Color bottomColor;
  final int starCount;

  const StarsAnimation({
    super.key,
    this.topColor = const Color(0xFF3C6EAB),
    this.bottomColor = const Color(0xFFA4C6EB),
    this.starCount = 55,
  });

  @override
  State<StarsAnimation> createState() => _StarsAnimationState();
}

class _StarsAnimationState extends State<StarsAnimation> {
  List<Widget> stars = [];
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStars();
    });
  }

  void _initializeStars() {
    if (!mounted) return;
    
    final random = Random();
    screenSize = MediaQuery.of(context).size;
    
    setState(() {
      stars = List.generate(widget.starCount, (index) {
        final top = random.nextDouble() * 100;
        final left = random.nextDouble() * 100;
        final delay = random.nextDouble() * 2;
        return Positioned(
          top: top * screenSize.height / 100,
          left: left * screenSize.width / 100,
          child: TwinklingStar(delay: delay),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (stars.isEmpty) {
      return SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [widget.topColor, widget.bottomColor],
            ),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [widget.topColor, widget.bottomColor],
              ),
            ),
          ),
          ...stars,
        ],
      ),
    );
  }
}

class TwinklingStar extends StatefulWidget {
  final double delay;
  const TwinklingStar({super.key, required this.delay});

  @override
  State<TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<TwinklingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = _controller.value;
        double scale, opacity;
        if (value <= 0.5) {
          scale = 0.3 + (value * 2 * 0.2);
          opacity = value * 2;
        } else {
          scale = 0.5;
          opacity = 1.0 - ((value - 0.5) * 2);
        }
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class StarsAnimationPage extends StatefulWidget {
  const StarsAnimationPage({super.key});

  @override
  State<StarsAnimationPage> createState() => _StarsAnimationPageState();
}

class _StarsAnimationPageState extends State<StarsAnimationPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: StarsAnimation(),
      ),
    );
  }
} 