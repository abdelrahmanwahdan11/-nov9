import 'package:equatable/equatable.dart';

enum RiskCategory {
  political,
  economic,
  cultural,
  security,
  supply,
  climate,
  social,
}

extension RiskCategoryX on RiskCategory {
  String get key {
    switch (this) {
      case RiskCategory.political:
        return 'risk_category_political';
      case RiskCategory.economic:
        return 'risk_category_economic';
      case RiskCategory.cultural:
        return 'risk_category_cultural';
      case RiskCategory.security:
        return 'risk_category_security';
      case RiskCategory.supply:
        return 'risk_category_supply';
      case RiskCategory.climate:
        return 'risk_category_climate';
      case RiskCategory.social:
        return 'risk_category_social';
    }
  }
}

class RiskSignal extends Equatable {
  const RiskSignal({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.severity,
    required this.recommendation,
    required this.timeframe,
    this.relatedEvents = const [],
    this.relatedItems = const [],
    this.tags = const [],
  });

  final String id;
  final RiskCategory category;
  final String title;
  final String summary;
  final double severity;
  final String recommendation;
  final String timeframe;
  final List<String> relatedEvents;
  final List<String> relatedItems;
  final List<String> tags;

  RiskSignal copyWith({
    String? id,
    RiskCategory? category,
    String? title,
    String? summary,
    double? severity,
    String? recommendation,
    String? timeframe,
    List<String>? relatedEvents,
    List<String>? relatedItems,
    List<String>? tags,
  }) {
    return RiskSignal(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      severity: severity ?? this.severity,
      recommendation: recommendation ?? this.recommendation,
      timeframe: timeframe ?? this.timeframe,
      relatedEvents: relatedEvents ?? this.relatedEvents,
      relatedItems: relatedItems ?? this.relatedItems,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name,
      'title': title,
      'summary': summary,
      'severity': severity,
      'recommendation': recommendation,
      'timeframe': timeframe,
      'relatedEvents': relatedEvents,
      'relatedItems': relatedItems,
      'tags': tags,
    };
  }

  static RiskSignal fromMap(Map<String, dynamic> map) {
    return RiskSignal(
      id: map['id'] as String,
      category: RiskCategory.values.firstWhere(
        (value) => value.name == map['category'],
        orElse: () => RiskCategory.political,
      ),
      title: map['title'] as String,
      summary: map['summary'] as String,
      severity: (map['severity'] as num).toDouble(),
      recommendation: map['recommendation'] as String,
      timeframe: map['timeframe'] as String,
      relatedEvents: List<String>.from(map['relatedEvents'] as List? ?? const []),
      relatedItems: List<String>.from(map['relatedItems'] as List? ?? const []),
      tags: List<String>.from(map['tags'] as List? ?? const []),
    );
  }

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        summary,
        severity,
        recommendation,
        timeframe,
        relatedEvents,
        relatedItems,
        tags,
      ];
}

class RiskMomentumPoint extends Equatable {
  const RiskMomentumPoint({required this.date, required this.severity, required this.category});

  final DateTime date;
  final double severity;
  final RiskCategory category;

  @override
  List<Object?> get props => [date, severity, category];
}

class RiskOutlook extends Equatable {
  const RiskOutlook({
    required this.signals,
    required this.heatMap,
    required this.averageSeverity,
    required this.watchlist,
    required this.momentum,
  });

  final List<RiskSignal> signals;
  final Map<RiskCategory, double> heatMap;
  final double averageSeverity;
  final List<RiskSignal> watchlist;
  final List<RiskMomentumPoint> momentum;

  @override
  List<Object?> get props => [signals, heatMap, averageSeverity, watchlist, momentum];
}
