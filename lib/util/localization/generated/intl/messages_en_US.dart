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

  static m0(version) => "Version ${version}";

  static m1(number) => "Please enter the 6 digit code sent to your mobile number +91 ******${number}";

  static m2(servingSize) => "*Based on ${servingSize} fl. oz serving.";

  static m3(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving.', other: '${formattedNumber} servings in your system at one time.')}";

  static m4(quantity, formattedNumber) => "${Intl.plural(quantity, one: 'One serving per day.', other: '${formattedNumber} servings per day.')}";

  static m5(goldAmount) => "${goldAmount} gm";

  static m6(winningsAmout) => "₹ ${winningsAmout}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "abBuyDigitalGold" : MessageLookupByLibrary.simpleMessage("Buy Digital Gold"),
    "abCompleteYourProfile" : MessageLookupByLibrary.simpleMessage("Complete your profile"),
    "abGamingName" : MessageLookupByLibrary.simpleMessage("Gaming Name"),
    "abMyProfile" : MessageLookupByLibrary.simpleMessage("My Profile"),
    "abNotifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "app_version" : m0,
    "btnEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "btnNo" : MessageLookupByLibrary.simpleMessage("No"),
    "btnSave" : MessageLookupByLibrary.simpleMessage("Save"),
    "btnSumbit" : MessageLookupByLibrary.simpleMessage("Submit"),
    "btnUpdate" : MessageLookupByLibrary.simpleMessage("Update"),
    "btnYes" : MessageLookupByLibrary.simpleMessage("Yes"),
    "dAbtDigGold" : MessageLookupByLibrary.simpleMessage("About Digital Gold"),
    "dPanNkyc" : MessageLookupByLibrary.simpleMessage("PAN & KYC"),
    "dReferNEarn" : MessageLookupByLibrary.simpleMessage("Refer and Earn"),
    "dTransactions" : MessageLookupByLibrary.simpleMessage("Transactions"),
    "dhowitworks" : MessageLookupByLibrary.simpleMessage("How it works?"),
    "kycNameLabel" : MessageLookupByLibrary.simpleMessage("Name as per your PAN Card"),
    "navBarFinance" : MessageLookupByLibrary.simpleMessage("Save"),
    "navBarPlay" : MessageLookupByLibrary.simpleMessage("Play"),
    "navBarSave" : MessageLookupByLibrary.simpleMessage("Save"),
    "navBarWin" : MessageLookupByLibrary.simpleMessage("Win"),
    "navWMT" : MessageLookupByLibrary.simpleMessage("Earn more tokens"),
    "noTransaction" : MessageLookupByLibrary.simpleMessage("No transactions to show yet"),
    "obBlockedAb" : MessageLookupByLibrary.simpleMessage("Account Activity"),
    "obBlockedSubtitle1" : MessageLookupByLibrary.simpleMessage("Your Fello Account has been banned for activity that violates our "),
    "obBlockedTitle" : MessageLookupByLibrary.simpleMessage("Your Account has been blocked"),
    "obDidntGetOtp" : MessageLookupByLibrary.simpleMessage("Didn\'t get an OTP? "),
    "obDobLabel" : MessageLookupByLibrary.simpleMessage("Date of Birth"),
    "obEmailHint" : MessageLookupByLibrary.simpleMessage("Enter your email address"),
    "obEmailLabel" : MessageLookupByLibrary.simpleMessage("Email Address"),
    "obEnterMobile" : MessageLookupByLibrary.simpleMessage("Enter your phone number"),
    "obEverInvestedLabel" : MessageLookupByLibrary.simpleMessage("Ever saved or invested"),
    "obGenderFemale" : MessageLookupByLibrary.simpleMessage("Female"),
    "obGenderHint" : MessageLookupByLibrary.simpleMessage("Select your gender"),
    "obGenderLabel" : MessageLookupByLibrary.simpleMessage("Gender"),
    "obGenderMale" : MessageLookupByLibrary.simpleMessage("Male"),
    "obGenderOthers" : MessageLookupByLibrary.simpleMessage("Rather not say"),
    "obMobileDesc" : MessageLookupByLibrary.simpleMessage("For verification purposes, an OTP will be sent to this number."),
    "obMobileLabel" : MessageLookupByLibrary.simpleMessage("Mobile Number"),
    "obNameHint" : MessageLookupByLibrary.simpleMessage("Enter your full name"),
    "obNameLabel" : MessageLookupByLibrary.simpleMessage("Name"),
    "obOtpDesc" : m1,
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
    "pkPanLabel" : MessageLookupByLibrary.simpleMessage("PAN Number"),
    "pkStateHint" : MessageLookupByLibrary.simpleMessage("Which state do you live in?"),
    "pkStateLabel" : MessageLookupByLibrary.simpleMessage("State"),
    "playTrendingGames" : MessageLookupByLibrary.simpleMessage("Trending Games"),
    "refHIW" : MessageLookupByLibrary.simpleMessage("How it works?"),
    "refShareLink" : MessageLookupByLibrary.simpleMessage("Share Link"),
    "refStep2" : MessageLookupByLibrary.simpleMessage("Your friend makes their first saving of ₹ 100 on the app."),
    "refStep3" : MessageLookupByLibrary.simpleMessage("Both you and your friend receive ₹ 25 and 200 Fello tokens in your account."),
    "refWhatsapp" : MessageLookupByLibrary.simpleMessage("WhatsApp"),
    "refstep1" : MessageLookupByLibrary.simpleMessage("Your friend installs Fello and signs up using your referral link or referral code."),
    "refsubtitle" : MessageLookupByLibrary.simpleMessage("Earn ₹ 25 and 200 Fello tokens for every referral and referrer of the month will get a brand new iphone 13"),
    "resultsPageFirstDisclaimer" : m2,
    "resultsPageLethalDosageMessage" : m3,
    "resultsPageSafeDosageMessage" : m4,
    "resultsPageSafeDosageTitle" : MessageLookupByLibrary.simpleMessage("Daily Safe Maximum"),
    "resultsPageSecondDisclaimer" : MessageLookupByLibrary.simpleMessage("*Applies to age 18 and over. This calculator does not replace professional medical advice."),
    "saveBaseline" : MessageLookupByLibrary.simpleMessage("You get 1 token for every Rupee saved"),
    "saveBuyButton" : MessageLookupByLibrary.simpleMessage("BUY"),
    "saveGold24k" : MessageLookupByLibrary.simpleMessage("24K"),
    "saveGoldBalanceValue" : m5,
    "saveGoldBalancelabel" : MessageLookupByLibrary.simpleMessage("My Gold Balance:"),
    "saveGoldPure" : MessageLookupByLibrary.simpleMessage("99.99% Pure"),
    "saveHistory" : MessageLookupByLibrary.simpleMessage("History"),
    "saveSecure" : MessageLookupByLibrary.simpleMessage("100% secure"),
    "saveSellButton" : MessageLookupByLibrary.simpleMessage("SELL"),
    "saveViewAll" : MessageLookupByLibrary.simpleMessage("View All"),
    "saveWinningsLabel" : MessageLookupByLibrary.simpleMessage("My Total Winnings"),
    "saveWinningsValue" : m6,
    "signout" : MessageLookupByLibrary.simpleMessage("Sign Out"),
    "splashNoInternet" : MessageLookupByLibrary.simpleMessage("No active internet connection"),
    "splashSecureText" : MessageLookupByLibrary.simpleMessage("🔒 safe and secure"),
    "splashSlowConnection" : MessageLookupByLibrary.simpleMessage("Connection taking longer than usual"),
    "splashTagline" : MessageLookupByLibrary.simpleMessage("Your savings and gaming app"),
    "tLossSubtitle" : MessageLookupByLibrary.simpleMessage("None of your tickets matched this week"),
    "tLossSubtitle2" : MessageLookupByLibrary.simpleMessage("Get ready for next week tambola from now on."),
    "tLossTitle" : MessageLookupByLibrary.simpleMessage("Tambola Results"),
    "tParWinTitle" : MessageLookupByLibrary.simpleMessage("Tambola Results"),
    "tParWinsubtitle" : MessageLookupByLibrary.simpleMessage("Only users with minimun savings balance of ₹ 100 are eliglble for prizes"),
    "tProcessingSubtitle" : MessageLookupByLibrary.simpleMessage("We are processing your tickets to see if any of your tickets has won a category.."),
    "tProcessingTitle" : MessageLookupByLibrary.simpleMessage("Prize Day"),
    "tWinSubtitle" : MessageLookupByLibrary.simpleMessage("Your tickets have been submitted\nfor processing"),
    "tWinSubtitle2" : MessageLookupByLibrary.simpleMessage("Prizes will be announced tomorrow. be sure to check put the leaderboard"),
    "tWinTitle" : MessageLookupByLibrary.simpleMessage("CONGRATULATIONS!"),
    "txnBankDetailsLabel" : MessageLookupByLibrary.simpleMessage("Bank Account Details"),
    "txnHistoryLabel" : MessageLookupByLibrary.simpleMessage("Transaction History"),
    "winIphoneBigText" : MessageLookupByLibrary.simpleMessage("friends and win iphone 13"),
    "winIphoneSmallText" : MessageLookupByLibrary.simpleMessage("Refer"),
    "winMoneyBigText" : MessageLookupByLibrary.simpleMessage("₹ 1 Lakh every week"),
    "winMoneySmallText" : MessageLookupByLibrary.simpleMessage("Play and win"),
    "winMyWinnings" : MessageLookupByLibrary.simpleMessage("My Winnings")
  };
}
