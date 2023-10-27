class ValidateVpaResponseModel {
  String? message;
  Data? data;

  ValidateVpaResponseModel({this.message, this.data});

  ValidateVpaResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    data = json['data'] != null ? Data.fromJson(json['data']) : Data.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['valid'] = valid;
    data['status'] = status;
    data['pspSupportedRecurring'] = pspSupportedRecurring;
    data['bankSupportedRecurring'] = bankSupportedRecurring;
    return data;
  }
}
