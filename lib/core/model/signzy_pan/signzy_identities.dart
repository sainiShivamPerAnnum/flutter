class SignzyIdentities {
  String type;
  String email;
  String callbackUrl;
  String accessToken;
  String id;
  String patronId;

  SignzyIdentities(
      {this.type,
      this.email,
      this.callbackUrl,
      this.accessToken,
      this.id,
      this.patronId});

  SignzyIdentities.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    email = json['email'];
    callbackUrl = json['callbackUrl'];
    accessToken = json['accessToken'];
    id = json['id'];
    patronId = json['patronId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['email'] = this.email;
    data['callbackUrl'] = this.callbackUrl;
    data['accessToken'] = this.accessToken;
    data['id'] = this.id;
    data['patronId'] = this.patronId;
    return data;
  }
}