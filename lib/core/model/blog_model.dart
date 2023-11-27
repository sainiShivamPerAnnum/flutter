import 'dart:convert';

import 'package:flutter/foundation.dart';

List<BlogPostModel> blogPostModelFromMap(String str) =>
    List<BlogPostModel>.from(
        json.decode(str).map((x) => BlogPostModel.fromMap(x)));

class BlogPostModelByCategory {
  final String? category;
  final List<BlogPostModel>? blogs;

  BlogPostModelByCategory({
    @required this.category,
    @required this.blogs,
  });
}

class BlogPostModel {
  BlogPostModel({
    this.id,
    this.date,
    this.slug,
    this.title,
    this.acf,
    this.yoastHeadJson,
  });

  int? id;
  DateTime? date;
  String? slug;
  Title? title;
  Acf? acf;
  String? yoastHeadJson;

  factory BlogPostModel.fromMap(Map<String, dynamic> json) => BlogPostModel(
        id: json["id"] ?? -1,
        date: DateTime.parse(json["date"]),
        slug: json["slug"] ?? '',
        title: Title.fromMap(json["title"]),
        acf: Acf.fromMap(json["acf"]),
        yoastHeadJson: getImageFromMap(json["yoast_head_json"]),
      );

  static String getImageFromMap(Map<String, dynamic> yoastHeadJson) {
    final List ogImageMap = yoastHeadJson["og_image"];
    final Map<String, dynamic> ogImage = ogImageMap[0];
    final String ogImageUrl = ogImage["url"];
    return ogImageUrl;
  }
}

class Acf {
  Acf({
    this.categories,
  });

  String? categories;
  Acf.base() {
    categories = '';
  }
  factory Acf.fromMap(Map<String, dynamic> json) => Acf(
        categories: json["categories"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "categories": categories,
      };
}

class Title {
  Title({
    this.rendered,
  });

  String? rendered;
  Title.base() {
    rendered = '';
  }
  factory Title.fromMap(Map<String, dynamic> json) => Title(
        rendered: json["rendered"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "rendered": rendered,
      };
}

class YoastHeadJson {
  YoastHeadJson({
    this.ogImage,
  });

  List<OgImage>? ogImage;
  YoastHeadJson.base() {
    ogImage = [];
  }
  factory YoastHeadJson.fromMap(Map<String, dynamic> json) => YoastHeadJson(
        ogImage:
            List<OgImage>.from(json["og_image"].map((x) => OgImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "og_image": List<dynamic>.from(ogImage!.map((x) => x.toMap())),
      };
}

class OgImage {
  OgImage({
    this.width,
    this.height,
    this.url,
    this.type,
  });

  int? width;
  int? height;
  String? url;
  Type? type;

  factory OgImage.fromMap(Map<String, dynamic> json) => OgImage(
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
        url: json["url"] ?? '',
        type: json["type"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "width": width,
        "height": height,
        "url": url,
        "type": type,
      };
}
