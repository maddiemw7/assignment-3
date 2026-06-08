import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';

class FavoritesProvider extends ChangeNotifier {

  bool isDarkMode = false;

  final cities  = sampleCities;
  final hobbies = sampleHobbies;
  final books   = sampleBooks;

  FavoritesProvider() {
    _loadAll();
  }

  void toggleCityFavorite(int cityId) {
    final city = cities.firstWhere((c) => c.id == cityId);
    city.isFavorite = !city.isFavorite;
    _saveCities();
    notifyListeners();
  }

  void toggleHobbyFavorite(int hobbyId) {
    final hobby = hobbies.firstWhere((h) => h.id == hobbyId);
    hobby.isFavorite = !hobby.isFavorite;
    _saveHobbies();
    notifyListeners();
  }

  void toggleBookFavorite(int bookId) {
    final book = books.firstWhere((b) => b.id == bookId);
    book.isFavorite = !book.isFavorite;
    _saveBooks();
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    for (final c in cities)  { c.isFavorite = false; }
    for (final h in hobbies) { h.isFavorite = false; }
    for (final b in books)   { b.isFavorite = false; }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favoriteCities');
    await prefs.remove('favoriteHobbies');
    await prefs.remove('favoriteBooks');
    notifyListeners();
  }

  void toggleDarkMode(bool value) async {
    isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    isDarkMode = prefs.getBool('isDarkMode') ?? false;

    final favCities = prefs.getStringList('favoriteCities') ?? [];
    for (final city in cities) {
      city.isFavorite = favCities.contains(city.id.toString());
    }

    final favHobbies = prefs.getStringList('favoriteHobbies') ?? [];
    for (final hobby in hobbies) {
      hobby.isFavorite = favHobbies.contains(hobby.id.toString());
    }

    final favBooks = prefs.getStringList('favoriteBooks') ?? [];
    for (final book in books) {
      book.isFavorite = favBooks.contains(book.id.toString());
    }

    notifyListeners();
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoriteCities',
      cities.where((c) => c.isFavorite).map((c) => c.id.toString()).toList(),
    );
  }

  Future<void> _saveHobbies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoriteHobbies',
      hobbies.where((h) => h.isFavorite).map((h) => h.id.toString()).toList(),
    );
  }

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoriteBooks',
      books.where((b) => b.isFavorite).map((b) => b.id.toString()).toList(),
    );
  }
}