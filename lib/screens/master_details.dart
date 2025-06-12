import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../theme/app_theme.dart';

class MasterDetailsScreen extends StatelessWidget {
  final Event event;

  const MasterDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🖼️ Image bannière sans bord arrondi
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

          // 🧾 Infos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ Titre
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.purple900,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📅 Date
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          color: Colors.black87),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.startDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 🏷️ Catégorie
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                  // ❤️ Bouton "Ajouter aux favoris"
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
                        // TODO: Ajouter à favoris
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text(
                        'Ajouter aux favoris',
                        style: TextStyle(fontSize: 16),
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
