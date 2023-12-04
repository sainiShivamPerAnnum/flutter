import 'package:felloapp/core/model/helper_model.dart';

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
  final String title;
  final String description;
  static final helper = HelperModel<FAQDataModel>(FAQDataModel.fromMap);

  FAQDataModel({
    required this.title,
    required this.description,
  });

  factory FAQDataModel.fromMap(Map<String, dynamic> map) {
    return FAQDataModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
