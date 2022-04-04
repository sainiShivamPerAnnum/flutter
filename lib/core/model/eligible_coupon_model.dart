class EligibleCouponResponseModel {
  bool flag;
  String message;
  String code;
  String desc;

  EligibleCouponResponseModel({this.flag, this.message, this.code, this.desc});

  EligibleCouponResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    code = json['code'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['message'] = this.message;
    data['code'] = this.code;
    data['desc'] = this.desc;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'message': message,
      'code': code,
      'desc': desc,
    };
  }

  factory EligibleCouponResponseModel.fromMap(Map<String, dynamic> map) {
    return EligibleCouponResponseModel(
      flag: map['flag'] ?? false,
      message: map['message'] ?? '',
      code: map['code'] ?? '',
      desc: map['desc'] ?? '',
    );
  }
}
