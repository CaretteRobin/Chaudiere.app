import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/event.dart';
import '../database/database_helper.dart';

class EventRepository {
  final String apiUrl = 'http://localhost:8080/api/evenements';
  final DatabaseHelper dbHelper = DatabaseHelper();

  /// Synchronise une seule fois les données de l’API vers SQLite
  Future<void> syncWithApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Event> events = data.map((json) => Event.fromJson(json)).toList();

        for (final event in events) {
          await dbHelper.insertEvent(event); // insertion protégée
        }
      }
    } catch (_) {
      // Silent fail : en cas d'erreur, on reste sur la base locale
    }
  }

  /// Récupère tous les événements triés par titre
  Future<List<Event>> fetchAndSortEvents() async {
    final events = await dbHelper.fetchEvents();
    events.sort((a, b) => a.title.compareTo(b.title));
    return events;
  }

  /// 🔍 Recherche locale dans les titres
  Future<List<Event>> searchEventsByTitle(String query) async {
    final events = await dbHelper.fetchEvents();
    return events
        .where((event) =>
            event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Met à jour un favori
  Future<void> updateFavorite(Event event) async {
    await dbHelper.updateEvent(event);
  }

  /// Récupère uniquement les favoris
  Future<List<Event>> getFavorites() async {
    final events = await dbHelper.fetchEvents();
    return events.where((e) => e.isFavorite).toList();
  }
}
