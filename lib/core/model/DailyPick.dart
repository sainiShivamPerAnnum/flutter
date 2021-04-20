import 'package:felloapp/util/logger.dart';

class DailyPick {
  static Log log = new Log('DailyPick');
  List<int> mon;
  List<int> tue;
  List<int> wed;
  List<int> thu;
  List<int> fri;
  List<int> sat;
  List<int> sun;
  int weekCode;

  static final fldWeekDay = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  static final fldWeekCode = 'weekCde';

  DailyPick(
      {this.weekCode,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.sun});

  DailyPick.fromMap(Map<String, dynamic> data)
      : this(
          weekCode: data[fldWeekCode],
          mon: (data[fldWeekDay[0]] != null)
              ? List.from(data[fldWeekDay[0]])
              : null,
          tue: (data[fldWeekDay[1]] != null)
              ? List.from(data[fldWeekDay[1]])
              : null,
          wed: (data[fldWeekDay[2]] != null)
              ? List.from(data[fldWeekDay[2]])
              : null,
          thu: (data[fldWeekDay[3]] != null)
              ? List.from(data[fldWeekDay[3]])
              : null,
          fri: (data[fldWeekDay[4]] != null)
              ? List.from(data[fldWeekDay[4]])
              : null,
          sat: (data[fldWeekDay[5]] != null)
              ? List.from(data[fldWeekDay[5]])
              : null,
          sun: (data[fldWeekDay[6]] != null)
              ? List.from(data[fldWeekDay[6]])
              : null,
        );

  List<int> getWeekdayDraws(int weekday) {
    switch (weekday) {
      case 0:
        return mon;
      case 1:
        return tue;
      case 2:
        return wed;
      case 3:
        return thu;
      case 4:
        return fri;
      case 5:
        return sat;
      case 6:
        return sun;
    }
  }

  List<int> toList() {
    List<int> allDigits = [];
    if (mon != null && mon.isNotEmpty) allDigits.addAll(mon);
    if (tue != null && tue.isNotEmpty) allDigits.addAll(tue);
    if (wed != null && wed.isNotEmpty) allDigits.addAll(wed);
    if (thu != null && thu.isNotEmpty) allDigits.addAll(thu);
    if (fri != null && fri.isNotEmpty) allDigits.addAll(fri);
    if (sat != null && sat.isNotEmpty) allDigits.addAll(sat);
    if (sun != null && sun.isNotEmpty) allDigits.addAll(sun);

    return allDigits;
  }

  ///returns the picks after the daycode
  ///if dayCode = 4, return picks from thu,fri,sat,sun
  List<int> getPicksPostDate(int dayCode) {
    List<int> relevantDigits = [];
    if (mon != null && mon.isNotEmpty && dayCode == DateTime.monday)
      relevantDigits.addAll(mon);
    if (tue != null && tue.isNotEmpty && dayCode <= DateTime.tuesday)
      relevantDigits.addAll(tue);
    if (wed != null && wed.isNotEmpty && dayCode <= DateTime.wednesday)
      relevantDigits.addAll(wed);
    if (thu != null && thu.isNotEmpty && dayCode <= DateTime.thursday)
      relevantDigits.addAll(thu);
    if (fri != null && fri.isNotEmpty && dayCode <= DateTime.friday)
      relevantDigits.addAll(fri);
    if (sat != null && sat.isNotEmpty && dayCode <= DateTime.saturday)
      relevantDigits.addAll(sat);
    if (sun != null && sun.isNotEmpty && dayCode <= DateTime.sunday)
      relevantDigits.addAll(sun);

    return relevantDigits;
  }
}
