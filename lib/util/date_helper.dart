import 'dart:developer';

import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static String timeAgoSinceDate(TimestampModel date,
      {bool numericDates = true}) {
    DateTime notificationDate = date.toDate();
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if ((difference.inDays / 7).floor() >= 1) {
      return numericDates ? '1 w' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} d';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 d' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} h';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 h' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} m';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 m' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} s';
    } else {
      return 'now';
    }
  }

  static int timeToWeekendInMinutes() {
    final now = DateTime.now();
    final weekEnd = now.add(Duration(
      hours: 23 - now.hour,
      minutes: 59 - now.minute,
      days: DateTime.daysPerWeek - now.weekday,
    ));

    return weekEnd.difference(now).inMinutes;
  }

  static bool isAdult(DateTime? dt) {
    log("Selected date: ${dt.toString()}");
    if (dt == null) return true;
    // Current time - at this moment
    DateTime today = DateTime.now();
    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      dt.year + 18,
      dt.month,
      dt.day,
    );

    return adultDate.isBefore(today);
  }

  static int getMillisecondsTillNextSixPm() {
    // Get the current date and time
    final currentTime = DateTime.now();

    // Calculate the next 6 PM
    final nextSixPM =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 18, 0);

    // Calculate the duration in milliseconds
    int durationMillis;

    // Check if the current time is before 6 PM
    if (currentTime.isBefore(nextSixPM)) {
      durationMillis =
          nextSixPM.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch;
    } else {
      // Calculate the duration until the next day's 6 PM
      final tomorrowSixPM = nextSixPM.add(const Duration(days: 1));
      durationMillis = tomorrowSixPM.millisecondsSinceEpoch -
          currentTime.millisecondsSinceEpoch;
    }

    print('Duration in milliseconds: $durationMillis');
    return durationMillis;
  }

  static String getDateInHumanReadableFormat(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }
}
