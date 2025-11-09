import 'package:equatable/equatable.dart';

enum ScenarioFocus { politics, arts, world, collection, hybrid }

enum ScenarioRisk { low, medium, high }

enum ScenarioType { accelerate, stabilize, diversify }

class ScenarioAction extends Equatable {
  const ScenarioAction(this.key, [this.args = const <String, String>{}]);

  final String key;
  final Map<String, String> args;

  @override
  List<Object?> get props => [key, args];
}

class ScenarioPlan extends Equatable {
  const ScenarioPlan({
    required this.id,
    required this.type,
    required this.focus,
    required this.risk,
    required this.confidence,
    required this.drivers,
    required this.watchlist,
    required this.actions,
  });

  final String id;
  final ScenarioType type;
  final ScenarioFocus focus;
  final ScenarioRisk risk;
  final double confidence;
  final List<String> drivers;
  final List<String> watchlist;
  final List<ScenarioAction> actions;

  @override
  List<Object?> get props => [id, type, focus, risk, confidence, drivers, watchlist, actions];

  ScenarioPlan copyWith({
    String? id,
    ScenarioType? type,
    ScenarioFocus? focus,
    ScenarioRisk? risk,
    double? confidence,
    List<String>? drivers,
    List<String>? watchlist,
    List<ScenarioAction>? actions,
  }) {
    return ScenarioPlan(
      id: id ?? this.id,
      type: type ?? this.type,
      focus: focus ?? this.focus,
      risk: risk ?? this.risk,
      confidence: confidence ?? this.confidence,
      drivers: drivers ?? this.drivers,
      watchlist: watchlist ?? this.watchlist,
      actions: actions ?? this.actions,
    );
  }
}
