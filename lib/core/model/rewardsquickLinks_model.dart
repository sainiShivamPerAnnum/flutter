// ignore_for_file: public_member_api_docs, sort_constructors_first

class RewardsQuickLinksModel {
  String? title;
  String? subTitle;
  String? rewardText;
  String? rewardType;
  int? rewardCount;
  String? imageUrl;
  List<Cta>? cta;

  RewardsQuickLinksModel(
      {this.title,
      this.subTitle,
      this.rewardText,
      this.rewardType,
      this.rewardCount,
      this.imageUrl,
      this.cta});

  RewardsQuickLinksModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    rewardText = json['rewardText'];
    rewardType = json['rewardType'];
    rewardCount = json['rewardCount'];
    imageUrl = json['imageUrl'];
    if (json['cta'] != null) {
      cta = <Cta>[];
      json['cta'].forEach((v) {
        cta!.add(Cta.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['rewardText'] = rewardText;
    data['rewardType'] = rewardType;
    data['rewardCount'] = rewardCount;
    data['imageUrl'] = imageUrl;
    if (cta != null) {
      data['cta'] = cta!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cta {
  String? label;
  String? style;
  Action? action;

  Cta({this.label, this.style, this.action});

  Cta.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    style = json['style'];
    action = json['action'] != null ? Action.fromJson(json['action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['style'] = style;
    if (action != null) {
      data['action'] = action!.toJson();
    }
    return data;
  }
}

class Action {
  String? type;
  Payload? payload;

  Action({this.type, this.payload});

  Action.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? url;

  Payload({this.url});

  Payload.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
