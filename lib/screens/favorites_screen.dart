import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../screens/master_details.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Event> allEvents;
  final void Function(Event event) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.allEvents,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Event> favorites = [];

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      favorites = widget.allEvents.where((e) => e.isFavorite).toList();
    });
  }

  void _handleToggleFavorite(Event event) {
    widget.onToggleFavorite(event);
    _refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Retour + Titre "Favoris "
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: isDark ? Colors.white : Colors.black,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    children: [
                      Text(
                        'Favoris',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.purple900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.favorite, color: AppTheme.purple600),
                    ],
                  )
                ],
              ),
            ),

            // Si aucun favori
            if (favorites.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Ajoutez des favoris pour retrouver vos événements préférés ici !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ),
                ),
              )
            else ...[
              // Mon dernier favori
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Mon dernier favori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.purple700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(context, favorites.first, isDark),

              // Les autres
              if (favorites.length > 1) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Mes favoris',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : AppTheme.purple700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: favorites.length - 1,
                    itemBuilder: (context, index) {
                      final event = favorites[index + 1];
                      return _buildCard(context, event, isDark);
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Event event, bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF2A2A2A) : AppTheme.purple50,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: event.imageUrl.isNotEmpty
              ? Image.network(
                  event.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/chaudiere_banner.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(
          event.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : AppTheme.purple900,
          ),
        ),
        subtitle: Text(
          '${event.category} – ${event.getFormattedDate()}',
          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        ),
        trailing: IconButton(
          icon: Icon(
            event.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppTheme.purple600,
          ),
          onPressed: () => _handleToggleFavorite(event),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MasterDetailsScreen(
                event: event,
                onToggleFavorite: _handleToggleFavorite,
              ),
            ),
          );
        },
      ),
    );
  }
}
