// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/util/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransactionResponseModel {
  String? message;
  Data? data;
  TransactionResponseModel({
    @required this.message,
    @required this.data,
  });

  TransactionResponseModel copyWith({
    String? message,
    Data? data,
  }) {
    return TransactionResponseModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TransactionResponseModel.fromMap(Map<String, dynamic> map) {
    return TransactionResponseModel(
      message: map['message'] as String,
      data: map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : Data.base(),
    );
  }

  factory TransactionResponseModel.fromJson(String source) =>
      TransactionResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TransactionResponseModel(message: $message, data: ${data.toString()})';

  @override
  bool operator ==(covariant TransactionResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message && other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class Data {
  String? status;
  bool? isUpdating;
  int? tickets;
  double? goldInTxnBought;
  String? txnDisplayMsg;
  String? gtId;
  List<String>? gtIds;
  FloDepositDetails? floDepositDetails;
  Data({
    @required this.status,
    @required this.isUpdating,
    @required this.tickets,
    this.txnDisplayMsg,
    this.goldInTxnBought,
    this.gtId,
    this.gtIds,
    this.floDepositDetails,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        status:
            map['status'] as String? ?? Constants.TXN_STATUS_RESPONSE_PENDING,
        isUpdating: map['isUpdating'] as bool? ?? true,
        tickets: map['tickets'] as int? ?? 0,
        goldInTxnBought: (map['goldInTxnBought'] ?? 0).toDouble(),
        txnDisplayMsg: map['displayMessage'],
        gtId: map['gtId'] ?? "",
        gtIds: map['gtIds'] != null
            ? List<String>.from((map['gtIds'].cast<String>() as List<String>))
            : null,
        floDepositDetails: map["lbDepositDetails"] != null
            ? FloDepositDetails.fromMap(map["lbDepositDetails"])
            : null);
  }

  Data.base() {
    status = Constants.TXN_STATUS_RESPONSE_PENDING;
    isUpdating = true;
    tickets = 0;
    goldInTxnBought = 0.0;
    floDepositDetails = null;
  }

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Data(status: $status, isUpdating: $isUpdating, tickets: $tickets, gtId: $gtId, gtIds: $gtIds)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.status == status && other.isUpdating == isUpdating;
  }

  @override
  int get hashCode => status.hashCode ^ isUpdating.hashCode;
}

class FloDepositDetails {
  String? fundType;
  String? maturityDate;
  String? maturityString;
  FloDepositDetails({
    this.fundType,
    this.maturityDate,
    this.maturityString,
  });

  factory FloDepositDetails.fromMap(Map<String, dynamic> map) {
    return FloDepositDetails(
      fundType: map['lbFundType'],
      maturityDate: map['maturityAtMsg'],
      maturityString: map['maturityPrefMsg'],
    );
  }

  factory FloDepositDetails.fromJson(String source) =>
      FloDepositDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FloDepostDetails(fundType: $fundType, maturityDate: $maturityDate, maturityString: $maturityString)';
}
