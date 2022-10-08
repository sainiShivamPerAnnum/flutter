// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:felloapp/util/constants.dart';

class TransactionResponseModel {
  String message;
  Data data;
  TransactionResponseModel({
    @required this.message,
    @required this.data,
  });

  TransactionResponseModel copyWith({
    String message,
    Data data,
  }) {
    return TransactionResponseModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'data': data.toMap(),
    };
  }

  factory TransactionResponseModel.fromMap(Map<String, dynamic> map) {
    return TransactionResponseModel(
      message: map['message'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionResponseModel.fromJson(String source) =>
      TransactionResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TransactionResponseModel(message: $message, data: $data)';

  @override
  bool operator ==(covariant TransactionResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message && other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class Data {
  String status;
  bool isUpdating;
  int tickets;
  double goldInTxnBought;
  Data(
      {@required this.status,
      @required this.isUpdating,
      @required this.tickets,
      this.goldInTxnBought});

  Data copyWith(
      {bool status, bool isUpdating, int tickets, double goldInTxnBought}) {
    return Data(
        status: status ?? this.status,
        isUpdating: isUpdating ?? this.isUpdating,
        tickets: tickets ?? this.tickets,
        goldInTxnBought: goldInTxnBought ?? this.goldInTxnBought);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'isUpdating': isUpdating,
      'tickets': tickets
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        status:
            map['status'] as String ?? Constants.TXN_STATUS_RESPONSE_PENDING,
        isUpdating: map['isUpdating'] as bool ?? true,
        tickets: map['tickets'] as int ?? 0,
        goldInTxnBought: map['goldInTxnBought'] as double ?? 0.0);
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Data(status: $status, isUpdating: $isUpdating, tickets: $tickets)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.status == status && other.isUpdating == isUpdating;
  }

  @override
  int get hashCode => status.hashCode ^ isUpdating.hashCode;
}
