class HappyHourCampign {
  String? message;
  Data? data;

  HappyHourCampign({this.message, this.data});

  HappyHourCampign.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  HappyHourType happyHourType = HappyHourType.expired;
  PreBuzz? preBuzz;
  Data(
      {required this.happyHourType,
      this.id,
      this.title,
      this.bottomSheetHeading,
      this.bottomSheetSubHeading,
      this.startTime,
      this.endTime,
      this.ctaText,
      this.docketHeading,
      this.minAmount,
      this.rewards,
      this.preBuzz,
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
        rewards!.add(Rewards.fromJson(v));
      });
    }
    preBuzz = PreBuzz.fromJson(json['prebuzz']);
    maxApplicable = json['maxApplicable'];
    final date = DateTime.now();
    final _startDate = DateTime.parse(startTime!);
    final _endTime = DateTime.parse(endTime!);
    showHappyHour = date.isAfter(_startDate) && date.isBefore(_endTime);
    getType(_startDate, _endTime);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['bottomSheetHeading'] = bottomSheetHeading;
    data['bottomSheetSubHeading'] = bottomSheetSubHeading;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['ctaText'] = ctaText;
    data['docketHeading'] = docketHeading;
    data['minAmount'] = minAmount;
    if (rewards != null) {
      data['rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    data['maxApplicable'] = maxApplicable;
    return data;
  }

  void getType(DateTime startDate, DateTime endDate) {
    final _time = DateTime.now();

    if (showHappyHour) {
      happyHourType = HappyHourType.live;
    } else if (_time.isBefore(startDate)) {
      if (startDate.difference(_time).inHours < 5) {
        happyHourType = HappyHourType.preBuzz;
      } else {
        happyHourType = HappyHourType.notStarted;
      }
    } else {
      happyHourType = HappyHourType.expired;
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['type'] = type;
    return data;
  }
}

class PreBuzz {
  final String heading;
  final int luckyWinnersCount;
  final String subtitle;
  final String title;

  PreBuzz(
      {required this.heading,
      required this.luckyWinnersCount,
      required this.subtitle,
      required this.title});

  factory PreBuzz.fromJson(Map<String, dynamic> data) => PreBuzz(
        heading: data['heading'],
        luckyWinnersCount: data['luckyWinnersCount'],
        subtitle: data['subtitle'],
        title: data['title'],
      );
}

enum HappyHourType { notStarted, preBuzz, live, expired }
