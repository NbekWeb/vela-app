import 'package:flutter/material.dart';
import '../../main.dart' show globalMeditationId;
import 'package:provider/provider.dart';
import '../../core/stores/meditation_store.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../generator/direct_ritual_page.dart';

class VaultRitualCard extends StatelessWidget {
  final String? name;
  final String? meditationId;
  final String? file;
  final String? imageUrl;
  final String? title;
  final String? description;
  final Function(String)? onAudioPlay;
  final bool isEmpty;
  final String emptyText;
  final VoidCallback? onGeneratePressed;
  final bool showButton;

  const VaultRitualCard({
    this.name,
    this.meditationId,
    this.file,
    this.imageUrl,
    this.title,
    this.description,
    this.onAudioPlay,
    this.isEmpty = false,
    this.emptyText = 'No meditations created',
    this.onGeneratePressed,
    this.showButton = true,
    super.key,
  });

  String _getTitleFromName(String? name) {
    if (name == null) return 'Sleep Stream';

    final firstWord = name.split(' ').first.toLowerCase();
    switch (firstWord) {
      case 'morning':
        return 'Morning Spark';
      case 'sleep':
        return 'Sleep Manifestation';
      case 'calming':
        return 'Calming Reset';
      default:
        return 'Dream Visualizer';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Agar isEmpty true bo'lsa, empty state ko'rsat
    if (isEmpty) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emptyText,
                style: TextStyle(
                  color: const Color.fromARGB(255, 242, 239, 234),
                  fontSize: 16.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determine image based on name or use network image
    String imagePath = 'assets/img/card4.png'; // default
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Use network image if provided
      imagePath = imageUrl!;
    } else if (name != null) {
      // Fallback to local images based on name
      final firstWord = name!.split(' ').first.toLowerCase();
      if (firstWord == 'morning') {
        imagePath = 'assets/img/card2.png';
      } else if (firstWord == 'sleep') {
        imagePath = 'assets/img/card.png';
      } else if (firstWord == 'calming') {
        imagePath = 'assets/img/card3.png';
      }
    }

    return GestureDetector(
      onTap: () async {
        // Save file to secure storage if provided
        if (file != null) {
          const storage = FlutterSecureStorage();
          await storage.write(key: 'file', value: file);
        }

        if (meditationId != null) {
          // Set storedRitualType based on name
          final meditationStore = Provider.of<MeditationStore>(
            context,
            listen: false,
          );
          if (name != null) {
            final firstWord = name!.split(' ').first.toLowerCase();
            String ritualType = '4'; // default

            if (firstWord == 'sleep') {
              ritualType = '1';
            } else if (firstWord == 'morning') {
              ritualType = '2';
            } else if (firstWord == 'calming') {
              ritualType = '3';
            }

            // Set the ritual type directly in the store
            meditationStore.saveRitualSettings(
              ritualType: ritualType,
              tone: meditationStore.storedTone ?? 'dreamy',
              duration: meditationStore.storedDuration ?? '5',
              planType: meditationStore.storedPlanType ?? 1,
            );
          }

          if (onAudioPlay != null) {
            onAudioPlay!(meditationId!);
          } else {
            // Use global navigation as fallback with cleared navigation stack
            globalMeditationId = meditationId;
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/dashboard',
              (route) {
                // Keep only dashboard and its sub-routes, remove auth pages
                return route.settings.name == '/dashboard' || 
                       route.settings.name == '/my-meditations' ||
                       route.settings.name == '/archive' ||
                       route.settings.name == '/vault' ||
                       route.settings.name == '/generator';
              }
            );
          }
        } else {
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imagePath,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/img/card4.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            imagePath,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x80A4C7EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? _getTitleFromName(name),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Satoshi',
                      fontSize: 16.sp,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      description ??
                          'A deeply personalized journey crafted from your unique vision and dreams',
                      style: TextStyle(
                        color: Color(0xFFF2EFEA),
                        fontSize: 12.sp,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Satoshi',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
