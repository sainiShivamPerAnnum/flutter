import 'package:felloapp/base_util.dart';
import 'package:intl/intl.dart';

class CodeFromFreq {
  static String getCodeFromFreq(String freq) {
    final DateTime _currentTime = DateTime.now();
    final monthlyFormat = new DateFormat('yyyy-MM');
    String response = monthlyFormat.format(_currentTime);

    if (freq == 'weekly' || freq == 'daily') {
      int weekcode = BaseUtil.getWeekNumber();
      response += "-$weekcode";
      if (freq == 'daily') {
        final dailyFormat = new DateFormat('dd');
        response += "-${dailyFormat.format(_currentTime)}";
      }
    }
    return response;
  }

  static int getYearWeekCode() {
    final DateTime _currentTime = DateTime.now();
    final int currentYear = _currentTime.year;
    final int weekcode = BaseUtil.getWeekNumber();

    final response = currentYear * 100 + weekcode;
    return response;
  }
}
