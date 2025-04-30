import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favorites';

  Set<String> _favorites = {};

  FavoritesProvider() {
    _loadFromPrefs();
  }

  Set<String> get favorites => _favorites;

  void toggle(String title) {
    if (_favorites.contains(title)) {
      _favorites.remove(title);
    } else {
      _favorites.add(title);
    }
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey) ?? [];
      _favorites = list.toSet();
      notifyListeners();
    } catch (e) {
      debugPrint('★ favorites load error: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, _favorites.toList());
    } catch (e) {
      debugPrint('★ favorites save error: $e');
    }
  }
}
