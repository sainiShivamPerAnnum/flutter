class QuickSaveModel {
  final String? message;
  final List<QuickSaveData>? data;

  QuickSaveModel({
    this.message,
    this.data,
  });

  factory QuickSaveModel.fromJson(Map<String, dynamic> json) => QuickSaveModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<QuickSaveData>.from(
                json["data"]!.map((x) => QuickSaveData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class QuickSaveData {
  final int? order;
  final String? title;
  final String? subTitle;
  final String? icon;
  final String? action;
  final String? backgroundColor;
  final String? tag;
  final Misc? misc;

  QuickSaveData({
    this.order,
    this.title,
    this.subTitle,
    this.icon,
    this.action,
    this.backgroundColor,
    this.tag,
    this.misc,
  });

  factory QuickSaveData.fromJson(Map<String, dynamic> json) => QuickSaveData(
        order: json["order"],
        title: json["title"],
        subTitle: json["subTitle"],
        icon: json["icon"],
        action: json["action"],
        backgroundColor: json["backgroundColor"],
        tag: json["tag"],
        misc: json["misc"] == null ? null : Misc.fromJson(json["misc"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order,
        "title": title,
        "subTitle": subTitle,
        "icon": icon,
        "action": action,
        "backgroundColor": backgroundColor,
        "tag": tag,
        "misc": misc?.toJson(),
      };
}

class Misc {
  final int? amount;
  final String? asset;
  final String? coupon;

  Misc({
    this.amount,
    this.asset,
    this.coupon,
  });

  factory Misc.fromJson(Map<String, dynamic> json) => Misc(
        amount: json["amount"],
        asset: json["asset"],
        coupon: json["coupon"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "asset": asset,
        "coupon": coupon,
      };
}
