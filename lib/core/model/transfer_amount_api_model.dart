class TransferAmountApiResponseModel {
  bool flag;
  bool active;
  bool nameMatch;
  String signzyReferenceId;
  String message;

  TransferAmountApiResponseModel(
      {this.flag,
      this.signzyReferenceId,
      this.message,
      this.active,
      this.nameMatch});

  TransferAmountApiResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    signzyReferenceId = json['signzyReferenceId'];
    message = json['message'];
    nameMatch = json['nameMatch'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['signzyReferenceId'] = this.signzyReferenceId;
    data['message'] = this.message;
    data['nameMatch'] = this.nameMatch;
    data['active'] = this.active;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'signzyReferenceId': signzyReferenceId,
      'message': message,
      'nameMatch': nameMatch,
      'active': active,
    };
  }

  factory TransferAmountApiResponseModel.fromMap(Map<String, dynamic> map) {
    return TransferAmountApiResponseModel(
      flag: map['flag'] ?? false,
      active: map['active'] ?? false,
      nameMatch: map['nameMatch'] ?? false,
      signzyReferenceId: map['signzyReferenceId'] ?? '',
      message: map['message'] ?? '',
    );
  }

  @override
  String toString() =>
      'TransferAmountApiResponse(flag: $flag, signzyReferenceId: $signzyReferenceId, message: $message, nameMatch: $nameMatch, active: $active)';
}
