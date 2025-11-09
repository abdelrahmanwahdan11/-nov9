import 'package:equatable/equatable.dart';

enum EventCategory { politics, arts, world }

class Event extends Equatable {
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.imageUrl,
    required this.summary,
    required this.details,
    required this.source,
    this.location,
    required this.tags,
  });

  final String id;
  final String title;
  final EventCategory category;
  final DateTime date;
  final String imageUrl;
  final String summary;
  final String details;
  final String source;
  final String? location;
  final List<String> tags;

  Event copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? date,
    String? imageUrl,
    String? summary,
    String? details,
    String? source,
    String? location,
    List<String>? tags,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      summary: summary ?? this.summary,
      details: details ?? this.details,
      source: source ?? this.source,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category.name,
        'date': date.toIso8601String(),
        'imageUrl': imageUrl,
        'summary': summary,
        'details': details,
        'source': source,
        'location': location,
        'tags': tags,
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      category: EventCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => EventCategory.politics,
      ),
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String,
      summary: json['summary'] as String,
      details: json['details'] as String,
      source: json['source'] as String,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  List<Object?> get props => [id, title, category, date, imageUrl, summary, details, source, location, tags];
}
