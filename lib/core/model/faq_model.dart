import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:flutter/foundation.dart';

class FAQModel {
  String? category;
  List<FAQ>? faqList;

  FAQModel({this.category, this.faqList});

  FAQModel.fromMap(Map<String, dynamic> json) {
    category = json['category'];
    faqList = [];
    for (int i = 0; i < json['fList'].length; i++) {
      faqList!.add(
        FAQ(
          header: json['fList'][i]['header'],
          response: json['fList'][i]['response'],
          order: json['fList'][i]['order'],
        ),
      );
    }
  }
}

class FAQ {
  final String? header;
  final String? response;
  final int? order;

  FAQ({this.header, this.order, this.response});
}

class FAQDataModel {
  final String? title;
  final String? description;
  static final helper =
      HelperModel<FAQDataModel>((map) => FAQDataModel.fromMap(map));

  FAQDataModel({
    @required this.title,
    @required this.description,
  });

  FAQDataModel copyWith({
    String? title,
    String? description,
  }) {
    return FAQDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory FAQDataModel.fromMap(Map<String, dynamic> map) {
    return FAQDataModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FAQDataModel.fromJson(String source) =>
      FAQDataModel.fromMap(json.decode(source));

  @override
  String toString() => 'FAQDataModel(title: $title, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FAQDataModel &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}
