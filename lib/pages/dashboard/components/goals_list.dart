import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsList extends StatefulWidget {
  const GoalsList({super.key});

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  int selectedGoalIndex = 0; // Default to first goal
  static const String _selectedGoalKey = 'selected_goal_index';

  @override
  void initState() {
    super.initState();
    _loadSelectedGoal();
  }

  Future<void> _loadSelectedGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_selectedGoalKey);
      if (savedIndex != null && savedIndex >= 0 && savedIndex < 3) {
        setState(() {
          selectedGoalIndex = savedIndex;
        });
      }
    } catch (e) {
      // If there's an error, keep the default value (0)
      // This can happen during hot reload or on unsupported platforms
      print('Error loading selected goal: $e');
    }
  }

  Future<void> _saveSelectedGoal(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_selectedGoalKey, index);
    } catch (e) {
      // This can happen during hot reload or on unsupported platforms
      // We'll just ignore the error and continue with the UI state
      print('Error saving selected goal: $e');
    }
  }

  void _onGoalSelected(int index) {
    setState(() {
      selectedGoalIndex = index;
    });
    _saveSelectedGoal(index);
  }

  @override
  Widget build(BuildContext context) {
    final goals = [
      'Daily meditation',
      'Authentic self',
      'Dream vision',
    ];

    return Column(
      children: goals.asMap().entries.map((entry) {
        final index = entry.key;
        final goalText = entry.value;
        final isSelected = index == selectedGoalIndex;

        return GestureDetector(
          onTap: () => _onGoalSelected(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Custom circle with selection indicator
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF3B6EAA)
                        : Colors.transparent,
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFF3B6EAA), width: 1),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Color(0xFFFFFFFF),
                          size: 12,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    goalText,
                    style: TextStyle(
                      color: const Color(0xFF3B6EAA),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Satoshi',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
} 