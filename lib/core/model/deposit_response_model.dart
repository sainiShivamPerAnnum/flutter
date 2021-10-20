import 'dart:convert';

import 'package:felloapp/core/model/user_transaction_model.dart';

class DepositResponseModel {
  Response response;

  DepositResponseModel({this.response});

  DepositResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }

  @override
  String toString() => 'DepositResponseModel(response: $response)';

  Map<String, dynamic> toMap() {
    return {
      'response': response.toMap(),
    };
  }

  factory DepositResponseModel.fromMap(Map<String, dynamic> map) {
    return DepositResponseModel(
      response: Response.fromMap(map['response']),
    );
  }
}

class Response {
  bool status;
  bool didWalletUpdate;
  TransactionDoc transactionDoc;
  bool didFLCUpdate;
  UserTransaction userTransaction;

  Response(
      {this.status,
      this.didWalletUpdate,
      this.transactionDoc,
      this.didFLCUpdate,
      this.userTransaction});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    didWalletUpdate = json['didWalletUpdate'];
    transactionDoc = json['transactionDoc'] != null
        ? new TransactionDoc.fromJson(json['transactionDoc'])
        : null;
    didFLCUpdate = json['didFLCUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['didWalletUpdate'] = this.didWalletUpdate;
    if (this.transactionDoc != null) {
      data['transactionDoc'] = this.transactionDoc.toJson();
    }
    data['didFLCUpdate'] = this.didFLCUpdate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'didWalletUpdate': didWalletUpdate,
      'transactionDoc': transactionDoc.toMap(),
      'didFLCUpdate': didFLCUpdate,
      'userTransaction': userTransaction.toJson(),
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      status: map['status'],
      didWalletUpdate: map['didWalletUpdate'],
      transactionDoc: TransactionDoc.fromMap(map['transactionDoc']),
      didFLCUpdate: map['didFLCUpdate'],
      userTransaction: UserTransaction.fromMap(map['userTransaction'],
          TransactionDoc.fromMap(map['transactionDoc']).transactionId),
    );
  }

  @override
  String toString() {
    return 'Response(status: $status, didWalletUpdate: $didWalletUpdate, transactionDoc: $transactionDoc, didFLCUpdate: $didFLCUpdate)';
  }
}

class TransactionDoc {
  bool status;
  String transactionId;

  TransactionDoc({this.status, this.transactionId});

  TransactionDoc.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['transactionId'] = this.transactionId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'transactionId': transactionId,
    };
  }

  factory TransactionDoc.fromMap(Map<String, dynamic> map) {
    return TransactionDoc(
      status: map['status'],
      transactionId: map['transactionId'],
    );
  }

  @override
  String toString() =>
      'TransactionDoc(status: $status, transactionId: $transactionId)';
}
