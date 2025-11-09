import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  const Offer({
    required this.itemId,
    required this.amount,
    required this.from,
    this.message,
    required this.time,
  });

  final String itemId;
  final double amount;
  final String from;
  final String? message;
  final DateTime time;

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'amount': amount,
        'from': from,
        'message': message,
        'time': time.toIso8601String(),
      };

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      itemId: json['itemId'] as String,
      amount: (json['amount'] as num).toDouble(),
      from: json['from'] as String,
      message: json['message'] as String?,
      time: DateTime.parse(json['time'] as String),
    );
  }

  @override
  List<Object?> get props => [itemId, amount, from, message, time];
}
