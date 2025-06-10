import 'package:flutter/material.dart';
import '../core/models/event.dart';

class MasterDetailsScreen extends StatelessWidget {
  final Event event;

  const MasterDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'événement'),
        backgroundColor: const Color.fromRGBO(79, 70, 229, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.category),
                const SizedBox(width: 8),
                Text(event.category),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 8),
                Text(event.date),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}
