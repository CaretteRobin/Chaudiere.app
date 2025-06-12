import 'package:intl/intl.dart';

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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      imageUrl: json['image_url'] ?? '',
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(startDate);
  }
}
