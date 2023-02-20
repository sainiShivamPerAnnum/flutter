class HappyHourCampign {
  String? message;
  Data? data;

  HappyHourCampign({this.message, this.data});

  HappyHourCampign.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? id;
  String? title;
  String? bottomSheetHeading;
  String? bottomSheetSubHeading;
  String? startTime;
  String? endTime;
  String? ctaText;
  String? docketHeading;
  int? minAmount;
  List<Rewards>? rewards;
  int? maxApplicable;
  bool showHappyHour = false;

  Data(
      {this.id,
      this.title,
      this.bottomSheetHeading,
      this.bottomSheetSubHeading,
      this.startTime,
      this.endTime,
      this.ctaText,
      this.docketHeading,
      this.minAmount,
      this.rewards,
      this.maxApplicable});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bottomSheetHeading = json['bottomSheetHeading'];
    bottomSheetSubHeading = json['bottomSheetSubHeading'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    ctaText = json['ctaText'];
    docketHeading = json['docketHeading'];
    minAmount = json['minAmount'];
    if (json['rewards'] != null) {
      rewards = <Rewards>[];
      json['rewards'].forEach((v) {
        rewards!.add(new Rewards.fromJson(v));
      });
    }
    maxApplicable = json['maxApplicable'];
    final date = DateTime.now();
    final _startDate = DateTime.parse(startTime!);
    final _endTime = DateTime.parse(endTime!);
    showHappyHour = date.isAfter(_startDate) && date.isBefore(_endTime);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['bottomSheetHeading'] = this.bottomSheetHeading;
    data['bottomSheetSubHeading'] = this.bottomSheetSubHeading;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['ctaText'] = this.ctaText;
    data['docketHeading'] = this.docketHeading;
    data['minAmount'] = this.minAmount;
    if (this.rewards != null) {
      data['rewards'] = this.rewards!.map((v) => v.toJson()).toList();
    }
    data['maxApplicable'] = this.maxApplicable;
    return data;
  }
}

class Rewards {
  int? value;
  String? type;

  Rewards({this.value, this.type});

  Rewards.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
