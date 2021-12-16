class TransferAmountApiResponseModel {
  bool flag;
  Data data;
  String message;

  TransferAmountApiResponseModel({this.flag, this.data, this.message});

  TransferAmountApiResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'data': data.toMap(),
      'message': message,
    };
  }

  factory TransferAmountApiResponseModel.fromMap(Map<String, dynamic> map) {
    return TransferAmountApiResponseModel(
      flag: map['flag'] ?? false,
      data: Data.fromMap(map['data']),
      message: map['message'] ?? '',
    );
  }
}

class Data {
  String task;
  Essentials essentials;
  String id;
  String patronId;
  Result result;

  Data({this.task, this.essentials, this.id, this.patronId, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    essentials = json['essentials'] != null
        ? new Essentials.fromJson(json['essentials'])
        : null;
    id = json['id'];
    patronId = json['patronId'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    if (this.essentials != null) {
      data['essentials'] = this.essentials.toJson();
    }
    data['id'] = this.id;
    data['patronId'] = this.patronId;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'essentials': essentials.toMap(),
      'id': id,
      'patronId': patronId,
      'result': result.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      task: map['task'] ?? '',
      essentials: Essentials.fromMap(map['essentials']),
      id: map['id'] ?? '',
      patronId: map['patronId'] ?? '',
      result: Result.fromMap(map['result']),
    );
  }

  @override
  String toString() {
    return 'Data(task: $task, essentials: $essentials, id: $id, patronId: $patronId, result: $result)';
  }
}

class Essentials {
  String beneficiaryAccount;
  String beneficiaryIFSC;
  String beneficiaryMobile;
  String beneficiaryName;
  bool nameFuzzy;

  Essentials(
      {this.beneficiaryAccount,
      this.beneficiaryIFSC,
      this.beneficiaryMobile,
      this.beneficiaryName,
      this.nameFuzzy});

  Essentials.fromJson(Map<String, dynamic> json) {
    beneficiaryAccount = json['beneficiaryAccount'];
    beneficiaryIFSC = json['beneficiaryIFSC'];
    beneficiaryMobile = json['beneficiaryMobile'];
    beneficiaryName = json['beneficiaryName'];
    nameFuzzy = json['nameFuzzy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beneficiaryAccount'] = this.beneficiaryAccount;
    data['beneficiaryIFSC'] = this.beneficiaryIFSC;
    data['beneficiaryMobile'] = this.beneficiaryMobile;
    data['beneficiaryName'] = this.beneficiaryName;
    data['nameFuzzy'] = this.nameFuzzy;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'beneficiaryAccount': beneficiaryAccount,
      'beneficiaryIFSC': beneficiaryIFSC,
      'beneficiaryMobile': beneficiaryMobile,
      'beneficiaryName': beneficiaryName,
      'nameFuzzy': nameFuzzy,
    };
  }

  factory Essentials.fromMap(Map<String, dynamic> map) {
    return Essentials(
      beneficiaryAccount: map['beneficiaryAccount'] ?? '',
      beneficiaryIFSC: map['beneficiaryIFSC'] ?? '',
      beneficiaryMobile: map['beneficiaryMobile'] ?? '',
      beneficiaryName: map['beneficiaryName'] ?? '',
      nameFuzzy: map['nameFuzzy'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Essentials(beneficiaryAccount: $beneficiaryAccount, beneficiaryIFSC: $beneficiaryIFSC, beneficiaryMobile: $beneficiaryMobile, beneficiaryName: $beneficiaryName, nameFuzzy: $nameFuzzy)';
  }
}

class Result {
  String active;
  String nameMatch;
  String mobileMatch;
  String signzyReferenceId;
  AuditTrail auditTrail;
  BankTransfer bankTransfer;

  Result(
      {this.active,
      this.nameMatch,
      this.mobileMatch,
      this.signzyReferenceId,
      this.auditTrail,
      this.bankTransfer});

  Result.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    nameMatch = json['nameMatch'];
    mobileMatch = json['mobileMatch'];
    signzyReferenceId = json['signzyReferenceId'];
    auditTrail = json['auditTrail'] != null
        ? new AuditTrail.fromJson(json['auditTrail'])
        : null;
    bankTransfer = json['bankTransfer'] != null
        ? new BankTransfer.fromJson(json['bankTransfer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['nameMatch'] = this.nameMatch;
    data['mobileMatch'] = this.mobileMatch;
    data['signzyReferenceId'] = this.signzyReferenceId;
    if (this.auditTrail != null) {
      data['auditTrail'] = this.auditTrail.toJson();
    }
    if (this.bankTransfer != null) {
      data['bankTransfer'] = this.bankTransfer.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'nameMatch': nameMatch,
      'mobileMatch': mobileMatch,
      'signzyReferenceId': signzyReferenceId,
      'auditTrail': auditTrail.toMap(),
      'bankTransfer': bankTransfer.toMap(),
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      active: map['active'] ?? '',
      nameMatch: map['nameMatch'] ?? '',
      mobileMatch: map['mobileMatch'] ?? '',
      signzyReferenceId: map['signzyReferenceId'] ?? '',
      auditTrail: AuditTrail.fromMap(map['auditTrail']),
      bankTransfer: BankTransfer.fromMap(map['bankTransfer']),
    );
  }

  @override
  String toString() {
    return 'Result(active: $active, nameMatch: $nameMatch, mobileMatch: $mobileMatch, signzyReferenceId: $signzyReferenceId, auditTrail: $auditTrail, bankTransfer: $bankTransfer)';
  }
}

class AuditTrail {
  String nature;
  String value;
  String timestamp;

  AuditTrail({this.nature, this.value, this.timestamp});

  AuditTrail.fromJson(Map<String, dynamic> json) {
    nature = json['nature'];
    value = json['value'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nature'] = this.nature;
    data['value'] = this.value;
    data['timestamp'] = this.timestamp;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'nature': nature,
      'value': value,
      'timestamp': timestamp,
    };
  }

  factory AuditTrail.fromMap(Map<String, dynamic> map) {
    return AuditTrail(
      nature: map['nature'] ?? '',
      value: map['value'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  @override
  String toString() =>
      'AuditTrail(nature: $nature, value: $value, timestamp: $timestamp)';
}

class BankTransfer {
  String response;
  String bankRRN;
  String beneName;
  String beneMMID;
  String beneMobile;
  String beneIFSC;

  BankTransfer(
      {this.response,
      this.bankRRN,
      this.beneName,
      this.beneMMID,
      this.beneMobile,
      this.beneIFSC});

  BankTransfer.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    bankRRN = json['bankRRN'];
    beneName = json['beneName'];
    beneMMID = json['beneMMID'];
    beneMobile = json['beneMobile'];
    beneIFSC = json['beneIFSC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['bankRRN'] = this.bankRRN;
    data['beneName'] = this.beneName;
    data['beneMMID'] = this.beneMMID;
    data['beneMobile'] = this.beneMobile;
    data['beneIFSC'] = this.beneIFSC;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'response': response,
      'bankRRN': bankRRN,
      'beneName': beneName,
      'beneMMID': beneMMID,
      'beneMobile': beneMobile,
      'beneIFSC': beneIFSC,
    };
  }

  factory BankTransfer.fromMap(Map<String, dynamic> map) {
    return BankTransfer(
      response: map['response'] ?? '',
      bankRRN: map['bankRRN'] ?? '',
      beneName: map['beneName'] ?? '',
      beneMMID: map['beneMMID'] ?? '',
      beneMobile: map['beneMobile'] ?? '',
      beneIFSC: map['beneIFSC'] ?? '',
    );
  }

  @override
  String toString() {
    return 'BankTransfer(response: $response, bankRRN: $bankRRN, beneName: $beneName, beneMMID: $beneMMID, beneMobile: $beneMobile, beneIFSC: $beneIFSC)';
  }
}
