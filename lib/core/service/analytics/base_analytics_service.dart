import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:intl/intl.dart';

abstract class BaseAnalyticsService {
  Future<void> login({bool isOnboarded, BaseUser baseUser});

  void signOut();

  void track({String eventName, Map<String, dynamic> properties});

  void trackScreen({String screen, Map<String, dynamic> properties});

  String getSignupDate(Timestamp signupDate) {
    if (signupDate == null) signupDate = Timestamp.now();
    try {
      return DateFormat('yyyy-MM-dd').format(signupDate.toDate());
    } catch (e) {
      return '';
    }
  }

  int getAge(String dob, CustomLogger logger) {
    if (dob == null || dob.isEmpty) return 0;
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      int month1 = currentDate.month;
      int month2 = birthDate.month;
      if (month2 > month1) {
        age--;
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          age--;
        }
      }
      return age;
    } catch (e) {
      logger.e('$e');
      return 0;
    }
  }
}
