import 'package:equatable/equatable.dart';

import 'offer.dart';

enum ItemCondition { new_, like_new, used, needs_fix }

class Item extends Equatable {
  const Item({
    required this.id,
    required this.name,
    required this.specs,
    required this.imageUrl,
    required this.condition,
    this.notes,
    required this.forSale,
    this.askingPrice,
    required this.offers,
  });

  final String id;
  final String name;
  final Map<String, String> specs;
  final String imageUrl;
  final ItemCondition condition;
  final String? notes;
  final bool forSale;
  final double? askingPrice;
  final List<Offer> offers;

  Item copyWith({
    String? id,
    String? name,
    Map<String, String>? specs,
    String? imageUrl,
    ItemCondition? condition,
    String? notes,
    bool? forSale,
    double? askingPrice,
    List<Offer>? offers,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      specs: specs ?? this.specs,
      imageUrl: imageUrl ?? this.imageUrl,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      forSale: forSale ?? this.forSale,
      askingPrice: askingPrice ?? this.askingPrice,
      offers: offers ?? this.offers,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specs': specs,
        'imageUrl': imageUrl,
        'condition': condition.name,
        'notes': notes,
        'forSale': forSale,
        'askingPrice': askingPrice,
        'offers': offers.map((offer) => offer.toJson()).toList(),
      };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      specs: (json['specs'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
      imageUrl: json['imageUrl'] as String,
      condition: ItemCondition.values.firstWhere(
        (c) => c.name == json['condition'],
        orElse: () => ItemCondition.used,
      ),
      notes: json['notes'] as String?,
      forSale: json['forSale'] as bool,
      askingPrice: (json['askingPrice'] as num?)?.toDouble(),
      offers: (json['offers'] as List<dynamic>)
          .map((offer) => Offer.fromJson(offer as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, specs, imageUrl, condition, notes, forSale, askingPrice, offers];
}
