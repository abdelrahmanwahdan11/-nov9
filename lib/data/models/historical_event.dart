import 'package:equatable/equatable.dart';

enum HistoricalEventType {
  political,
  artistic,
  geographic,
  naturalDisaster,
  holiday,
  social,
  scientific,
  economic,
  cultural,
}

class HistoricalEvent extends Equatable {
  const HistoricalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.country,
    required this.type,
    required this.date,
    required this.imageUrl,
    required this.highlights,
    required this.source,
    required this.tags,
  });

  final String id;
  final String title;
  final String description;
  final String country;
  final HistoricalEventType type;
  final DateTime date;
  final String imageUrl;
  final List<String> highlights;
  final String source;
  final List<String> tags;

  HistoricalEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? country,
    HistoricalEventType? type,
    DateTime? date,
    String? imageUrl,
    List<String>? highlights,
    String? source,
    List<String>? tags,
  }) {
    return HistoricalEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      country: country ?? this.country,
      type: type ?? this.type,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      highlights: highlights ?? this.highlights,
      source: source ?? this.source,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        country,
        type,
        date,
        imageUrl,
        highlights,
        source,
        tags,
      ];
}
