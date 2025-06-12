import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/event.dart';

class EventRepository {
  final String apiUrl = 'http://localhost:8080/api/evenements';

  // Récupère les événements depuis l'API
  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erreur lors du chargement des événements : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Trie les événements par titre (A-Z)
  Future<List<Event>> fetchAndSortEvents() async {
    List<Event> events = await fetchEvents();
    events.sort((a, b) => a.title.compareTo(b.title));
    return events;
  }

  // Recherche les événements par titre
  Future<List<Event>> searchEventsByTitle(String query) async {
    List<Event> events = await fetchEvents();
    return events
        .where(
          (event) => event.title.toLowerCase().contains(query.toLowerCase()),
    )
        .toList();
  }
}
