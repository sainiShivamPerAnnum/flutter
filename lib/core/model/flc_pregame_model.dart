class FlcModel {
  String message;
  int flcBalance;
  String sessionId;
  bool isValidUser;
  bool canUserPlay;
  bool isWalletInitalized;

  FlcModel(
      {this.message,
      this.flcBalance,
      this.sessionId,
      this.isValidUser,
      this.canUserPlay,
      this.isWalletInitalized});

  FlcModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    flcBalance = json['flcBalance'];
    sessionId = json['sessionId'];
    isValidUser = json['isValidUser'];
    canUserPlay = json['canUserPlay'];
    isWalletInitalized = json['isWalletInitalized'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['flcBalance'] = this.flcBalance;
    data['sessionId'] = this.sessionId;
    data['isValidUser'] = this.isValidUser;
    data['canUserPlay'] = this.canUserPlay;
    data['isWalletInitalized'] = this.isWalletInitalized;

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
    };
  }

  factory FlcModel.fromMap(Map<String, dynamic> map) {
    return FlcModel(
        message: map['message'],
        flcBalance: map['flcBalance'],
        sessionId: map['sessionId'],
        isValidUser: map['isValidUser'],
        canUserPlay: map['canUserPlay'],
        isWalletInitalized: map['isWalletInitalized']);
  }
}
