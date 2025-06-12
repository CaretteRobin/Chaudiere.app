import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../theme/app_theme.dart';

class MasterDetailsScreen extends StatelessWidget {
  final Event event;

  const MasterDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'événement'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ Titre
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkPurple,
                    ),
              ),
              const SizedBox(height: 24),

              // 📅 Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    event.startDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🗂️ Catégorie
              Row(
                children: [
                  const Icon(Icons.category_outlined, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    event.category,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Placeholder pour donner du corps à la page
              const Text(
                'Plus d\'informations à venir...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}