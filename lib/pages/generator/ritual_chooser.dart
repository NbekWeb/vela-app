import 'package:flutter/material.dart';

class RitualChooser extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final bool showBackButton;
  final bool showInfoButton;

  const RitualChooser({
    super.key,
    this.onBack,
    this.onInfo,
    this.showBackButton = true,
    this.showInfoButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final rituals = [
      _RitualCardData(
        title: 'Sleep Manifestation',
        subtitle: 'Fall asleep inside your future',
        color: const Color(0xFFB3D0E7),
        icon: 'assets/img/sleep.png',
        gradient: const LinearGradient(
          colors: [Color(0xFFB3D0E7), Color(0xFF6CA8D7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      _RitualCardData(
        title: 'Morning Spark',
        subtitle: 'Fuel your vision with focus and energy.',
        color: const Color(0xFFFFD59E),
        icon: 'assets/img/spark.png',
        gradient: const LinearGradient(
          colors: [Color(0xFFE68E6A), Color(0xFFFFB347)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _RitualCardData(
        title: 'Calming Reset',
        subtitle: 'Return to calm. Reconnect with clarity',
        color: const Color(0xFFF7B2B7),
        icon: 'assets/img/calming.png',
        gradient: const LinearGradient(
          colors: [Color(0xFFF7B2B7), Color(0xFFEA5C8B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      _RitualCardData(
        title: 'Dream Visualizer',
        subtitle: 'Drop into the life you’re building.',
        color: const Color(0xFFC2B6F7),
        icon: 'assets/img/spark.png',
        gradient: const LinearGradient(
          colors: [Color(0xFFC2B6F7), Color(0xFF7C6AE6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Select the perfect meditation\nexperience for this moment',
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFFF2EFEA),
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...rituals.map(
          (ritual) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _RitualCard(
              ritual: ritual,
              onTap: () {
                // TODO: handle ritual selection
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _RitualCardData {
  final String title;
  final String subtitle;
  final Color color;
  final String icon; // Changed from IconData to String for image path
  final LinearGradient? gradient;

  _RitualCardData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.gradient,
  });
}

class _RitualCard extends StatelessWidget {
  final _RitualCardData ritual;
  final VoidCallback onTap;

  const _RitualCard({required this.ritual, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 80, // Figma dizaynga mos
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: ritual.gradient,
          ),
          child: Row(
            children: [
              Image.asset(
                ritual.icon,
                width: 32,
                height: 32,
                color: Colors.white,
              ),
              const SizedBox(width: 18),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ritual.title,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ritual.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
