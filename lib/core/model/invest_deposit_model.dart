class InvestmentDepositModel {
  bool status;
  String message;
  bool isValidUser;

  InvestmentDepositModel({this.status, this.message, this.isValidUser});

  InvestmentDepositModel.fromMap(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isValidUser = json['isValidUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['isValidUser'] = this.isValidUser;
    return data;
  }
}