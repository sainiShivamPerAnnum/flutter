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

  @override
  String toString() {
    return 'QuickSaveModel{message: $message, data: $data}';
  }
}

class QuickSaveData {
  final int? order;
  final String? title;
  final String? subTitle;
  final String? icon;
  final String? action;
  final String? tag;
  final String? outerAssetUrl;
  final Theme? theme;
  final Misc? misc;

  QuickSaveData({
    this.order,
    this.title,
    this.subTitle,
    this.icon,
    this.action,
    this.tag,
    this.outerAssetUrl,
    this.theme,
    this.misc,
  });

  factory QuickSaveData.fromJson(Map<String, dynamic> json) => QuickSaveData(
        order: json["order"],
        title: json["title"],
        subTitle: json["subTitle"],
        icon: json["icon"],
        action: json["action"],
        tag: json["tag"],
        outerAssetUrl: json["outerAssetUrl"],
        theme: json["theme"] == null ? null : Theme.fromJson(json["theme"]),
        misc: json["misc"] == null ? null : Misc.fromJson(json["misc"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order,
        "title": title,
        "subTitle": subTitle,
        "icon": icon,
        "action": action,
        "tag": tag,
        "outerAssetUrl": outerAssetUrl,
        "theme": theme?.toJson(),
        "misc": misc?.toJson(),
      };

  @override
  String toString() {
    return 'QuickSaveData{order: $order, title: $title, subTitle: $subTitle, icon: $icon, action: $action, tag: $tag, outerAssetUrl: $outerAssetUrl, theme: $theme, misc: $misc}';
  }
}

class Misc {
  final int? amount;
  final String? asset;

  Misc({
    this.amount,
    this.asset,
  });

  factory Misc.fromJson(Map<String, dynamic> json) => Misc(
        amount: json["amount"],
        asset: json["asset"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "asset": asset,
      };

  @override
  String toString() {
    return 'Misc{amount: $amount, asset: $asset}';
  }
}

class Theme {
  final String? backgroundColor;
  final String? borderColor;
  final String? titleColor;
  final String? subtitleColor;

  Theme({
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.subtitleColor,
  });

  factory Theme.fromJson(Map<String, dynamic> json) => Theme(
        backgroundColor: json["backgroundColor"],
        borderColor: json["borderColor"],
        titleColor: json["titleColor"],
        subtitleColor: json["subtitleColor"],
      );

  Map<String, dynamic> toJson() => {
        "backgroundColor": backgroundColor,
        "borderColor": borderColor,
        "titleColor": titleColor,
        "subtitleColor": subtitleColor,
      };

  @override
  String toString() {
    return 'Theme{backgroundColor: $backgroundColor, borderColor: $borderColor, titleColor: $titleColor, subtitleColor: $subtitleColor}';
  }
}
