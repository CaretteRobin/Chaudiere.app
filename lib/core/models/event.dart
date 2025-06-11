class Event {
  final String title;
  final String category;
  final String startDate;

  Event({
    required this.title,
    required this.category,
    required this.startDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startDate: json['start_date'] ?? '',
    );
  }
}