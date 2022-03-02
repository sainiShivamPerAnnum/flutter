class DepositFcmResponseModel {
  String goldBalance;
  bool didWalletUpdate;
  bool isWalletCreated;
  bool didFLCUpdate;
  double augmontPrinciple;
  double augmontGoldQty;
  double amount;
  int flcBalance;
  String gtId;
  String error;
  bool status;

  DepositFcmResponseModel(
      {this.goldBalance,
      this.didWalletUpdate,
      this.isWalletCreated,
      this.didFLCUpdate,
      this.augmontPrinciple,
      this.augmontGoldQty,
      this.amount,
      this.flcBalance,
      this.gtId,
      this.error,
      this.status});

  DepositFcmResponseModel.fromJson(Map<String, dynamic> json) {
    goldBalance = json['goldBalance'];
    didWalletUpdate = json['didWalletUpdate'];
    isWalletCreated = json['isWalletCreated'];
    didFLCUpdate = json['didFLCUpdate'];
    augmontPrinciple = json['augmontPrinciple']?.toDouble();
    amount = json['amount']?.toDouble();
    augmontGoldQty = json['augmontGoldQty'];
    flcBalance = json['flcBalance'];
    gtId = json['gtId'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goldBalance'] = this.goldBalance;
    data['didWalletUpdate'] = this.didWalletUpdate;
    data['isWalletCreated'] = this.isWalletCreated;
    data['didFLCUpdate'] = this.didFLCUpdate;
    data['augmontPrinciple'] = this.augmontPrinciple;
    data['augmontGoldQty'] = this.augmontGoldQty;
    data['amount'] = this.amount;
    data['flcBalance'] = this.flcBalance;
    data['gtId'] = this.gtId;
    data['error'] = this.error;
    data['status'] = this.status;
    return data;
  }
}
