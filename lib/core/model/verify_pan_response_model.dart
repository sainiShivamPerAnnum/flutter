class VerifyPanResponseModel {
  bool? flag;
  String? upstreamName;
  String? message;
  String? gtId;

  VerifyPanResponseModel(
      {this.flag, this.upstreamName, this.message, this.gtId});

  VerifyPanResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'] ?? false;
    upstreamName = json['upstreamName'];
    message = json['message'];
    gtId = json['gtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['upstreamName'] = upstreamName;
    data['message'] = message;
    data['gtId'] = gtId;
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
