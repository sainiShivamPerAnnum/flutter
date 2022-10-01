import 'dart:convert';

import 'package:flutter/foundation.dart';

class LendboxWithdrawableQuantity {
  final double amount;
  final double lockedAmount;
  final String lockedMessage;

  LendboxWithdrawableQuantity({
    @required this.amount,
    @required this.lockedAmount,
    @required this.lockedMessage,
  });

  LendboxWithdrawableQuantity copyWith({
    double amount,
    double lockedAmount,
    String lockedMessage,
  }) {
    return LendboxWithdrawableQuantity(
      amount: amount ?? this.amount,
      lockedAmount: lockedAmount ?? this.lockedAmount,
      lockedMessage: lockedMessage ?? this.lockedMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'lockedAmount': lockedAmount,
      'lockedMessage': lockedMessage,
    };
  }

  factory LendboxWithdrawableQuantity.fromMap(Map<String, dynamic> map) {
    return LendboxWithdrawableQuantity(
      amount: map['amount']?.toDouble() ?? 0.0,
      lockedAmount: map['lockedAmount']?.toDouble() ?? 0.0,
      lockedMessage: map['lockedMessage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LendboxWithdrawableQuantity.fromJson(String source) =>
      LendboxWithdrawableQuantity.fromMap(json.decode(source));

  @override
  String toString() =>
      'LendboxWithdrawableQuantity(amount: $amount, lockedAmount: $lockedAmount, lockedMessage: $lockedMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LendboxWithdrawableQuantity &&
        other.amount == amount &&
        other.lockedAmount == lockedAmount &&
        other.lockedMessage == lockedMessage;
  }

  @override
  int get hashCode =>
      amount.hashCode ^ lockedAmount.hashCode ^ lockedMessage.hashCode;
}
