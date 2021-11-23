class TambolaTicketGenerationModel {
  bool flag;
  String message;
  List<Data> data;

  TambolaTicketGenerationModel({this.flag, this.message, this.data});

  TambolaTicketGenerationModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'message': message,
      'data': data?.map((x) => x.toMap())?.toList(),
    };
  }

  factory TambolaTicketGenerationModel.fromMap(Map<String, dynamic> map) {
    return TambolaTicketGenerationModel(
      flag: map['flag'],
      message: map['message'],
      data: List<Data>.from(map['data']?.map((x) => Data.fromMap(x))),
    );
  }

  @override
  String toString() =>
      'TambolaTicketGenerationModel(flag: $flag, message: $message, data: $data)';
}

class Data {
  AssignedTime assignedTime;
  String id;
  String val;
  int weekCode;

  Data({this.assignedTime, this.id, this.val, this.weekCode});

  Data.fromJson(Map<String, dynamic> json) {
    assignedTime = json['assigned_time'] != null
        ? new AssignedTime.fromJson(json['assigned_time'])
        : null;
    id = json['id'];
    val = json['val'];
    weekCode = json['week_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assignedTime != null) {
      data['assigned_time'] = this.assignedTime.toJson();
    }
    data['id'] = this.id;
    data['val'] = this.val;
    data['week_code'] = this.weekCode;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'assignedTime': assignedTime.toMap(),
      'id': id,
      'val': val,
      'weekCode': weekCode,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      assignedTime: AssignedTime.fromMap(map['assignedTime']),
      id: map['id'],
      val: map['val'],
      weekCode: map['weekCode'],
    );
  }

  @override
  String toString() {
    return 'Data(assignedTime: $assignedTime, id: $id, val: $val, weekCode: $weekCode)';
  }
}

class AssignedTime {
  int iSeconds;
  int iNanoseconds;

  AssignedTime({this.iSeconds, this.iNanoseconds});

  AssignedTime.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'iSeconds': iSeconds,
      'iNanoseconds': iNanoseconds,
    };
  }

  factory AssignedTime.fromMap(Map<String, dynamic> map) {
    return AssignedTime(
      iSeconds: map != null ? map['iSeconds'] ?? 0 : 0,
      iNanoseconds: map != null ? map['iNanoseconds'] ?? 0 : 0,
    );
  }

  @override
  String toString() =>
      'AssignedTime(iSeconds: $iSeconds, iNanoseconds: $iNanoseconds)';
}
