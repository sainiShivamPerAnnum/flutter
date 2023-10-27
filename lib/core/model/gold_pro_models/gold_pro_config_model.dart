// ignore_for_file: public_member_api_docs, sort_constructors_first

class GoldProConfig {
  String? message;
  Data? data;

  GoldProConfig({this.message, this.data});

  GoldProConfig.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  InterestBreakDown? interestBreakDown;
  List<Videos>? videos;
  List<Highlights>? highlights;
  List<Faqs>? faqs;
  String? subText;

  Data({
    this.sId,
    this.interestBreakDown,
    this.videos,
    this.highlights,
    this.faqs,
    this.subText,
  });

  Data.fromJson(Map<String, dynamic> json) {
    subText = json['subText'];
    sId = json['_id'] ?? "";
    interestBreakDown = json['interestBreakDown'] != null
        ? InterestBreakDown.fromJson(json['interestBreakDown'])
        : null;
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    if (json['highlights'] != null) {
      highlights = <Highlights>[];
      json['highlights'].forEach((v) {
        highlights!.add(Highlights.fromJson(v));
      });
    }
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromMap(v));
      });
    }
  }
}

class InterestBreakDown {
  Fixed? fixed;
  Fixed? extra;
  String? subText;

  InterestBreakDown({this.fixed, this.extra, this.subText});

  InterestBreakDown.fromJson(Map<String, dynamic> json) {
    fixed =
        json['fixed'] != null ? Fixed.fromJson(json['fixed']) : Fixed.base();
    extra =
        json['extra'] != null ? Fixed.fromJson(json['extra']) : Fixed.base();
    subText = json['subText'] ?? "100K + Users are enjoying 4.5% Extra Gold";
  }

  InterestBreakDown.base() {
    fixed = Fixed.base();
    extra = Fixed.base();
    subText = "100K + Users are enjoying 4.5% Extra Gold";
  }
}

class Fixed {
  String? title;
  String? subTitle;

  Fixed({this.title, this.subTitle});

  Fixed.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
  }

  Fixed.base() {
    title = "2.75%";
    subTitle = "credited daily";
  }
}

class Videos {
  String? src;
  int? order;

  Videos({this.src, this.order});

  Videos.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    order = json['order'];
  }

  Videos.base() {
    src = "https://youtube.com/shorts/xt2DAiv1VP8";
    order = 0;
  }
}

class Highlights {
  String? title;
  String? subTitle;
  int? order;

  Highlights({this.title, this.subTitle, this.order});

  Highlights.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    subTitle = json['subTitle'] ?? "";
    order = json['order'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['order'] = order;
    return data;
  }
}

class Faqs {
  String? title;
  String? subTitle;
  int? order;
  Faqs({
    this.title,
    this.subTitle,
    this.order,
  });

  Faqs copyWith({
    String? title,
    String? subTitle,
    int? order,
  }) {
    return Faqs(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      order: order ?? this.order,
    );
  }

  factory Faqs.fromMap(Map<String, dynamic> map) {
    return Faqs(
      title: map['title'] != null ? map['title'] as String : "",
      subTitle: map['subTitle'] != null ? map['subTitle'] as String : "",
      order: map['order'] != null ? map['order'] as int : 0,
    );
  }
}
