import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../repositories/event_repository.dart';
import 'master_details.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventRepository eventRepository = EventRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des événements'),
        backgroundColor: const Color.fromRGBO(79, 70, 229, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action pour la loupe
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Action pour le bouton de filtre
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: eventRepository.fetchAndSortEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text('${event.category} - ${event.startDate}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MasterDetailsScreen(event: event),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Aucun événement trouvé'));
          }
        },
      ),
    );
  }
}