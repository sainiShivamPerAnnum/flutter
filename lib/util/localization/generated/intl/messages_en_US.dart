// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  static m0(number) => "Please enter the 6 digit code sent to your mobile number +91 ******${number}";

  static m1(servingSize) => "*Based on ${servingSize} fl. oz serving.";

  static m2(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving.', other: '${formattedNumber} servings in your system at one time.')}";

  static m3(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving per day.', other: '${formattedNumber} servings per day.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "abCompleteYourProfile" : MessageLookupByLibrary.simpleMessage("Complete your profile"),
    "abGamingName" : MessageLookupByLibrary.simpleMessage("Gaming Name"),
    "abMyProfile" : MessageLookupByLibrary.simpleMessage("My Profile"),
    "navBarFinance" : MessageLookupByLibrary.simpleMessage("Finance"),
    "navBarPlay" : MessageLookupByLibrary.simpleMessage("Play"),
    "navBarWin" : MessageLookupByLibrary.simpleMessage("Save"),
    "navWMT" : MessageLookupByLibrary.simpleMessage("Want more tickets"),
    "obDidntGetOtp" : MessageLookupByLibrary.simpleMessage("Didn\'t get an OTP? "),
    "obDobLabel" : MessageLookupByLibrary.simpleMessage("Date of Birth"),
    "obEmailHint" : MessageLookupByLibrary.simpleMessage("Enter your email address"),
    "obEmailLabel" : MessageLookupByLibrary.simpleMessage("Email Address"),
    "obEnterMobile" : MessageLookupByLibrary.simpleMessage("Enter the phone number"),
    "obEverInvestedLabel" : MessageLookupByLibrary.simpleMessage("Ever saved or invested"),
    "obGenderFemale" : MessageLookupByLibrary.simpleMessage("Female"),
    "obGenderHint" : MessageLookupByLibrary.simpleMessage("Select your gender"),
    "obGenderLabel" : MessageLookupByLibrary.simpleMessage("Gender"),
    "obGenderMale" : MessageLookupByLibrary.simpleMessage("Male"),
    "obGenderOthers" : MessageLookupByLibrary.simpleMessage("Rather not say"),
    "obMobileDesc" : MessageLookupByLibrary.simpleMessage("For verification purposes, an OTP shall be sent to this number."),
    "obMobileLabel" : MessageLookupByLibrary.simpleMessage("Mobile Number"),
    "obNameHint" : MessageLookupByLibrary.simpleMessage("Enter your full name"),
    "obNameLabel" : MessageLookupByLibrary.simpleMessage("Name"),
    "obOtpDesc" : m0,
    "obOtpLabel" : MessageLookupByLibrary.simpleMessage("OTP Authentication"),
    "obOtpTryExceed" : MessageLookupByLibrary.simpleMessage("OTP requests exceeded. Please try again in sometime or contact us."),
    "obResend" : MessageLookupByLibrary.simpleMessage(" Resend"),
    "obUsernameHint" : MessageLookupByLibrary.simpleMessage("Choose a usename"),
    "obUsernameLabel" : MessageLookupByLibrary.simpleMessage("Unique username"),
    "obUsernameRule1" : MessageLookupByLibrary.simpleMessage("must be more than 4 and less than 20 letters"),
    "obUsernameRule2" : MessageLookupByLibrary.simpleMessage("only lowercase alphabets, numbers and dot(.) symbols allowed."),
    "obUsernameRule3" : MessageLookupByLibrary.simpleMessage("consecutive dot(.) are not allowed. example: abc..xyz is an invalid username"),
    "obUsernameRule4" : MessageLookupByLibrary.simpleMessage("dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames "),
    "obUsernameRulesTitle" : MessageLookupByLibrary.simpleMessage("Rules for a valid username"),
    "onboardText1" : MessageLookupByLibrary.simpleMessage("Save or invest ₹100 and get 1 game ticket every Monday"),
    "onboardText2" : MessageLookupByLibrary.simpleMessage("Use the tickets to participate in exciting weekly games"),
    "onboardText3" : MessageLookupByLibrary.simpleMessage("Your money keeps growing with great returns while you play fun games and win prizes!"),
    "onboardTitle" : MessageLookupByLibrary.simpleMessage("Game based Savings \n & Investments🎉"),
    "onboradButton" : MessageLookupByLibrary.simpleMessage("GET STARTED"),
    "playTrendingGames" : MessageLookupByLibrary.simpleMessage("Trending Games"),
    "resultsPageFirstDisclaimer" : m1,
    "resultsPageLethalDosageMessage" : m2,
    "resultsPageSafeDosageMessage" : m3,
    "resultsPageSafeDosageTitle" : MessageLookupByLibrary.simpleMessage("Daily Safe Maximum"),
    "resultsPageSecondDisclaimer" : MessageLookupByLibrary.simpleMessage("*Applies to age 18 and over. This calculator does not replace professional medical advice."),
    "saveBuyButton" : MessageLookupByLibrary.simpleMessage("BUY"),
    "saveSellButton" : MessageLookupByLibrary.simpleMessage("SELL"),
    "splashNoInternet" : MessageLookupByLibrary.simpleMessage("No active internet connection"),
    "splashSecureText" : MessageLookupByLibrary.simpleMessage("100% safe and secure"),
    "splashSlowConnection" : MessageLookupByLibrary.simpleMessage("Connection taking longer than usual"),
    "splashTagline" : MessageLookupByLibrary.simpleMessage("Your savings and gaming app")
  };
}
