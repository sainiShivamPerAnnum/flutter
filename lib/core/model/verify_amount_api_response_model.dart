class VerifyAmountApiResponseModel {
  bool flag;
  String message;

  VerifyAmountApiResponseModel({this.flag, this.message});

  VerifyAmountApiResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['message'] = this.message;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'message': message,
    };
  }

  factory VerifyAmountApiResponseModel.fromMap(Map<String, dynamic> map) {
    return VerifyAmountApiResponseModel(
      flag: map['flag'] ?? false,
      message: map['message'] ?? '',
    );
  }

  @override
  String toString() =>
      'VerifyAmountApiResponseModel(flag: $flag, message: $message)';
}
