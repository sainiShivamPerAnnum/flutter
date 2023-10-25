import 'package:felloapp/base_util.dart';
import 'package:intl/intl.dart';

class CodeFromFreq {
  static String getCodeFromFreq(
    String? freq,
  ) {
    final DateTime _currentTime =
        (freq == 'weekly') ? getCorrectedMondayDate() : DateTime.now();
    final monthlyFormat = DateFormat('yyyy-MM');
    String response = monthlyFormat.format(_currentTime);

    if (freq == 'weekly' || freq == 'daily') {
      int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);
      response += "-$weekcode";
      if (freq == 'daily') {
        final dailyFormat = DateFormat('dd');
        response += "-${dailyFormat.format(DateTime.now())}";
      }
    }
    return response;
  }

  static int getYearWeekCode() {
    final DateTime _currentTime = getCorrectedMondayDate();
    final int currentYear = _currentTime.year;
    final int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);

    final response = currentYear * 100 + weekcode;
    return response;
  }

  // Get corrected Date
  static DateTime getCorrectedMondayDate() {
    final DateTime _currentDate = DateTime.now();
    DateTime _correctedDate;
    if (_currentDate.weekday > 1) {
      _correctedDate = DateTime(_currentDate.year, _currentDate.month,
          _currentDate.day - (_currentDate.weekday - 1));
    } else {
      _correctedDate = _currentDate;
    }
    return _correctedDate;
  }

  static getPastEventCodeFromFreq(String freq) {
    switch (freq) {
      case "daily":
        return getPastDayCode();
        break;
      case "weekly":
        return getPastWeekCode();
        break;
      case "monthly":
        return getPastMonthCode();
        break;
    }
  }

  static getPastDayCode() {
    DateTime _currentTime = DateTime.now().subtract(const Duration(days: 1));

    final yearFormat = DateFormat('yyyy');
    final monthFormat = DateFormat('MM');
    final dayFormat = DateFormat('dd');

    int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);

    return "${yearFormat.format(_currentTime)}-${monthFormat.format(_currentTime)}-$weekcode-${dayFormat.format(_currentTime)}";
  }

  static getPastWeekCode() {
    DateTime _currentTime =
        getCorrectedMondayDate().subtract(const Duration(days: 7));

    final yearFormat = DateFormat('yyyy');
    final monthFormat = DateFormat('MM');
    int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);

    return "${yearFormat.format(_currentTime)}-${monthFormat.format(_currentTime)}-$weekcode";
  }

  static getPastMonthCode() {
    DateTime _currentTime = DateTime.now();
    String code = "";
    if (_currentTime.month == 1) {
      code = "${_currentTime.year - 1}-12";
      return code;
    } else {
      return "${_currentTime.year}-${(_currentTime.month - 1).toString().padLeft(2, '0')}";
    }
  }

  static getDayFromCode(String code) {
    List<String> _de = code.split('-');
    int year = int.tryParse(_de[0])!;
    int month = int.tryParse(_de[1])!;
    int day = int.tryParse(_de[3])!;
    final dateTime = DateTime(year, month, day);
    return DateFormat.yMMMd().format(dateTime);
  }

  static getWeekFromCode(String code) {
    List<String> _de = code.split('-');
    int year = int.tryParse(_de[0])!;
    int weeknumber = int.tryParse(_de[2])!;

    final startDateTime =
        getDateByWeekNumber(start: true, year: year, weeknumber: weeknumber);
    final endDateTime =
        getDateByWeekNumber(start: false, year: year, weeknumber: weeknumber);
    return "${DateFormat.yMMMd().format(startDateTime)} - ${DateFormat.yMMMd().format(endDateTime)}";
  }

  static getMonthFromCode(String code) {
    List<String> _de = code.split('-');
    int year = int.tryParse(_de[0])!;
    int month = int.tryParse(_de[1])!;

    final dateTime = DateTime(year, month);
    return DateFormat.yMMM().format(dateTime);
  }

  static DateTime getDateByWeekNumber(
      {required int weeknumber, required int year, required bool start}) {
    //check if start == true retrun start date of week
    //else return end date
    var days = weeknumber * 7;

    DateTime tempDate = DateTime.utc(year, 1, days);
    if (tempDate.weekday > 1) {
      tempDate = DateTime(
          tempDate.year, tempDate.month, tempDate.day - (tempDate.weekday - 1));
    }
    final correctedDate =
        start ? tempDate : tempDate.add(const Duration(days: 6));
    return correctedDate;
  }
}
