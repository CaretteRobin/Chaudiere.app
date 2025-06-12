import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../repositories/event_repository.dart';
import '../screens/master_details.dart';
import '../theme/app_theme.dart';

enum SortType { dateAsc, dateDesc, title, category }

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final EventRepository eventRepository = EventRepository();
  late Future<List<Event>> eventsFuture;

  String? selectedCategory;
  SortType currentSort = SortType.title;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    eventsFuture = _fetchFilteredAndSortedEvents();
  }

  Future<List<Event>> _fetchFilteredAndSortedEvents() async {
    List<Event> events = await eventRepository.fetchEvents();

    // Filtrage par recherche
    if (searchQuery.isNotEmpty) {
      events = events
          .where((e) =>
              e.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Filtrage par catégorie
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      events = events
          .where((e) =>
              e.category.toLowerCase() == selectedCategory!.toLowerCase())
          .toList();
    }

    // ↕Tri
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

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      eventsFuture = _fetchFilteredAndSortedEvents();
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = (category == 'Tous') ? null : category;
      eventsFuture = _fetchFilteredAndSortedEvents();
    });
  }

  void _onSortChanged(SortType sortType) {
    setState(() {
      currentSort = sortType;
      eventsFuture = _fetchFilteredAndSortedEvents();
    });
  }

  void _openFilterSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Filtrer par catégorie',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Tous', 'Concert', 'Exposition', 'Conférence']
                    .map((cat) => ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat ||
                              (cat == 'Tous' && selectedCategory == null),
                          onSelected: (_) {
                            Navigator.pop(context);
                            _filterByCategory(cat);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Trier par',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: SortType.values.map((sort) {
                  final label = {
                    SortType.dateAsc: 'Date ↑',
                    SortType.dateDesc: 'Date ↓',
                    SortType.title: 'Titre (A-Z)',
                    SortType.category: 'Catégorie (A-Z)',
                  }[sort];
                  return ChoiceChip(
                    label: Text(label!),
                    selected: currentSort == sort,
                    onSelected: (_) {
                      Navigator.pop(context);
                      _onSortChanged(sort);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.event, size: 28, color: AppTheme.primaryPurple),
                      SizedBox(width: 8),
                      Text(
                        'Événements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Page de favoris
                    },
                    icon: const Icon(Icons.star_border,
                        color: AppTheme.primaryPurple),
                    label: const Text(
                      'Favoris',
                      style: TextStyle(color: AppTheme.primaryPurple),
                    ),
                  )
                ],
              ),
            ),

            // Search + Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Que cherchez-vous ?',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => _openFilterSortSheet(context),
                    icon: const Icon(Icons.tune,
                        color: AppTheme.primaryPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Liste des événements
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun événement trouvé'));
                  }

                  final events = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(event.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle:
                              Text('${event.category} – ${event.startDate}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MasterDetailsScreen(event: event),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
