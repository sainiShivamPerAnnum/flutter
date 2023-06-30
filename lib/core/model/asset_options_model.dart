// To parse this JSON data, do
//
//     final assetOptionsModel = assetOptionsModelFromJson(jsonString);

class AssetOptionsModel {
  AssetOptionsModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory AssetOptionsModel.fromJson(Map<String, dynamic> json) =>
      AssetOptionsModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.banner,
    required this.userOptions,
    this.maturityAt,
    this.intent = false,
  });

  Banner banner;
  List<UserOption> userOptions;
  final DateTime? maturityAt;
  final bool intent;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      banner: Banner.fromJson(json["banner"]),
      userOptions: List<UserOption>.from(
          json["userOptions"].map((x) => UserOption.fromJson(x))),
      maturityAt: json["maturityAt"] == null
          ? null
          : DateTime.parse(json["maturityAt"]),
      intent: json['intent'] ?? false);
}

class Banner {
  Banner({
    required this.image,
    required this.title,
  });

  String image;
  String title;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        image: json["image"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
      };
}

class UserOption {
  UserOption({
    required this.order,
    required this.value,
    required this.best,
  });

  int order;
  int value;
  bool best;

  factory UserOption.fromJson(Map<String, dynamic> json) => UserOption(
        order: json["order"],
        value: json["value"],
        best: json["best"] == null ? false : json["best"],
      );

  Map<String, dynamic> toJson() => {
        "order": order,
        "value": value,
        "best": best == null ? false : best,
      };
}
