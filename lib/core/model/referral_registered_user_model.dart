class RegisteredUser {
  final String? message;
  final List<String>? data;

  RegisteredUser({
    this.message,
    this.data,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) => RegisteredUser(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
