class RazorpayOrderIdModel {
  String message;
  Data data;

  RazorpayOrderIdModel({this.message, this.data});

  RazorpayOrderIdModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  bool status;
  String orderId;

  Data({this.status, this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    return data;
  }
}
