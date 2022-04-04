class FlcModel {
  String message;
  bool status;
  int ticketCount;
  int flcBalance;
  String sessionId;
  bool isValidUser;
  bool canUserPlay;
  bool isWalletInitalized;
  String ticketFieldName;
  bool isGtRewarded;

  FlcModel(
      {this.message,
      this.flcBalance,
      this.ticketCount,
      this.ticketFieldName,
      this.sessionId,
      this.isValidUser,
      this.canUserPlay,
      this.status,
      this.isWalletInitalized,
      this.isGtRewarded});

  FlcModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    flcBalance = json['flcBalance'];
    sessionId = json['sessionId'];
    isValidUser = json['isValidUser'];
    canUserPlay = json['canUserPlay'];
    isWalletInitalized = json['isWalletInitalized'];
    ticketFieldName = json['ticketFieldName'];
    status = json['status'];
    ticketCount = json['ticketCount'];
    isGtRewarded = json['isGtRewarded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['flcBalance'] = this.flcBalance;
    data['sessionId'] = this.sessionId;
    data['isValidUser'] = this.isValidUser;
    data['canUserPlay'] = this.canUserPlay;
    data['isWalletInitalized'] = this.isWalletInitalized;
    data['status'] = this.status;
    data['ticketFieldName'] = this.ticketFieldName;
    data['ticketCount'] = this.ticketCount;
    data['isGtRewarded'] = this.isGtRewarded;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'flcBalance': flcBalance,
      'sessionId': sessionId,
      'isValidUser': isValidUser,
      'canUserPlay': canUserPlay,
      'isWalletInitalized': isWalletInitalized,
      'ticketFieldName': ticketFieldName,
      'status': status,
      'ticketCount': ticketCount,
      'isGtRewarded': isGtRewarded
    };
  }

  factory FlcModel.fromMap(Map<String, dynamic> map) {
    return FlcModel(
        message: map['message'],
        flcBalance: map['flcBalance'],
        sessionId: map['sessionId'],
        isValidUser: map['isValidUser'],
        canUserPlay: map['canUserPlay'],
        isWalletInitalized: map['isWalletInitalized'],
        ticketFieldName: map['ticketFieldName'],
        status: map['status'],
        ticketCount: map['ticketCount'],
        isGtRewarded: map['isGtRewarded']);
  }
}
