import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/stores/auth_store.dart';

String capitalizeEachWord(String text) {
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        final user = authStore.user;
        final firstName = user?.firstName ?? 'User';
        final lastName = user?.lastName ?? '';
        final fullName = lastName.isNotEmpty
            ? '$firstName $lastName'
            : firstName;

        return Column(
          children: [
            // Profile picture
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: authStore.user?.avatar != null && authStore.user!.avatar!.isNotEmpty
                        ? Image.network(
                            authStore.user!.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white.withValues(alpha: 0.2),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.white.withValues(alpha: 0.2),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                // Camera icon with loading state
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: authStore.isLoading ? null : () => _pickImage(context, authStore),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF152B56),
                        shape: BoxShape.circle,
                      ),
                      child: authStore.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              capitalizeEachWord(fullName),
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.sp,
                fontWeight: FontWeight.w300,
                fontFamily: 'Canela',
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to pick image from gallery
  Future<void> _pickImage(BuildContext context, AuthStore authStore) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        // Read the image as bytes for proper form data handling
        final bytes = await image.readAsBytes();
        
        // Update profile with selected image
        await authStore.updateProfile(
          firstName: authStore.user?.firstName ?? '',
          lastName: authStore.user?.lastName ?? '',
          avatar: image.path,
          avatarBytes: bytes,
          onSuccess: () {
            // Show success message
            Fluttertoast.showToast(
              msg: 'Profile updated successfully!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: const Color.fromARGB(255, 59, 110, 170),
              textColor: Colors.white,
            );
          },
        );
      }
    } catch (e) {
      // Show error message with better handling for MissingPluginException
      String errorMessage = 'Failed to update profile';
      
      if (e.toString().contains('MissingPluginException')) {
        errorMessage = 'Image picker is not available on this platform. Please try again or restart the app.';
      } else if (e.toString().contains('Permission denied')) {
        errorMessage = 'Permission denied. Please allow access to photo library in settings.';
      } else {
        errorMessage = 'Failed to update profile: ${e.toString()}';
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
} 