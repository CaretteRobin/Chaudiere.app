import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../theme/app_theme.dart';
import '../repositories/event_repository.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Event> allEvents;

  const FavoritesScreen({super.key, required this.allEvents});

  @override
  Widget build(BuildContext context) {
    final favoriteEvents = allEvents.where((e) => e.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: AppTheme.purple600,
      ),
      body: favoriteEvents.isEmpty
          ? const Center(child: Text('Aucun favori trouvé'))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favoriteEvents.length,
        itemBuilder: (context, index) {
          final event = favoriteEvents[index];
          return Card(
            color: AppTheme.purple50,
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.purple900,
                ),
              ),
              subtitle: Text(
                '${event.category} – ${event.startDate}',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}
