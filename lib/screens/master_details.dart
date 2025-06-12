import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../theme/app_theme.dart';

class MasterDetailsScreen extends StatefulWidget {
  final Event event;
  final void Function(Event event) onToggleFavorite;

  const MasterDetailsScreen({
    super.key,
    required this.event,
    required this.onToggleFavorite,
  });

  @override
  State<MasterDetailsScreen> createState() => _MasterDetailsScreenState();
}

class _MasterDetailsScreenState extends State<MasterDetailsScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.event.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    widget.event.isFavorite = isFavorite;
    widget.onToggleFavorite(widget.event);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Image dynamique
          Stack(
            children: [
              Image.network(
                event.imageUrl.isNotEmpty
                    ? event.imageUrl
                    : 'https://via.placeholder.com/800x400.png?text=La+Chaudiere',
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),

          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.purple900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined,
                          color: isDark ? Colors.white70 : Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.getFormattedDate(),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.sell_outlined,
                          color: isDark ? Colors.white70 : Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.category,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Bouton favoris
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: AppTheme.purple600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        isFavorite
                            ? 'Retirer des favoris'
                            : 'Ajouter aux favoris',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
