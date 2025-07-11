import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../utils/constants.dart';

// Mock storage service - in a real app, this would use SharedPreferences or secure storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Mock storage
  final Map<String, dynamic> _storage = {};

  // User token operations
  Future<void> saveUserToken(String token) async {
    _storage[AppConstants.userTokenKey] = token;
    if (kDebugMode) {
      print('Token saved: $token');
    }
  }

  Future<String?> getUserToken() async {
    return _storage[AppConstants.userTokenKey] as String?;
  }

  Future<void> removeUserToken() async {
    _storage.remove(AppConstants.userTokenKey);
  }

  // User data operations
  Future<void> saveUserData(User user) async {
    _storage[AppConstants.userDataKey] = jsonEncode(user.toJson());
  }

  Future<User?> getUserData() async {
    final userData = _storage[AppConstants.userDataKey] as String?;
    if (userData != null) {
      try {
        final json = jsonDecode(userData) as Map<String, dynamic>;
        return User.fromJson(json);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing user data: $e');
        }
        return null;
      }
    }
    return null;
  }

  Future<void> removeUserData() async {
    _storage.remove(AppConstants.userDataKey);
  }

  // Favorite recipes operations
  Future<void> saveFavoriteRecipes(List<Recipe> recipes) async {
    final recipesJson = recipes.map((recipe) => recipe.toJson()).toList();
    _storage[AppConstants.favoritesKey] = jsonEncode(recipesJson);
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final favoritesData = _storage[AppConstants.favoritesKey] as String?;
    if (favoritesData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(favoritesData);
        return jsonList
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing favorite recipes: $e');
        }
        return [];
      }
    }
    return [];
  }

  // App settings operations
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    _storage[AppConstants.settingsKey] = jsonEncode(settings);
  }

  Future<Map<String, dynamic>> getSettings() async {
    final settingsData = _storage[AppConstants.settingsKey] as String?;
    if (settingsData != null) {
      try {
        return jsonDecode(settingsData) as Map<String, dynamic>;
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing settings: $e');
        }
        return {};
      }
    }
    return {};
  }

  // Generic storage operations
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      _storage[key] = value;
    } else {
      _storage[key] = jsonEncode(value);
    }
  }

  Future<T?> getData<T>(String key) async {
    final data = _storage[key];
    if (data == null) return null;

    if (T == String) {
      return data as T?;
    } else {
      try {
        return jsonDecode(data as String) as T?;
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing data for key $key: $e');
        }
        return null;
      }
    }
  }

  Future<void> removeData(String key) async {
    _storage.remove(key);
  }

  Future<void> clearAll() async {
    _storage.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getUserToken();
    return token != null && token.isNotEmpty;
  }

  // Get all stored keys (for debugging)
  List<String> getAllKeys() {
    return _storage.keys.toList();
  }

  // Get storage size (for debugging)
  int getStorageSize() {
    return _storage.length;
  }
}