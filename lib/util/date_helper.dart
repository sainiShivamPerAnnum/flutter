import 'dart:developer';

import 'package:intl/intl.dart';

class DateHelper {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    // if (difference.inDays > 8) {
    //   String day = notificationDate.day.toString();
    //   String month = notificationDate.month.toString();
    //   String year = notificationDate.year.toString();
    //   String date = "$day/$month/$year";
    //   return date;
    // } else
    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 w' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} d';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 d' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} h';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 h' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} m';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 m' : 'A minute ago';
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
}
