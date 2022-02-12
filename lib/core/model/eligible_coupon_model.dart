class EligibleCouponResponseModel {
  bool flag;
  String message;

  EligibleCouponResponseModel({this.flag, this.message});

  EligibleCouponResponseModel.fromJson(Map<String, dynamic> json) {
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

  factory EligibleCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return EligibleCouponResponseModel(
      flag: map['flag'] ?? false,
      message: map['message'] ?? '',
    );
  }
}
