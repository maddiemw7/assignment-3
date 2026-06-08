import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorited items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<FavoritesProvider>().clearAllFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, _) {
        final favCities  = provider.cities.where((c) => c.isFavorite).toList();
        final favHobbies = provider.hobbies.where((h) => h.isFavorite).toList();
        final favBooks   = provider.books.where((b) => b.isFavorite).toList();

        final hasAny = favCities.isNotEmpty || favHobbies.isNotEmpty || favBooks.isNotEmpty;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (!hasAny)
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No favorites yet.',
                                style: TextStyle(fontSize: 16, color: Colors.grey)),
                            SizedBox(height: 4),
                            Text('Tap ♡ on any item to save it here.',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        children: [
                          if (favCities.isNotEmpty) ...[
                            const _SectionHeader(label: 'Cities', icon: Icons.location_city),
                            ...favCities.map((city) => ListTile(
                                  leading: const CircleAvatar(child: Icon(Icons.location_city)),
                                  title: Text(city.cityName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () => provider.toggleCityFavorite(city.id),
                                  ),
                                )),
                          ],

                          if (favHobbies.isNotEmpty) ...[
                            const _SectionHeader(label: 'Hobbies', icon: Icons.sports_tennis),
                            ...favHobbies.map((hobby) => ListTile(
                                  leading: Text(hobby.hobbyIcon,
                                      style: const TextStyle(fontSize: 28)),
                                  title: Text(hobby.hobbyName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () => provider.toggleHobbyFavorite(hobby.id),
                                  ),
                                )),
                          ],

                          if (favBooks.isNotEmpty) ...[
                            const _SectionHeader(label: 'Books', icon: Icons.menu_book),
                            ...favBooks.map((book) => ListTile(
                                  leading: const CircleAvatar(child: Icon(Icons.menu_book)),
                                  title: Text(book.bookTitle),
                                  subtitle: Text(book.bookAuthor),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () => provider.toggleBookFavorite(book.id),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),

                  if (hasAny) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        label: const Text('Clear All Favorites',
                            style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () => _confirmClearAll(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label.toUpperCase(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1)),
        ],
      ),
    );
  }
}