// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your savings and gaming app`
  String get splashTagline {
    return Intl.message(
      'Your savings and gaming app',
      name: 'splashTagline',
      desc: '',
      args: [],
    );
  }

  /// `100% safe and secure`
  String get splashSecureText {
    return Intl.message(
      '100% safe and secure',
      name: 'splashSecureText',
      desc: '',
      args: [],
    );
  }

  /// `Connection taking longer than usual`
  String get splashSlowConnection {
    return Intl.message(
      'Connection taking longer than usual',
      name: 'splashSlowConnection',
      desc: '',
      args: [],
    );
  }

  /// `No active internet connection`
  String get splashNoInternet {
    return Intl.message(
      'No active internet connection',
      name: 'splashNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `Enter the phone number`
  String get obEnterMobile {
    return Intl.message(
      'Enter the phone number',
      name: 'obEnterMobile',
      desc: '',
      args: [],
    );
  }

  /// `For verification purposes, an OTP shall be sent to this number.`
  String get obMobileDesc {
    return Intl.message(
      'For verification purposes, an OTP shall be sent to this number.',
      name: 'obMobileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get obMobileLabel {
    return Intl.message(
      'Mobile Number',
      name: 'obMobileLabel',
      desc: '',
      args: [],
    );
  }

  /// `OTP Authentication`
  String get obOtpLabel {
    return Intl.message(
      'OTP Authentication',
      name: 'obOtpLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 6 digit code sent to your mobile number +91 ******{number}`
  String obOtpDesc(Object number) {
    return Intl.message(
      'Please enter the 6 digit code sent to your mobile number +91 ******$number',
      name: 'obOtpDesc',
      desc: '',
      args: [number],
    );
  }

  /// `Didn't get an OTP? `
  String get obDidntGetOtp {
    return Intl.message(
      'Didn\'t get an OTP? ',
      name: 'obDidntGetOtp',
      desc: '',
      args: [],
    );
  }

  /// ` Resend`
  String get obResend {
    return Intl.message(
      ' Resend',
      name: 'obResend',
      desc: '',
      args: [],
    );
  }

  /// `OTP requests exceeded. Please try again in sometime or contact us.`
  String get obOtpTryExceed {
    return Intl.message(
      'OTP requests exceeded. Please try again in sometime or contact us.',
      name: 'obOtpTryExceed',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get obEmailLabel {
    return Intl.message(
      'Email Address',
      name: 'obEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Name as per PAN`
  String get obNameLabel {
    return Intl.message(
      'Name as per PAN',
      name: 'obNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get obGenderLabel {
    return Intl.message(
      'Gender',
      name: 'obGenderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get obDobLabel {
    return Intl.message(
      'Date of Birth',
      name: 'obDobLabel',
      desc: '',
      args: [],
    );
  }

  /// `Ever saved or invested`
  String get obEverInvestedLabel {
    return Intl.message(
      'Ever saved or invested',
      name: 'obEverInvestedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get obEmailHint {
    return Intl.message(
      'Enter your email address',
      name: 'obEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get obNameHint {
    return Intl.message(
      'Enter your full name',
      name: 'obNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Select your gender`
  String get obGenderHint {
    return Intl.message(
      'Select your gender',
      name: 'obGenderHint',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get obGenderMale {
    return Intl.message(
      'Male',
      name: 'obGenderMale',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get obGenderFemale {
    return Intl.message(
      'Female',
      name: 'obGenderFemale',
      desc: '',
      args: [],
    );
  }

  /// `Rather not say`
  String get obGenderOthers {
    return Intl.message(
      'Rather not say',
      name: 'obGenderOthers',
      desc: '',
      args: [],
    );
  }

  /// `Unique username`
  String get obUsernameLabel {
    return Intl.message(
      'Unique username',
      name: 'obUsernameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose a usename`
  String get obUsernameHint {
    return Intl.message(
      'Choose a usename',
      name: 'obUsernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Rules for a valid username`
  String get obUsernameRulesTitle {
    return Intl.message(
      'Rules for a valid username',
      name: 'obUsernameRulesTitle',
      desc: '',
      args: [],
    );
  }

  /// `must be more than 4 and less than 20 letters`
  String get obUsernameRule1 {
    return Intl.message(
      'must be more than 4 and less than 20 letters',
      name: 'obUsernameRule1',
      desc: '',
      args: [],
    );
  }

  /// `only lowercase alphabets, numbers and dot(.) symbols allowed.`
  String get obUsernameRule2 {
    return Intl.message(
      'only lowercase alphabets, numbers and dot(.) symbols allowed.',
      name: 'obUsernameRule2',
      desc: '',
      args: [],
    );
  }

  /// `consecutive dot(.) are not allowed. example: abc..xyz is an invalid username`
  String get obUsernameRule3 {
    return Intl.message(
      'consecutive dot(.) are not allowed. example: abc..xyz is an invalid username',
      name: 'obUsernameRule3',
      desc: '',
      args: [],
    );
  }

  /// `dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames `
  String get obUsernameRule4 {
    return Intl.message(
      'dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames ',
      name: 'obUsernameRule4',
      desc: '',
      args: [],
    );
  }

  /// `Trending Games`
  String get playTrendingGames {
    return Intl.message(
      'Trending Games',
      name: 'playTrendingGames',
      desc: '',
      args: [],
    );
  }

  /// `Finance`
  String get navBarFinance {
    return Intl.message(
      'Finance',
      name: 'navBarFinance',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get navBarPlay {
    return Intl.message(
      'Play',
      name: 'navBarPlay',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get navBarWin {
    return Intl.message(
      'Save',
      name: 'navBarWin',
      desc: '',
      args: [],
    );
  }

  /// `Want more tickets`
  String get navWMT {
    return Intl.message(
      'Want more tickets',
      name: 'navWMT',
      desc: '',
      args: [],
    );
  }

  /// `BUY`
  String get saveBuyButton {
    return Intl.message(
      'BUY',
      name: 'saveBuyButton',
      desc: '',
      args: [],
    );
  }

  /// `SELL`
  String get saveSellButton {
    return Intl.message(
      'SELL',
      name: 'saveSellButton',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile`
  String get abCompleteYourProfile {
    return Intl.message(
      'Complete your profile',
      name: 'abCompleteYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Gaming Name`
  String get abGamingName {
    return Intl.message(
      'Gaming Name',
      name: 'abGamingName',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get abMyProfile {
    return Intl.message(
      'My Profile',
      name: 'abMyProfile',
      desc: '',
      args: [],
    );
  }

  /// `Game based Savings \n & Investments🎉`
  String get onboardTitle {
    return Intl.message(
      'Game based Savings \n & Investments🎉',
      name: 'onboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save or invest ₹100 and get 1 game ticket every Monday`
  String get onboardText1 {
    return Intl.message(
      'Save or invest ₹100 and get 1 game ticket every Monday',
      name: 'onboardText1',
      desc: '',
      args: [],
    );
  }

  /// `Use the tickets to participate in exciting weekly games`
  String get onboardText2 {
    return Intl.message(
      'Use the tickets to participate in exciting weekly games',
      name: 'onboardText2',
      desc: '',
      args: [],
    );
  }

  /// `Your money keeps growing with great returns while you play fun games and win prizes!`
  String get onboardText3 {
    return Intl.message(
      'Your money keeps growing with great returns while you play fun games and win prizes!',
      name: 'onboardText3',
      desc: '',
      args: [],
    );
  }

  /// `GET STARTED`
  String get onboradButton {
    return Intl.message(
      'GET STARTED',
      name: 'onboradButton',
      desc: '',
      args: [],
    );
  }

  /// `*Based on {servingSize} fl. oz serving.`
  String resultsPageFirstDisclaimer(Object servingSize) {
    return Intl.message(
      '*Based on $servingSize fl. oz serving.',
      name: 'resultsPageFirstDisclaimer',
      desc: '',
      args: [servingSize],
    );
  }

  /// `{quantity, plural, one{One serving.} other{{formattedNumber} servings in your system at one time.}}`
  String resultsPageLethalDosageMessage(num quantity, Object formattedNumber) {
    return Intl.plural(
      quantity,
      one: 'One serving.',
      other: '$formattedNumber servings in your system at one time.',
      name: 'resultsPageLethalDosageMessage',
      desc: '',
      args: [quantity, formattedNumber],
    );
  }

  /// `Daily Safe Maximum`
  String get resultsPageSafeDosageTitle {
    return Intl.message(
      'Daily Safe Maximum',
      name: 'resultsPageSafeDosageTitle',
      desc: '',
      args: [],
    );
  }

  /// `{quantity, plural, one{One serving per day.} other{{formattedNumber} servings per day.}}`
  String resultsPageSafeDosageMessage(num quantity, Object formattedNumber) {
    return Intl.plural(
      quantity,
      one: 'One serving per day.',
      other: '$formattedNumber servings per day.',
      name: 'resultsPageSafeDosageMessage',
      desc: '',
      args: [quantity, formattedNumber],
    );
  }

  /// `*Applies to age 18 and over. This calculator does not replace professional medical advice.`
  String get resultsPageSecondDisclaimer {
    return Intl.message(
      '*Applies to age 18 and over. This calculator does not replace professional medical advice.',
      name: 'resultsPageSecondDisclaimer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}