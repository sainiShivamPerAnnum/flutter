import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';

class DepositResponseModel {
  Response? response;
  AugResponse? augResponse;
  Note? note;
  String? gtId;

  DepositResponseModel({this.response, this.augResponse, this.note, this.gtId});

  DepositResponseModel.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    augResponse = json['augResponse'] != null
        ? AugResponse.fromJson(json['augResponse'])
        : null;
    note = json['note'] != null ? Note.fromJson(json['note']) : Note.base();
    gtId = json['gtId'] != null ? json['gtId'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    if (augResponse != null) {
      data['augResponse'] = augResponse!.toJson();
    }
    if (note != null) {
      data['note'] = note!.toJson();
    }
    if (gtId != null) {
      data['gtId'] = gtId;
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'response': response!.toMap(),
      'augResponse': augResponse?.toMap(),
      'note': note?.toMap(),
      'gtId': gtId
    };
  }

  factory DepositResponseModel.fromMap(Map<String, dynamic> map) {
    return DepositResponseModel(
        response: Response.fromMap(map['response']),
        augResponse: AugResponse?.fromMap(map['augResponse']),
        note: Note?.fromMap(map['note'] ?? {}),
        gtId: map['gtId']);
  }

  @override
  String toString() =>
      'DepositResponseModel(response: $response, augResponse: $augResponse, note: $note, gtId: $gtId)';
}

class Response {
  bool? status;
  bool? didWalletUpdate;
  TransactionDoc? transactionDoc;
  bool? didFLCUpdate;
  double? augmontPrinciple;
  double? augmontGoldQty;
  int? flcBalance;

  Response({
    this.status,
    this.didWalletUpdate,
    this.transactionDoc,
    this.didFLCUpdate,
    this.augmontGoldQty,
    this.augmontPrinciple,
    this.flcBalance,
  });

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    didWalletUpdate = json['didWalletUpdate'] ?? false;
    transactionDoc = json['transactionDoc'] != null
        ? TransactionDoc.fromJson(json['transactionDoc'])
        : null;
    didFLCUpdate = json['didFLCUpdate'];
    augmontPrinciple = json['augmontPrinciple'];
    augmontGoldQty = json['augmontGoldQty'];
    flcBalance = json['flcBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['didWalletUpdate'] = didWalletUpdate;
    if (transactionDoc != null) {
      data['transactionDoc'] = transactionDoc!.toJson();
    }
    data['didFLCUpdate'] = didFLCUpdate;
    data['didFLCUpdate'] = didFLCUpdate;
    data['augmontPrinciple'] = augmontPrinciple;
    data['augmontGoldQty'] = augmontGoldQty;
    data['flcBalance'] = flcBalance;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'didWalletUpdate': didWalletUpdate,
      'transactionDoc': transactionDoc!.toMap(),
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
  bool? status;
  String? transactionId;
  UserTransaction? transactionDetail;
  EnqueuedTaskDetails? enqueuedTaskDetails;

  TransactionDoc({
    this.status,
    this.transactionId,
    this.transactionDetail,
    this.enqueuedTaskDetails,
  });

  TransactionDoc.base() {
    status = false;
    transactionId = '';
  }

  TransactionDoc.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    transactionId = json['transactionId'] ?? '';
    transactionDetail =
        UserTransaction.fromMap(json['transactionDetails'], transactionId!);
    enqueuedTaskDetails =
        EnqueuedTaskDetails.fromMap(json['enqueuedTaskDetails']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['transactionId'] = transactionId;
    data['transactionDetails'] = transactionDetail;
    data['enqueuedTaskDetails'] = enqueuedTaskDetails;
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
      'TransactionDoc(status: $status, transactionId: $transactionId, transactionDetail: ${transactionDetail!.toJson().toString()}, enqueuedTaskDetails: ${enqueuedTaskDetails!.toJson().toString()})';
}

class EnqueuedTaskDetails {
  String? name;
  String? queuePath;

  EnqueuedTaskDetails.base() {
    name = '';
    queuePath = '';
  }

  EnqueuedTaskDetails({this.name, this.queuePath});

  EnqueuedTaskDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    queuePath = json['queuePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['queuePath'] = queuePath;
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

class Note {
  String? title;
  String? body;

  Note.base() {
    title = '';
    body = '';
  }
  Note({this.title, this.body});

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      body: map['body'],
    );
  }
}

class AugResponse {
  Data? data;

  AugResponse({this.data});

  AugResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
    };
  }

  factory AugResponse.fromMap(Map<String, dynamic>? map) {
    return AugResponse(
      data: map != null ? Data.fromMap(map['data']) : null,
    );
  }
}

class Data {
  String? transactionId;
  String? merchantTransactionId;
  String? goldBalance;

  Data({this.transactionId, this.merchantTransactionId, this.goldBalance});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    merchantTransactionId = json['merchantTransactionId'];
    goldBalance = json['goldBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['merchantTransactionId'] = merchantTransactionId;
    data['goldBalance'] = goldBalance;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'merchantTransactionId': merchantTransactionId,
      'goldBalance': goldBalance,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      transactionId: map['transactionId'],
      merchantTransactionId: map['merchantTransactionId'],
      goldBalance: map['goldBalance'],
    );
  }

  @override
  String toString() {
    return 'Data(transactionId: $transactionId, merchantTransactionId: $merchantTransactionId, goldBalance: $goldBalance)';
  }
}
