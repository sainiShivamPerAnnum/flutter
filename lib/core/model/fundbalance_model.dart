class FundBalanceModel {
  double wAugBalance;
  double wAugPrinciple;
  double wAugQuantity;
  int wLifeTimeWin;
  int wPriBalance;

  FundBalanceModel(
      {this.wAugBalance,
      this.wAugPrinciple,
      this.wAugQuantity,
      this.wLifeTimeWin,
      this.wPriBalance});

  FundBalanceModel.fromJson(Map<String, dynamic> json) {
    wAugBalance = json['wAugBalance'];
    wAugPrinciple = json['wAugPrinciple'];
    wAugQuantity = json['wAugQuantity'];
    wLifeTimeWin = json['wLifeTimeWin'];
    wPriBalance = json['wPriBalance'];
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
      wAugBalance: map['wAugBalance'],
      wAugPrinciple: map['wAugPrinciple'],
      wAugQuantity: map['wAugQuantity'],
      wLifeTimeWin: map['wLifeTimeWin'],
      wPriBalance: map['wPriBalance'],
    );
  }

  @override
  String toString() {
    return 'FundBalanceModel(wAugBalance: $wAugBalance, wAugPrinciple: $wAugPrinciple, wAugQuantity: $wAugQuantity, wLifeTimeWin: $wLifeTimeWin, wPriBalance: $wPriBalance)';
  }
}
