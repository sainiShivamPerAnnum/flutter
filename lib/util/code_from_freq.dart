import 'package:intl/intl.dart';

class CodeFromFreq {
  static String getCodeFromFreq(String freq) {
    final DateTime _currentTime = getCorrectedMondayDate();
    final monthlyFormat = new DateFormat('yyyy-MM');
    String response = monthlyFormat.format(_currentTime);

    if (freq == 'weekly' || freq == 'daily') {
      int weekcode = getWeekNumber(_currentTime);
      response += "-$weekcode";
      if (freq == 'daily') {
        final dailyFormat = new DateFormat('dd');
        response += "-${dailyFormat.format(_currentTime)}";
      }
    }
    return response;
  }

  static int getYearWeekCode() {
    final DateTime _currentTime = getCorrectedMondayDate();
    final int currentYear = _currentTime.year;
    final int weekcode = getWeekNumber(_currentTime);

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

  //Add getWeekNumber method here..
  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
