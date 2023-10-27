class DepositFcmResponseModel {
  String? goldBalance;
  bool? didWalletUpdate;
  bool? isWalletCreated;
  bool? didFLCUpdate;
  double? augmontPrinciple;
  double? augmontGoldQty;
  double? amount;
  int? flcBalance;
  String? gtId;
  String? error;
  bool? status;
  bool? autosavePrompt;

  DepositFcmResponseModel({
    this.goldBalance,
    this.didWalletUpdate,
    this.isWalletCreated,
    this.didFLCUpdate,
    this.augmontPrinciple,
    this.augmontGoldQty,
    this.amount,
    this.flcBalance,
    this.gtId,
    this.error,
    this.status,
    this.autosavePrompt = false,
  });

  DepositFcmResponseModel.fromJson(Map<String, dynamic> json) {
    goldBalance = json['goldBalance'] ?? '';
    didWalletUpdate = json['didWalletUpdate'] ?? false;
    isWalletCreated = json['isWalletCreated'] ?? false;
    didFLCUpdate = json['didFLCUpdate'] ?? false;
    augmontPrinciple = json['augmontPrinciple']?.toDouble() ?? 0.0;
    amount = json['amount']?.toDouble() ?? 0.0;
    augmontGoldQty = json['augmontGoldQty'] ?? 0.0;
    flcBalance = json['flcBalance'] ?? '0';
    gtId = json['gtId'] ?? '';
    error = json['error'] ?? '';
    status = json['status'] ?? false;
    autosavePrompt = json['autosavePrompt'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['goldBalance'] = goldBalance;
    data['didWalletUpdate'] = didWalletUpdate;
    data['isWalletCreated'] = isWalletCreated;
    data['didFLCUpdate'] = didFLCUpdate;
    data['augmontPrinciple'] = augmontPrinciple;
    data['augmontGoldQty'] = augmontGoldQty;
    data['amount'] = amount;
    data['flcBalance'] = flcBalance;
    data['gtId'] = gtId;
    data['error'] = error;
    data['status'] = status;
    data['autosavePrompt'] = autosavePrompt;
    return data;
  }
}
