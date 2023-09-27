// ignore_for_file: unnecessary_lambdas

class AssetOptionsModel {
  const AssetOptionsModel({
    required this.message,
    required this.data,
  });

  final String message;
  final Data data;

  factory AssetOptionsModel.fromJson(Map<String, dynamic> json) =>
      AssetOptionsModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  const Data({
    required this.banner,
    required this.userOptions,
    this.maturityAt,
    this.intent = false,
    this.minAmount = 0,
    this.maxAmount = 0,
  });

  final Banner banner;
  final List<UserOption> userOptions;
  final DateTime? maturityAt;
  final bool intent;
  final num minAmount;
  final num maxAmount;

  factory Data.fromJson(Map<String, dynamic> json) {
    final userOptions = (json['userOptions'] ?? []) as List<dynamic>;
    return Data(
      banner: Banner.fromJson(json["banner"]),
      userOptions: List<UserOption>.from(
        userOptions.map(
          (e) => UserOption.fromJson(e),
        ),
      ),
      maturityAt: json["maturityAt"] == null
          ? null
          : DateTime.parse(json["maturityAt"]),
      intent: json['intent'] ?? false,
      minAmount: json['minAmount'] ?? 0,
      maxAmount: json['maxAmount'] ?? 0,
    );
  }
}

class Banner {
  const Banner({
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        image: json["image"],
        title: json["title"],
      );
}

class UserOption {
  UserOption({
    required this.order,
    required this.value,
    this.best = false,
  });

  final int order;
  final int value;
  final bool best;

  factory UserOption.fromJson(Map<String, dynamic> json) => UserOption(
        order: json["order"],
        value: json["value"],
        best: json["best"] ?? false,
      );
}
