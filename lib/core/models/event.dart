class Event {
  final String title;
  final String category;
  final String date;
  final String description;

  Event({
    required this.title,
    required this.category,
    required this.date,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
