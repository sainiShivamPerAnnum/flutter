class SignzyPanLogin {
  String accessToken;
  int ttl;
  String userId;
  String baseUrl;

  SignzyPanLogin({this.accessToken, this.ttl, this.userId, this.baseUrl});

  SignzyPanLogin.fromJson(Map<String, dynamic> json) {
    accessToken = json['id'];
    ttl = json['ttl'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.accessToken;
    data['ttl'] = this.ttl;
    data['created'] = this.accessToken;
    data['userId'] = this.userId;
    return data;
  }
}
