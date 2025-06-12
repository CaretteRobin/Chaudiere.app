import 'package:flutter/material.dart';
import '../core/models/event.dart';
import '../database/database_helper.dart';
import '../repositories/event_repository.dart';

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final EventRepository _repository = EventRepository();

  bool _hasLoaded = false;

  List<Event> get events => List.unmodifiable(_events);
  List<Event> get favorites =>
      _events.where((event) => event.isFavorite).toList();

  /// Chargement initial des événements
  Future<void> loadEvents() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    await _repository.syncWithApi();
    _events.clear();
    _events.addAll(await _dbHelper.fetchEvents());
    notifyListeners();
  }

  /// Toggle favori
  Future<void> toggleFavorite(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index == -1) return;

    _events[index].isFavorite = !_events[index].isFavorite;
    await _dbHelper.updateEvent(_events[index]);
    notifyListeners();
  }

  /// Mise à jour locale d’un événement
  Future<void> updateEvent(Event updated) async {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _events[index] = updated;
    await _dbHelper.updateEvent(updated);
    notifyListeners();
  }

  /// Vérifie si favori
  bool isFavorite(Event event) {
    return _events.any((e) => e.id == event.id && e.isFavorite);
  }

  /// Réinitialise la base + mémoire
  Future<void> resetDatabase() async {
    await _dbHelper.clearAll();
    _events.clear();
    _hasLoaded = false;
    notifyListeners();
  }
}
