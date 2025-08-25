import 'package:flutter/material.dart';
import '../../styles/pages/plan_page_styles.dart';

class PlanInfoCard extends StatelessWidget {
  const PlanInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PlanPageStyles.cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              color: PlanPageStyles.leftBorder,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineRow(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Share your goals', style: PlanPageStyles.cardTitle),
                    const SizedBox(height: 8),
                    Text(
                      'We will set up your profile based on your answers to generate your customized manifesting meditation experience, grounded in neuroscience, and tailored to you.',
                      style: PlanPageStyles.cardBody,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TimelineRow(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today', style: PlanPageStyles.cardSection),
                    Text(
                      'Generate and save your tailored meditations, built for your dream life.',
                      style: PlanPageStyles.cardBody,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TimelineRow(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('In 3 days', style: PlanPageStyles.cardSection),
                    Text(
                      "You'll be charged, cancel anytime before.",
                      style: PlanPageStyles.cardBody,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimelineRow extends StatelessWidget {
  final Widget child;
  const TimelineRow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 12, top: 0),
          decoration: BoxDecoration(
            color: PlanPageStyles.leftBorder,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
} 