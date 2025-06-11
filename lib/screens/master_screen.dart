import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../repositories/event_repository.dart';
import 'master_details.dart';

enum SortType { dateAsc, dateDesc, title, category }

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final EventRepository eventRepository = EventRepository();
  late Future<List<Event>> eventsFuture;
  SortType currentSort = SortType.title;

  @override
  void initState() {
    super.initState();
    eventsFuture = _fetchSortedEvents();
  }

  Future<List<Event>> _fetchSortedEvents() async {
    List<Event> events = await eventRepository.fetchEvents();
    switch (currentSort) {
      case SortType.dateAsc:
        events.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case SortType.dateDesc:
        events.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case SortType.title:
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.category:
        events.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
    return events;
  }

  void _onSortChanged(SortType sortType) {
    setState(() {
      currentSort = sortType;
      eventsFuture = _fetchSortedEvents();
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
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            onSelected: _onSortChanged,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: SortType.dateAsc,
                    child: Text('Date ascendante'),
                  ),
                  const PopupMenuItem(
                    value: SortType.dateDesc,
                    child: Text('Date descendante'),
                  ),
                  const PopupMenuItem(
                    value: SortType.title,
                    child: Text('Titre (A-Z)'),
                  ),
                  const PopupMenuItem(
                    value: SortType.category,
                    child: Text('Catégorie (A-Z)'),
                  ),
                ],
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
