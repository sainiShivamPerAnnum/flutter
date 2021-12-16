class VerifyPanResponseModel {
  bool flag;
  String upstreamName;
  String message;

  VerifyPanResponseModel({this.flag, this.upstreamName, this.message});

  VerifyPanResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    upstreamName = json['upstreamName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['upstreamName'] = this.upstreamName;
    data['message'] = this.message;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'upstreamName': upstreamName,
      'message': message,
    };
  }

  factory VerifyPanResponseModel.fromMap(Map<String, dynamic> map) {
    return VerifyPanResponseModel(
      flag: map['flag'] ?? false,
      upstreamName: map['upstreamName'] ?? '',
      message: map['message'] ?? '',
    );
  }

  @override
  String toString() => 'VerifyPanResponseModel(flag: $flag, upstreamName: $upstreamName, message: $message)';
}
