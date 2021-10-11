class FlcModel {
  String message;
  int flcBalance;
  String sessionId;

  FlcModel({this.message, this.flcBalance, this.sessionId});

  FlcModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    flcBalance = json['flcBalance'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['flcBalance'] = this.flcBalance;
    data['sessionId'] = this.sessionId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'flcBalance': flcBalance,
      'sessionId': sessionId,
    };
  }

  factory FlcModel.fromMap(Map<String, dynamic> map) {
    return FlcModel(
      message: map['message'],
      flcBalance: map['flcBalance'],
      sessionId: map['sessionId'],
    );
  }
}
