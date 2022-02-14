import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:intl/intl.dart';

class CodeFromFreq {
  static String getCodeFromFreq(String freq, {isMondayCorrected = true}) {
    final DateTime _currentTime = getCorrectedMondayDate();
    final monthlyFormat = new DateFormat('yyyy-MM');
    String response = monthlyFormat.format(_currentTime);

    if (freq == 'weekly' || freq == 'daily') {
      int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);
      response += "-$weekcode";
      if (freq == 'daily') {
        final dailyFormat = new DateFormat('dd');
        if (isMondayCorrected)
          response += "-${dailyFormat.format(_currentTime)}";
        else
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
    DateTime _currentTime = DateTime.now().subtract(Duration(days: 1));

    final yearFormat = new DateFormat('yyyy');
    final monthFormat = new DateFormat('MM');
    final dayFormat = new DateFormat('dd');

    int weekcode = BaseUtil.getWeekNumber(currentDate: _currentTime);

    return "${yearFormat.format(_currentTime)}-${monthFormat.format(_currentTime)}-$weekcode-${dayFormat.format(_currentTime)}";
  }

  static getPastWeekCode() {
    DateTime _currentTime = DateTime.now().subtract(Duration(days: 7));

    final yearFormat = new DateFormat('yyyy');
    final monthFormat = new DateFormat('MM');
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
}
