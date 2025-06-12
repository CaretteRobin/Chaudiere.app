import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String category;
  final DateTime startDate; // Changement de type
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    this.isFavorite = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'startDate': startDate.toIso8601String(),
    };
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(startDate);
  }
}