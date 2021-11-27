import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';

class DepositResponseModel {
  Response response;
  AugResponse augResponse;

  DepositResponseModel({this.response, this.augResponse});

  DepositResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    augResponse = json['augResponse'] != null
        ? new AugResponse.fromJson(json['augResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    if (this.augResponse != null) {
      data['augResponse'] = this.augResponse.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'response': response.toMap(),
      'augResponse': augResponse?.toMap(),
    };
  }

  factory DepositResponseModel.fromMap(Map<String, dynamic> map) {
    return DepositResponseModel(
      response: Response.fromMap(map['response']),
      augResponse: AugResponse?.fromMap(map['augResponse']),
    );
  }

  @override
  String toString() =>
      'DepositResponseModel(response: $response, augResponse: $augResponse)';
}

class Response {
  bool status;
  bool didWalletUpdate;
  TransactionDoc transactionDoc;
  bool didFLCUpdate;
  double augmontPrinciple;
  double augmontGoldQty;
  int flcBalance;

  Response(
      {this.status,
      this.didWalletUpdate,
      this.transactionDoc,
      this.didFLCUpdate,
      this.augmontGoldQty,
      this.augmontPrinciple,
      this.flcBalance});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    didWalletUpdate = json['didWalletUpdate'];
    transactionDoc = json['transactionDoc'] != null
        ? new TransactionDoc.fromJson(json['transactionDoc'])
        : null;
    didFLCUpdate = json['didFLCUpdate'];
    augmontPrinciple = json['augmontPrinciple'];
    augmontGoldQty = json['augmontGoldQty'];
    flcBalance = json['flcBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['didWalletUpdate'] = this.didWalletUpdate;
    if (this.transactionDoc != null) {
      data['transactionDoc'] = this.transactionDoc.toJson();
    }
    data['didFLCUpdate'] = this.didFLCUpdate;
    data['didFLCUpdate'] = this.didFLCUpdate;
    data['augmontPrinciple'] = this.augmontPrinciple;
    data['augmontGoldQty'] = this.augmontGoldQty;
    data['flcBalance'] = this.flcBalance;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'didWalletUpdate': didWalletUpdate,
      'transactionDoc': transactionDoc.toMap(),
      'didFLCUpdate': didFLCUpdate,
      'augmontPrinciple': augmontPrinciple,
      'augmontGoldQty': augmontGoldQty,
      'flcBalance': flcBalance,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      status: map['status'],
      didWalletUpdate: map['didWalletUpdate'],
      transactionDoc: TransactionDoc.fromMap(map['transactionDoc']),
      didFLCUpdate: map['didFLCUpdate'],
      augmontPrinciple: BaseUtil.toDouble(map['augmontPrinciple']),
      augmontGoldQty: BaseUtil.toDouble(map['augmontGoldQty']),
      flcBalance: BaseUtil.toInt(map['flcBalance']),
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
  UserTransaction transactionDetail;
  EnqueuedTaskDetails enqueuedTaskDetails;

  TransactionDoc({
    this.status,
    this.transactionId,
    this.transactionDetail,
    this.enqueuedTaskDetails,
  });

  TransactionDoc.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    transactionId = json['transactionId'];
    transactionDetail =
        UserTransaction.fromMap(json['transactionDetails'], transactionId);
    enqueuedTaskDetails =
        EnqueuedTaskDetails.fromMap(json['enqueuedTaskDetails']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['transactionId'] = this.transactionId;
    data['transactionDetails'] = this.transactionDetail;
    data['enqueuedTaskDetails'] = this.enqueuedTaskDetails;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'transactionId': transactionId,
      'transactionDetail': transactionDetail,
      'enqueuedTaskDetails': enqueuedTaskDetails
    };
  }

  factory TransactionDoc.fromMap(Map<String, dynamic> map) {
    return TransactionDoc(
      status: map['status'],
      transactionId: map['transactionId'],
      transactionDetail: UserTransaction.fromJSON(
          map['transactionDetails'], map['transactionId']),
      enqueuedTaskDetails: map['enqueuedTaskDetails'] != null
          ? EnqueuedTaskDetails.fromJson(map['enqueuedTaskDetails'])
          : EnqueuedTaskDetails(name: "", queuePath: ""),
    );
  }

  @override
  String toString() =>
      'TransactionDoc(status: $status, transactionId: $transactionId, transactionDetail: ${transactionDetail.toJson().toString()}, enqueuedTaskDetails: ${enqueuedTaskDetails.toJson().toString()})';
}

class EnqueuedTaskDetails {
  String name;
  String queuePath;

  EnqueuedTaskDetails({this.name, this.queuePath});

  EnqueuedTaskDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    queuePath = json['queuePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['queuePath'] = this.queuePath;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'queuePath': queuePath,
    };
  }

  factory EnqueuedTaskDetails.fromMap(Map<String, dynamic> map) {
    return EnqueuedTaskDetails(
      name: map['name'],
      queuePath: map['queuePath'],
    );
  }

  @override
  String toString() =>
      'EnqueuedTaskDetails(name: $name, queuePath: $queuePath)';
}

class AugResponse {
  bool flag;
  String message;
  Data data;

  AugResponse({this.flag, this.message, this.data});

  AugResponse.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory AugResponse.fromMap(Map<String, dynamic> map) {
    return AugResponse(
      flag: map != null ? map['flag'] : null,
      message: map != null ? map['message'] : null,
      data: map != null ? Data.fromMap(map['data']) : null,
    );
  }
}

class Data {
  String quantity;
  String totalAmount;
  String preTaxAmount;
  String metalType;
  String rate;
  String uniqueId;
  String transactionId;
  String userName;
  String merchantTransactionId;
  String mobileNumber;
  String goldBalance;
  String silverBalance;
  Taxes taxes;
  String invoiceNumber;
  Null referenceType;
  Null referenceId;

  Data(
      {this.quantity,
      this.totalAmount,
      this.preTaxAmount,
      this.metalType,
      this.rate,
      this.uniqueId,
      this.transactionId,
      this.userName,
      this.merchantTransactionId,
      this.mobileNumber,
      this.goldBalance,
      this.silverBalance,
      this.taxes,
      this.invoiceNumber,
      this.referenceType,
      this.referenceId});

  Data.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    totalAmount = json['totalAmount'];
    preTaxAmount = json['preTaxAmount'];
    metalType = json['metalType'];
    rate = json['rate'];
    uniqueId = json['uniqueId'];
    transactionId = json['transactionId'];
    userName = json['userName'];
    merchantTransactionId = json['merchantTransactionId'];
    mobileNumber = json['mobileNumber'];
    goldBalance = json['goldBalance'];
    silverBalance = json['silverBalance'];
    taxes = json['taxes'] != null ? new Taxes.fromJson(json['taxes']) : null;
    invoiceNumber = json['invoiceNumber'];
    referenceType = json['referenceType'];
    referenceId = json['referenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['totalAmount'] = this.totalAmount;
    data['preTaxAmount'] = this.preTaxAmount;
    data['metalType'] = this.metalType;
    data['rate'] = this.rate;
    data['uniqueId'] = this.uniqueId;
    data['transactionId'] = this.transactionId;
    data['userName'] = this.userName;
    data['merchantTransactionId'] = this.merchantTransactionId;
    data['mobileNumber'] = this.mobileNumber;
    data['goldBalance'] = this.goldBalance;
    data['silverBalance'] = this.silverBalance;
    if (this.taxes != null) {
      data['taxes'] = this.taxes.toJson();
    }
    data['invoiceNumber'] = this.invoiceNumber;
    data['referenceType'] = this.referenceType;
    data['referenceId'] = this.referenceId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'totalAmount': totalAmount,
      'preTaxAmount': preTaxAmount,
      'metalType': metalType,
      'rate': rate,
      'uniqueId': uniqueId,
      'transactionId': transactionId,
      'userName': userName,
      'merchantTransactionId': merchantTransactionId,
      'mobileNumber': mobileNumber,
      'goldBalance': goldBalance,
      'silverBalance': silverBalance,
      'taxes': taxes?.toMap(),
      'invoiceNumber': invoiceNumber,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      quantity: map['quantity'],
      totalAmount: map['totalAmount'],
      preTaxAmount: map['preTaxAmount'],
      metalType: map['metalType'],
      rate: map['rate'],
      uniqueId: map['uniqueId'],
      transactionId: map['transactionId'],
      userName: map['userName'],
      merchantTransactionId: map['merchantTransactionId'],
      mobileNumber: map['mobileNumber'],
      goldBalance: map['goldBalance'],
      silverBalance: map['silverBalance'],
      taxes: Taxes?.fromMap(map['taxes']),
      invoiceNumber: map['invoiceNumber'],
    );
  }

  @override
  String toString() {
    return 'Data(quantity: $quantity, totalAmount: $totalAmount, preTaxAmount: $preTaxAmount, metalType: $metalType, rate: $rate, uniqueId: $uniqueId, transactionId: $transactionId, userName: $userName, merchantTransactionId: $merchantTransactionId, mobileNumber: $mobileNumber, goldBalance: $goldBalance, silverBalance: $silverBalance, taxes: $taxes, invoiceNumber: $invoiceNumber)';
  }
}

class Taxes {
  String totalTaxAmount;
  List<TaxSplit> taxSplit;

  Taxes({this.totalTaxAmount, this.taxSplit});

  Taxes.fromJson(Map<String, dynamic> json) {
    totalTaxAmount = json['totalTaxAmount'];
    if (json['taxSplit'] != null) {
      taxSplit = new List<TaxSplit>();
      json['taxSplit'].forEach((v) {
        taxSplit.add(new TaxSplit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalTaxAmount'] = this.totalTaxAmount;
    if (this.taxSplit != null) {
      data['taxSplit'] = this.taxSplit.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'totalTaxAmount': totalTaxAmount,
      'taxSplit': taxSplit?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Taxes.fromMap(Map<String, dynamic> map) {
    return Taxes(
      totalTaxAmount: map != null ? map['totalTaxAmount'] : null,
      taxSplit: map != null
          ? List<TaxSplit>.from(
              map['taxSplit']?.map((x) => TaxSplit.fromMap(x)))
          : null,
    );
  }

  @override
  String toString() =>
      'Taxes(totalTaxAmount: $totalTaxAmount, taxSplit: $taxSplit)';
}

class TaxSplit {
  String type;
  String taxPerc;
  String taxAmount;

  TaxSplit({this.type, this.taxPerc, this.taxAmount});

  TaxSplit.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    taxPerc = json['taxPerc'];
    taxAmount = json['taxAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['taxPerc'] = this.taxPerc;
    data['taxAmount'] = this.taxAmount;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'taxPerc': taxPerc,
      'taxAmount': taxAmount,
    };
  }

  factory TaxSplit.fromMap(Map<String, dynamic> map) {
    return TaxSplit(
      type: map != null ? map['type'] : null,
      taxPerc: map != null ? map['taxPerc'] : null,
      taxAmount: map != null ? map['taxAmount'] : null,
    );
  }

  @override
  String toString() =>
      'TaxSplit(type: $type, taxPerc: $taxPerc, taxAmount: $taxAmount)';
}
