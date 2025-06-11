class Event {
  final String title;
  final String category;
  final String startDate;
  final String description;

  Event({
    required this.title,
    required this.category,
    required this.startDate,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startDate: json['start_date'] ?? '',
      description: json['description'] ?? '',
    );
  }
}