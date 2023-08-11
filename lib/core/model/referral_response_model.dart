class ReferralResponse {
  final String? message;
  final ReferralData? referralData;

  ReferralResponse({
    this.message,
    this.referralData,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      ReferralResponse(
        message: json["message"],
        referralData:
            json["data"] == null ? null : ReferralData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": referralData?.toJson(),
      };
}

class ReferralData {
  final int? referralRewardAmt;
  final String? referralShortLink;
  final String? code;
  final String? referralMessage;

  ReferralData({
    this.referralRewardAmt,
    this.referralShortLink,
    this.code,
    this.referralMessage,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
        referralRewardAmt: json["referralRewardAmt"],
        referralShortLink: json["referralShortLink"],
        code: json["code"],
        referralMessage: json["referralMessage"],
      );

  Map<String, dynamic> toJson() => {
        "referralRewardAmt": referralRewardAmt,
        "referralShortLink": referralShortLink,
        "code": code,
        "referralMessage": referralMessage,
      };
}
