import 'dart:developer';

class EligibleCouponResponseModel {
  bool? flag;
  String? message;
  String? code;
  String? desc;
  double? minAmountRequired;
  EligibleCouponResponseModel.base() {
    flag = false;
    message = '';
    desc = '';
    minAmountRequired = 0;
  }
  EligibleCouponResponseModel(
      {this.flag, this.message, this.code, this.desc, this.minAmountRequired});

  EligibleCouponResponseModel.fromJson(Map<String, dynamic> json) {
    log('$json');
    flag = json['flag'];
    message = json['message'];
    code = json['code'];
    desc = json['desc'];
    minAmountRequired = json['minAmountRequired'] * 1.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['code'] = code;
    data['desc'] = desc;
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
        minAmountRequired: double.parse(map['minAmountRequired'].toString()));
  }
}
