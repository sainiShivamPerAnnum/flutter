class FundBalanceModel {
  double? wAugBalance;
  double? wAugPrinciple;
  double? wAugQuantity;
  int? wLifeTimeWin;
  int? wPriBalance;

  FundBalanceModel(
      {this.wAugBalance,
      this.wAugPrinciple,
      this.wAugQuantity,
      this.wLifeTimeWin,
      this.wPriBalance});

  FundBalanceModel.fromJson(Map<String, dynamic> json) {
    wAugBalance = json['wAugBalance'] ?? 0.0;
    wAugPrinciple = json['wAugPrinciple'] ?? 0.0;
    wAugQuantity = json['wAugQuantity'] ?? 0.0;
    wLifeTimeWin = json['wLifeTimeWin'] ?? 0;
    wPriBalance = json['wPriBalance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wAugBalance'] = this.wAugBalance;
    data['wAugPrinciple'] = this.wAugPrinciple;
    data['wAugQuantity'] = this.wAugQuantity;
    data['wLifeTimeWin'] = this.wLifeTimeWin;
    data['wPriBalance'] = this.wPriBalance;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'wAugBalance': wAugBalance,
      'wAugPrinciple': wAugPrinciple,
      'wAugQuantity': wAugQuantity,
      'wLifeTimeWin': wLifeTimeWin,
      'wPriBalance': wPriBalance,
    };
  }

  factory FundBalanceModel.fromMap(Map<String, dynamic> map) {
    return FundBalanceModel(
      wAugBalance: (map['wAugBalance'] ?? 0).toDouble(),
      wAugPrinciple: (map['wAugPrinciple'] ?? 0).toDouble(),
      wAugQuantity: (map['wAugQuantity'] ?? 0).toDouble(),
      wLifeTimeWin: map['wLifeTimeWin'] ?? 0,
      wPriBalance: map['wPriBalance'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'FundBalanceModel(wAugBalance: $wAugBalance, wAugPrinciple: $wAugPrinciple, wAugQuantity: $wAugQuantity, wLifeTimeWin: $wLifeTimeWin, wPriBalance: $wPriBalance)';
  }
}
