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

  static m0(servingSize) => "*Based on ${servingSize} fl. oz serving.";

  static m1(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving.', other: '${formattedNumber} servings in your system at one time.')}";

  static m2(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving per day.', other: '${formattedNumber} servings per day.')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "navBarFinance" : MessageLookupByLibrary.simpleMessage("Finance"),
    "navBarPlay" : MessageLookupByLibrary.simpleMessage("Play"),
    "navBarWin" : MessageLookupByLibrary.simpleMessage("Save"),
    "navWMT" : MessageLookupByLibrary.simpleMessage("Want more tickets"),
    "onboardText1" : MessageLookupByLibrary.simpleMessage("Save or invest ₹100 and get 1 game ticket every Monday"),
    "onboardText2" : MessageLookupByLibrary.simpleMessage("Use the tickets to participate in exciting weekly games"),
    "onboardText3" : MessageLookupByLibrary.simpleMessage("Your money keeps growing with great returns while you play fun games and win prizes!"),
    "onboardTitle" : MessageLookupByLibrary.simpleMessage("Game based Savings \n & Investments🎉"),
    "onboradButton" : MessageLookupByLibrary.simpleMessage("GET STARTED"),
    "playTrendingGames" : MessageLookupByLibrary.simpleMessage("Trending Games"),
    "profileTitle" : MessageLookupByLibrary.simpleMessage("My Profile"),
    "resultsPageFirstDisclaimer" : m0,
    "resultsPageLethalDosageMessage" : m1,
    "resultsPageSafeDosageMessage" : m2,
    "resultsPageSafeDosageTitle" : MessageLookupByLibrary.simpleMessage("Daily Safe Maximum"),
    "resultsPageSecondDisclaimer" : MessageLookupByLibrary.simpleMessage("*Applies to age 18 and over. This calculator does not replace professional medical advice."),
    "splashNoInternet" : MessageLookupByLibrary.simpleMessage("No active internet connection"),
    "splashSecureText" : MessageLookupByLibrary.simpleMessage("100% safe and secure"),
    "splashSlowConnection" : MessageLookupByLibrary.simpleMessage("Connection taking longer than usual"),
    "splashTagline" : MessageLookupByLibrary.simpleMessage("Your savings and gaming app")
  };
}
