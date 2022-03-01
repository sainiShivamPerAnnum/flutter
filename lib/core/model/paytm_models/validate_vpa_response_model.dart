class ValidateVpaResponseModel {
  bool success;
  Data data;

  ValidateVpaResponseModel({this.success, this.data});

  ValidateVpaResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  bool valid;
  bool pspSupportedRecurring;
  bool bankSupportedRecurring;

  Data({this.valid, this.pspSupportedRecurring, this.bankSupportedRecurring});

  Data.fromJson(Map<String, dynamic> json) {
    valid = json['valid'];
    pspSupportedRecurring = json['pspSupportedRecurring'];
    bankSupportedRecurring = json['bankSupportedRecurring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valid'] = this.valid;
    data['pspSupportedRecurring'] = this.pspSupportedRecurring;
    data['bankSupportedRecurring'] = this.bankSupportedRecurring;
    return data;
  }
}
