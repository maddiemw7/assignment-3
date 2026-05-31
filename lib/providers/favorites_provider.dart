import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';

class FavoritesProvider extends ChangeNotifier {

  bool isDarkMode = false;

  final cities = sampleCities;
  final hobbies = sampleHobbies;

  FavoritesProvider() {
    loadFavorites();
  }

  void toggleHobbyFavorite(int hobbyId) {
    final hobby = hobbies.firstWhere(
      (hobby) => hobby.id == hobbyId,
    );
    hobby.isFavorite = !hobby.isFavorite;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  void toggleCityFavorite(int cityId) {
    final city = cities.firstWhere(
      (city) => city.id == cityId,
    );

    city.isFavorite = !city.isFavorite;

    saveFavorites();

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteIds = cities
        .where((city) => city.isFavorite)
        .map((city) => city.id.toString())
        .toList();

    await prefs.setStringList(
      'favoriteCities',
      favoriteIds,
    );
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteIds = prefs.getStringList('favoriteCities') ?? [];

    for (final city in cities) {
      city.isFavorite = favoriteIds.contains(city.id.toString());
    }

    notifyListeners();
  }
}