import 'package:equatable/equatable.dart';

enum SavedFilterKind { events, items }

class SavedFilter extends Equatable {
  const SavedFilter({
    required this.id,
    required this.name,
    required this.kind,
    required this.params,
  });

  final String id;
  final String name;
  final SavedFilterKind kind;
  final Map<String, dynamic> params;

  SavedFilter copyWith({
    String? id,
    String? name,
    SavedFilterKind? kind,
    Map<String, dynamic>? params,
  }) {
    return SavedFilter(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      params: params ?? this.params,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'params': params,
      };

  factory SavedFilter.fromJson(Map<String, dynamic> json) {
    final rawParams = json['params'];
    return SavedFilter(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: SavedFilterKind.values.firstWhere(
        (value) => value.name == json['kind'],
        orElse: () => SavedFilterKind.events,
      ),
      params: rawParams is Map<String, dynamic>
          ? rawParams
          : (rawParams as Map).map(
              (key, value) => MapEntry(key as String, value),
            ),
    );
  }

  @override
  List<Object?> get props => [id, name, kind, params];
}
