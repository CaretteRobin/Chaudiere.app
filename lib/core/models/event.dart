import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class Event {
  final String id;
  final String title;
  final String category;
  final DateTime startDate;
  final String imageUrl;
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    required this.imageUrl,
    this.isFavorite = false,
  });

  /// Création depuis JSON (API)
  factory Event.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return Event(
      id: (rawId != null && rawId.toString().trim().isNotEmpty)
          ? rawId.toString()
          : _uuid.v4(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      imageUrl: json['image_url'] ?? '',
      isFavorite: false, 
    );
  }

  /// Pour l’API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'start_date': startDate.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  /// Pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'start_date': startDate.toIso8601String(),
      'image_url': imageUrl,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  /// Depuis SQLite
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? _uuid.v4(),
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      startDate: DateTime.parse(map['start_date']),
      imageUrl: map['image_url'] ?? '',
      isFavorite: (map['is_favorite'] ?? 0) == 1,
    );
  }

  /// Format affichable
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(startDate);
  }
}
