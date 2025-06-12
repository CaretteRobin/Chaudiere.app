import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/event.dart';
import '../providers/event_provider.dart';
import '../screens/master_details.dart';
import '../screens/favorites_screen.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

enum SortType { dateAsc, dateDesc, title, category }

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  String? selectedCategory;
  SortType currentSort = SortType.title;
  String searchQuery = '';

  List<Event> _applyFiltersAndSorts(List<Event> events) {
    List<Event> filtered = List.from(events);

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((e) =>
              e.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      filtered = filtered
          .where((e) =>
              e.category.toLowerCase() == selectedCategory!.toLowerCase())
          .toList();
    }

    switch (currentSort) {
      case SortType.dateAsc:
        filtered.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case SortType.dateDesc:
        filtered.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case SortType.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.category:
        filtered.sort((a, b) => a.category.compareTo(b.category));
        break;
    }

    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = (category == 'Tous') ? null : category;
    });
  }

  void _onSortChanged(SortType sortType) {
    setState(() {
      currentSort = sortType;
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
                          selectedColor: AppTheme.purple600.withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: selectedCategory == cat ||
                                    (cat == 'Tous' && selectedCategory == null)
                                ? AppTheme.purple700
                                : Colors.black87,
                          ),
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
                    selectedColor: AppTheme.purple600.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: currentSort == sort
                          ? AppTheme.purple700
                          : Colors.black87,
                    ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final events = _applyFiltersAndSorts(eventProvider.events);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      Icon(Icons.event, size: 28, color: AppTheme.purple600),
                      SizedBox(width: 8),
                      Text(
                        'Événements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.purple900,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FavoritesScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite_border,
                            color: AppTheme.purple600),
                        label: const Text(
                          'Favoris',
                          style: TextStyle(color: AppTheme.purple600),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          themeProvider.themeMode == ThemeMode.light
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: AppTheme.purple600,
                        ),
                        onPressed: themeProvider.toggleTheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Que cherchez-vous ?',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            isDark ? const Color(0xFF373737) : AppTheme.purple50,
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => _openFilterSortSheet(context),
                    icon: Icon(
                      Icons.tune,
                      color: isDark ? Colors.white : AppTheme.purple600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Liste des événements
            Expanded(
              child: events.isEmpty
                  ? const Center(child: Text('Aucun événement trouvé'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : AppTheme.purple50,
                          elevation: 1.5,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            title: Text(
                              event.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.purple900,
                              ),
                            ),
                            subtitle: Text(
                              '${event.category} – ${event.getFormattedDate()}',
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                event.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppTheme.purple600,
                              ),
                              onPressed: () {
                                eventProvider.toggleFavorite(event);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MasterDetailsScreen(
                                    event: event,
                                  ),
                                ),
                              );
                            },
                          ),
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
