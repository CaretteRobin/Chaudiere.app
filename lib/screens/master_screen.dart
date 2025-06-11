import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../repositories/event_repository.dart';
import 'master_details.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final EventRepository eventRepository = EventRepository();
  late Future<List<Event>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = eventRepository.fetchAndSortEvents();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        eventsFuture = eventRepository.fetchAndSortEvents();
      } else {
        eventsFuture = eventRepository.searchEventsByTitle(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des événements'),
        backgroundColor: const Color.fromRGBO(79, 70, 229, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(eventRepository),
              );
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
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            if (events.isEmpty) {
              return const Center(child: Text('Aucun événement trouvé'));
            }
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

class EventSearchDelegate extends SearchDelegate {
  final EventRepository eventRepository;

  EventSearchDelegate(this.eventRepository);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventRepository.searchEventsByTitle(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final events = snapshot.data!;
          if (events.isEmpty) {
            return const Center(child: Text('Aucun événement trouvé'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text('${event.category} - ${event.startDate}'),
                onTap: () {
                  close(context, null);
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
