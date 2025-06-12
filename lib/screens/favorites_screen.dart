import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/event.dart';
import '../screens/master_details.dart';
import '../theme/app_theme.dart';
import '../providers/event_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteEvents = context.watch<EventProvider>().favorites;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Retour + Titre Favoris 
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
                      const Icon(Icons.favorite, color: AppTheme.purple600),
                    ],
                  )
                ],
              ),
            ),

            // Aucun favori
            if (favoriteEvents.isEmpty)
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
              _buildCard(context, favoriteEvents.first, isDark),

              // Les autres
              if (favoriteEvents.length > 1) ...[
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
                    itemCount: favoriteEvents.length - 1,
                    itemBuilder: (context, index) {
                      final event = favoriteEvents[index + 1];
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
    final eventProvider = context.read<EventProvider>();

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
            eventProvider.isFavorite(event)
                ? Icons.favorite
                : Icons.favorite_border,
            color: AppTheme.purple600,
          ),
          onPressed: () => eventProvider.toggleFavorite(event),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MasterDetailsScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}
