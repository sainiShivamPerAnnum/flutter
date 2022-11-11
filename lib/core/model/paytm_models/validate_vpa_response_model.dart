class ValidateVpaResponseModel {
  String? message;
  Data? data;

  ValidateVpaResponseModel({this.message, this.data});

  ValidateVpaResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    data = json['data'] != null ? new Data.fromJson(json['data']) : Data.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? status;
  bool? valid;
  bool? pspSupportedRecurring;
  bool? bankSupportedRecurring;

  Data({this.valid, this.pspSupportedRecurring, this.bankSupportedRecurring});
  Data.base() {
    status = false;
    valid = false;
    pspSupportedRecurring = false;
    bankSupportedRecurring = false;
  }
  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    valid = json['valid'] ?? false;
    pspSupportedRecurring = json['pspSupportedRecurring'] ?? false;
    bankSupportedRecurring = json['bankSupportedRecurring'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valid'] = this.valid;
    data['status'] = this.status;
    data['pspSupportedRecurring'] = this.pspSupportedRecurring;
    data['bankSupportedRecurring'] = this.bankSupportedRecurring;
    return data;
  }
}
