import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/stores/auth_store.dart';
import '../../../shared/models/user_model.dart';

class GoalsList extends StatefulWidget {
  const GoalsList({super.key});

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  List<LifeVision> _lifeVisions = [];

  @override
  void initState() {
    super.initState();
    _loadLifeVisions();
  }

  Future<void> _loadLifeVisions() async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final lifeVisions = await authStore.getProfileDataWithLifeVisions();
    setState(() {
      _lifeVisions = lifeVisions;
    });
  }

  Future<void> _onGoalSelected(int index) async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    
    // Define hardcoded goals
    final goals = [
      'Daily meditation',
      'Authentic self',
      'Dream vision',
    ];
    
    // Determine vision type based on goal index
    String newVisionType = 'north_star';
    if (index == 0) {
      newVisionType = 'north_star';
    } else if (index == 1) {
      newVisionType = 'goal';
    } else if (index == 2) {
      newVisionType = 'dream';
    }
    
    // Update UI immediately - handle multiple selections
    if (_lifeVisions.isNotEmpty) {
      final currentVisionTypes = List<String>.from(_lifeVisions[0].visionType);
      
      // Toggle the vision type - add if not present, remove if present
      if (currentVisionTypes.contains(newVisionType)) {
        // Only allow removal if there's more than one selection
        if (currentVisionTypes.length > 1) {
          currentVisionTypes.remove(newVisionType);
        } else {
          // If this is the last selection, show warning toast
          Fluttertoast.showToast(
            msg: 'At least one goal must be selected',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
          return; // Don't update the state
        }
      } else {
        currentVisionTypes.add(newVisionType);
      }
      
      // Update UI immediately
      setState(() {
        _lifeVisions[0] = _lifeVisions[0].copyWith(visionType: currentVisionTypes);
      });
      
      // Sync with API in background
      _syncWithAPI(authStore, _lifeVisions[0].id, currentVisionTypes);
    } else {
      // If life_visions is empty, create new one
      final newVision = await authStore.createLifeVision(
        title: goals[index],
        description: 'Goal description for ${goals[index]}',
        visionType: newVisionType,
      );
      
      if (newVision != null) {
        // Reload data after POST
        await _loadLifeVisions();
      }
    }
  }
  
  // Background API sync method
  Future<void> _syncWithAPI(AuthStore authStore, int visionId, List<String> visionTypes) async {
    try {
      await authStore.updateLifeVisionType(
        visionId: visionId,
        newVisionType: visionTypes,
      );
    } catch (e) {
      // If API call fails, revert the UI state
      await _loadLifeVisions();
      Fluttertoast.showToast(
        msg: 'Failed to update goals. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
        
        // Determine if this goal is selected based on vision_type
        bool isSelected = false;
        if (_lifeVisions.isNotEmpty) {
          final vision = _lifeVisions[0]; // Get the first (and only) vision
          
          // Check if this goal's vision type is in the vision_type array
          if (index == 0 && vision.visionType.contains('north_star')) {
            isSelected = true; // First goal selected
          } else if (index == 1 && vision.visionType.contains('goal')) {
            isSelected = true; // Second goal selected
          } else if (index == 2 && vision.visionType.contains('dream')) {
            isSelected = true; // Third goal selected
          }
        }

        return GestureDetector(
          onTap: () {
            _onGoalSelected(index);
          },
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