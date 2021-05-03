import 'package:flutter/cupertino.dart';

class IDP {
  static DateTime selectedDate = DateTime.now();
  static TextEditingController panInput = new TextEditingController();
  static TextEditingController name = new TextEditingController();
  static TextEditingController email = new TextEditingController();
  static String occupationChosenValue;
  static String incomeChosenValue;
  static String exposureChosenValue;
  static String acctTypeChosenValue;
  static String otpChannels;
  static TextEditingController accNo = new TextEditingController();
  static TextEditingController cnfAccNo = new TextEditingController();
  static TextEditingController ifsc = new TextEditingController();
  static TextEditingController otpInput = new TextEditingController();
  static List<Map<String, String>> userAcctTypes = new List();
}
