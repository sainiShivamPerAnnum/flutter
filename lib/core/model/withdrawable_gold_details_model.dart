// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class WithdrawableGoldResponseModel {
  String message;
  WithdrawableGoldDetails data;
  WithdrawableGoldResponseModel({
    @required this.message,
    @required this.data,
  });

  WithdrawableGoldResponseModel copyWith({
    String message,
    WithdrawableGoldDetails data,
  }) {
    return WithdrawableGoldResponseModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message ?? '',
      'data': data.toMap(),
    };
  }

  factory WithdrawableGoldResponseModel.fromMap(Map<String, dynamic> map) {
    return WithdrawableGoldResponseModel(
      message: map['message'] as String,
      data:
          WithdrawableGoldDetails.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory WithdrawableGoldResponseModel.fromJson(String source) =>
      WithdrawableGoldResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WithdrawableGoldResponseModel(message: $message, data: $data)';

  @override
  bool operator ==(covariant WithdrawableGoldResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message && other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class WithdrawableGoldDetails {
  double quantity;
  double lockedQuantity;
  double balance;
  WithdrawableGoldDetails({
    @required this.quantity,
    @required this.lockedQuantity,
    @required this.balance,
  });

  WithdrawableGoldDetails copyWith({
    double quantity,
    double lockedQuantity,
    double balance,
  }) {
    return WithdrawableGoldDetails(
      quantity: quantity ?? this.quantity,
      lockedQuantity: lockedQuantity ?? this.lockedQuantity,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity ?? 0.0,
      'lockedQuantity': lockedQuantity ?? 0.0,
      'balance': balance ?? 0.0,
    };
  }

  factory WithdrawableGoldDetails.fromMap(Map<String, dynamic> map) {
    return WithdrawableGoldDetails(
      quantity: map['quantity'].toDouble(),
      lockedQuantity: map['lockedQuantity'].toDouble(),
      balance: map['balance'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WithdrawableGoldDetails.fromJson(String source) =>
      WithdrawableGoldDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WithdrawableGoldDetails(quantity: $quantity, lockedQuantity: $lockedQuantity, balance: $balance)';

  @override
  bool operator ==(covariant WithdrawableGoldDetails other) {
    if (identical(this, other)) return true;

    return other.quantity == quantity &&
        other.lockedQuantity == lockedQuantity &&
        other.balance == balance;
  }

  @override
  int get hashCode =>
      quantity.hashCode ^ lockedQuantity.hashCode ^ balance.hashCode;
}
