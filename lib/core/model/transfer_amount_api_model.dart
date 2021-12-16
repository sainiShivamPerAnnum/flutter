class TransferAmountApiResponseModel {
  bool flag;
  String signzyReferenceId;
  String message;

  TransferAmountApiResponseModel({this.flag, this.signzyReferenceId, this.message});

  TransferAmountApiResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    signzyReferenceId = json['signzyReferenceId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['signzyReferenceId'] = this.signzyReferenceId;
    data['message'] = this.message;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'signzyReferenceId': signzyReferenceId,
      'message': message,
    };
  }

  factory TransferAmountApiResponseModel.fromMap(Map<String, dynamic> map) {
    return TransferAmountApiResponseModel(
      flag: map['flag'] ?? false,
      signzyReferenceId: map['signzyReferenceId'] ?? '',
      message: map['message'] ?? '',
    );
  }

  @override
  String toString() =>
      'TransferAmountApiResponse(flag: $flag, signzyReferenceId: $signzyReferenceId, message: $message)';
}
