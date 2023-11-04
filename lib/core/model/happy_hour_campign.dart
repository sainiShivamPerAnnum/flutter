class HappyHourCampign {
  String? message;
  Data? data;

  HappyHourCampign({this.message, this.data});

  HappyHourCampign.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? bgColor;
  int? minAmount;
  List<Rewards>? rewards;
  int? maxApplicable;
  bool showHappyHour = false;
  HappyHourType happyHourType = HappyHourType.expired;
  PreBuzz? preBuzz;
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
      required this.happyHourType,
      this.bgColor = '#495DB2',
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
        rewards!.add(new Rewards.fromJson(v));
      });
    }
    preBuzz = PreBuzz.fromJson(json['prebuzz']);
    maxApplicable = json['maxApplicable'];
    bgColor = json['bgColor'] ?? '#495DB2';
    final date = DateTime.now();
    final _startDate = DateTime.parse(startTime!);
    final _endTime = DateTime.parse(endTime!);
    showHappyHour = date.isAfter(_startDate) && date.isBefore(_endTime);
    getType(_startDate, _endTime);
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
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
