import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/event.dart';

class EventRepository {
  final String apiUrl = 'http://localhost:8080/api/evenements';
  // Récupère les événements depuis l'API
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des événements');
    }
  }

  // Récupère et trie les événements par titre
  Future<List<Event>> fetchAndSortEvents() async {
    List<Event> events = await fetchEvents();
    events.sort((a, b) => a.title.compareTo(b.title)); // Tri par titre
    return events;
  }
}