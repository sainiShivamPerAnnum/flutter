class VerifyPanResponseModel {
  bool flag;
  String upstreamName;
  String message;
  String gtId;

  VerifyPanResponseModel(
      {this.flag, this.upstreamName, this.message, this.gtId});

  VerifyPanResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    upstreamName = json['upstreamName'];
    message = json['message'];
    gtId = json['gtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['upstreamName'] = this.upstreamName;
    data['message'] = this.message;
    data['gtId'] = this.gtId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'flag': flag,
      'upstreamName': upstreamName,
      'message': message,
      'gtId': gtId,
    };
  }

  factory VerifyPanResponseModel.fromMap(Map<String, dynamic> map) {
    return VerifyPanResponseModel(
        flag: map['flag'] ?? false,
        upstreamName: map['upstreamName'] ?? '',
        message: map['message'] ?? '',
        gtId: map['gtId'] ?? '');
  }

  @override
  String toString() =>
      'VerifyPanResponseModel(flag: $flag, upstreamName: $upstreamName, message: $message , gtId: $gtId)';
}
