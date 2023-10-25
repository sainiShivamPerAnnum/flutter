class FlcModel {
  String? message;
  bool? status;
  int? ticketCount;
  int? flcBalance;
  String? sessionId;
  bool? isValidUser;
  bool? canUserPlay;
  bool? isWalletInitalized;
  String? ticketFieldName;
  String? gameEndpoint;
  bool? isGtRewarded;

  FlcModel(
      {this.message,
      this.flcBalance,
      this.ticketCount,
      this.ticketFieldName,
      this.gameEndpoint,
      this.sessionId,
      this.isValidUser,
      this.canUserPlay,
      this.status,
      this.isWalletInitalized,
      this.isGtRewarded});

  FlcModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    flcBalance = json['flcBalance'] ?? 0;
    sessionId = json['sessionId'] ?? '';
    isValidUser = json['isValidUser'] ?? false;
    canUserPlay = json['canUserPlay'] ?? false;
    isWalletInitalized = json['isWalletInitalized'] ?? false;
    ticketFieldName = json['ticketFieldName'] ?? '';
    gameEndpoint = json['gameEndpoint'] ?? '';
    status = json['status'] ?? false;
    ticketCount = json['ticketCount'] ?? 0;
    isGtRewarded = json['isGtRewarded'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['flcBalance'] = flcBalance;
    data['sessionId'] = sessionId;
    data['isValidUser'] = isValidUser;
    data['canUserPlay'] = canUserPlay;
    data['isWalletInitalized'] = isWalletInitalized;
    data['status'] = status;
    data['ticketFieldName'] = ticketFieldName;
    data['gameEndpoint'] = gameEndpoint;
    data['ticketCount'] = ticketCount;
    data['isGtRewarded'] = isGtRewarded;
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
      'gameEndpoint': gameEndpoint,
      'status': status,
      'ticketCount': ticketCount,
      'isGtRewarded': isGtRewarded
    };
  }

  factory FlcModel.fromMap(Map<String, dynamic> map) {
    return FlcModel(
      message: map['message'] ?? '',
      flcBalance: map['flcBalance'] ?? 0,
      sessionId: map['sessionId'] ?? '',
      isValidUser: map['isValidUser'] ?? false,
      canUserPlay: map['canUserPlay'] ?? false,
      isWalletInitalized: map['isWalletInitalized'] ?? false,
      gameEndpoint: map['gameEndpoint'] ?? '',
      status: map['status'] ?? false,
      ticketCount: map['ticketCount'] ?? 0,
      isGtRewarded: map['isGtRewarded'] ?? false,
    );
  }
}
