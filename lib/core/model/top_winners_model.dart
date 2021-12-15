class TopWinnersModel {
  List<String> currentTopWinners;

  TopWinnersModel({this.currentTopWinners});

  TopWinnersModel.fromJson(Map<String, dynamic> json) {
    currentTopWinners = json['currentTopWinners'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentTopWinners'] = this.currentTopWinners;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'currentTopWinners': currentTopWinners,
    };
  }

  factory TopWinnersModel.fromMap(Map<String, dynamic> map) {
    return TopWinnersModel(
      currentTopWinners: List<String>.from(map['currentTopWinners']),
    );
  }


  @override
  String toString() => 'TopWinnersModel(currentTopWinners: $currentTopWinners)';
}
