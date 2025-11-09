import 'package:flutter/foundation.dart';

enum StrategyFocus { politics, arts, world, inventory, timeline, global }

extension StrategyFocusX on StrategyFocus {
  String get localizationKey {
    switch (this) {
      case StrategyFocus.politics:
        return 'notebook_focus_politics';
      case StrategyFocus.arts:
        return 'notebook_focus_arts';
      case StrategyFocus.world:
        return 'notebook_focus_world';
      case StrategyFocus.inventory:
        return 'notebook_focus_inventory';
      case StrategyFocus.timeline:
        return 'notebook_focus_timeline';
      case StrategyFocus.global:
        return 'notebook_focus_global';
    }
  }
}

@immutable
class StrategyNote {
  const StrategyNote({
    required this.id,
    required this.title,
    required this.summary,
    required this.details,
    required this.focus,
    required this.confidence,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String details;
  final StrategyFocus focus;
  final double confidence;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DateTime get effectiveDate => updatedAt ?? createdAt;

  StrategyNote copyWith({
    String? id,
    String? title,
    String? summary,
    String? details,
    StrategyFocus? focus,
    double? confidence,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StrategyNote(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      details: details ?? this.details,
      focus: focus ?? this.focus,
      confidence: confidence ?? this.confidence,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'details': details,
      'focus': focus.name,
      'confidence': confidence,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory StrategyNote.fromJson(Map<String, dynamic> json) {
    return StrategyNote(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      details: json['details'] as String,
      focus: StrategyFocus.values.firstWhere(
        (focus) => focus.name == json['focus'],
        orElse: () => StrategyFocus.global,
      ),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((tag) => tag.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String? ?? '')
          : null,
    );
  }
}
