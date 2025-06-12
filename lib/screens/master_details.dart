import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../theme/app_theme.dart';

class MasterDetailsScreen extends StatelessWidget {
  final Event event;
  final void Function(Event event) onToggleFavorite;

  const MasterDetailsScreen({
    super.key,
    required this.event,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/chaudiere_banner.png',
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.purple900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          color: Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.getFormattedDate(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.sell_outlined, color: Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                      onPressed: () {
                        onToggleFavorite(event);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              event.isFavorite
                                  ? 'Événement ajouté aux favoris'
                                  : 'Événement retiré des favoris',
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppTheme.purple600,
                          ),
                        );
                      },
                      icon: Icon(
                        event.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        event.isFavorite
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