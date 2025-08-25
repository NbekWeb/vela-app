import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Like store for handling meditation like/unlike functionality
class LikeStore extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final Set<String> _likedMeditationIds = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<String> get likedMeditationIds => _likedMeditationIds;

  // Check if a meditation is liked
  bool isLiked(String meditationId) {
    return _likedMeditationIds.contains(meditationId);
  }

  // Actions
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Add meditation to liked set
  void addLikedMeditation(String meditationId) {
    _likedMeditationIds.add(meditationId);
    notifyListeners();
  }

  // Remove meditation from liked set
  void removeLikedMeditation(String meditationId) {
    _likedMeditationIds.remove(meditationId);
    notifyListeners();
  }

  // Like meditation API call
  Future<void> likeMeditation(String meditationId) async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/like-meditation/$meditationId/',
        method: 'GET',
      );

      if (response.statusCode == 200) {
        addLikedMeditation(meditationId);
      }
    } catch (e) {
      setError('Failed to like meditation');
      Fluttertoast.showToast(
        msg: 'Failed to like meditation',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  // Unlike meditation API call
  Future<void> unlikeMeditation(String meditationId) async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/unlike-meditation/$meditationId/',
        method: 'GET',
      );

      if (response.statusCode == 200) {
        removeLikedMeditation(meditationId);
      }
    } catch (e) {
      setError('Failed to unlike meditation');
      Fluttertoast.showToast(
        msg: 'Failed to unlike meditation',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  // Toggle like status
  Future<void> toggleLike(String meditationId) async {
    if (isLiked(meditationId)) {
      await unlikeMeditation(meditationId);
    } else {
      await likeMeditation(meditationId);
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset store
  void reset() {
    _isLoading = false;
    _error = null;
    _likedMeditationIds.clear();
    notifyListeners();
  }
}
