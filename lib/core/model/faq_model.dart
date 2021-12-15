class FAQModel {
  String category;
  List<FAQ> faqList;

  FAQModel({this.category, this.faqList});

  FAQModel.fromMap(Map<String, dynamic> json) {
    category = json['category'];
    faqList = [];
    for (int i = 0; i < json['fList'].length; i++) {
      faqList.add(
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
  final String header;
  final String response;
  final int order;

  FAQ({this.header, this.order, this.response});
}
