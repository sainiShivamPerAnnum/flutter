import 'dart:convert';

import 'package:flutter/foundation.dart';

class AmountChipsModel {
  final int order;
  final int value;
  final bool best;
  AmountChipsModel({
    @required this.order,
    @required this.value,
    @required this.best,
  });

  factory AmountChipsModel.fromMap(Map<String, dynamic> map) {
    return AmountChipsModel(
      order: map['order'] ?? 0,
      value: map['value'] ?? 0,
      best: map['best'] ?? false,
    );
  }

  factory AmountChipsModel.fromJson(String source) =>
      AmountChipsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AmountChipsModel(order: $order, value: $value, best: $best)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AmountChipsModel &&
        other.order == order &&
        other.value == value &&
        other.best == best;
  }
}
