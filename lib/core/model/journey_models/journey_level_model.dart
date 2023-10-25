import 'package:felloapp/core/model/helper_model.dart';

class JourneyLevel {
  int? start;
  int? end;
  double? breakpoint;
  int? pageEnd;
  int? level;

  JourneyLevel(
      {this.start, this.end, this.breakpoint, this.pageEnd, this.level});

  static final helper =
      HelperModel<JourneyLevel>((map) => JourneyLevel.fromMap(map));

  JourneyLevel.fromMap(Map<String, dynamic> map) {
    start = map['start'];
    end = map['end'];
    breakpoint = map['breakpoint'].toDouble();
    pageEnd = map['pageEnd'];
    level = map['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    data['breakpoint'] = breakpoint;
    data['pageEnd'] = pageEnd;
    data['level'] = level;
    return data;
  }

  @override
  String toString() {
    return "start: $start end: $end breakPoint: $breakpoint pageEnd: $pageEnd level: $level";
  }
}
