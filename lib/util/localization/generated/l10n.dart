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

  /// `🔒 safe and secure`
  String get splashSecureText {
    return Intl.message(
      '🔒 safe and secure',
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

  // skipped getter for the '----------------------------------' key

  /// `Enter your phone number`
  String get obEnterMobile {
    return Intl.message(
      'Enter your phone number',
      name: 'obEnterMobile',
      desc: '',
      args: [],
    );
  }

  /// `For verification purposes, an OTP will be sent to this number.`
  String get obMobileDesc {
    return Intl.message(
      'For verification purposes, an OTP will be sent to this number.',
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

  /// `Name`
  String get obNameLabel {
    return Intl.message(
      'Name',
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

  /// `Account Activity`
  String get obBlockedAb {
    return Intl.message(
      'Account Activity',
      name: 'obBlockedAb',
      desc: '',
      args: [],
    );
  }

  /// `Your Account has been blocked`
  String get obBlockedTitle {
    return Intl.message(
      'Your Account has been blocked',
      name: 'obBlockedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Fello Account has been banned for activity that violates our `
  String get obBlockedSubtitle1 {
    return Intl.message(
      'Your Fello Account has been banned for activity that violates our ',
      name: 'obBlockedSubtitle1',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-----------------------------------' key

  /// `Save`
  String get navBarFinance {
    return Intl.message(
      'Save',
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
  String get navBarSave {
    return Intl.message(
      'Save',
      name: 'navBarSave',
      desc: '',
      args: [],
    );
  }

  /// `Win`
  String get navBarWin {
    return Intl.message(
      'Win',
      name: 'navBarWin',
      desc: '',
      args: [],
    );
  }

  /// `Earn more tokens`
  String get navWMT {
    return Intl.message(
      'Earn more tokens',
      name: 'navWMT',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '------------------------------------' key

  /// `Trending Games`
  String get playTrendingGames {
    return Intl.message(
      'Trending Games',
      name: 'playTrendingGames',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-------------------------------------' key

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

  /// `My Gold Balance:`
  String get saveGoldBalancelabel {
    return Intl.message(
      'My Gold Balance:',
      name: 'saveGoldBalancelabel',
      desc: '',
      args: [],
    );
  }

  /// `{goldAmount} gm`
  String saveGoldBalanceValue(Object goldAmount) {
    return Intl.message(
      '$goldAmount gm',
      name: 'saveGoldBalanceValue',
      desc: '',
      args: [goldAmount],
    );
  }

  /// `100% secure`
  String get saveSecure {
    return Intl.message(
      '100% secure',
      name: 'saveSecure',
      desc: '',
      args: [],
    );
  }

  /// `You get 1 token for every Rupee saved`
  String get saveBaseline {
    return Intl.message(
      'You get 1 token for every Rupee saved',
      name: 'saveBaseline',
      desc: '',
      args: [],
    );
  }

  /// `My Total Winnings`
  String get saveWinningsLabel {
    return Intl.message(
      'My Total Winnings',
      name: 'saveWinningsLabel',
      desc: '',
      args: [],
    );
  }

  /// `₹ {winningsAmout}`
  String saveWinningsValue(Object winningsAmout) {
    return Intl.message(
      '₹ $winningsAmout',
      name: 'saveWinningsValue',
      desc: '',
      args: [winningsAmout],
    );
  }

  /// `History`
  String get saveHistory {
    return Intl.message(
      'History',
      name: 'saveHistory',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get saveViewAll {
    return Intl.message(
      'View All',
      name: 'saveViewAll',
      desc: '',
      args: [],
    );
  }

  /// `24K`
  String get saveGold24k {
    return Intl.message(
      '24K',
      name: 'saveGold24k',
      desc: '',
      args: [],
    );
  }

  /// `99.99% Pure`
  String get saveGoldPure {
    return Intl.message(
      '99.99% Pure',
      name: 'saveGoldPure',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------------' key

  /// `My Winnings`
  String get winMyWinnings {
    return Intl.message(
      'My Winnings',
      name: 'winMyWinnings',
      desc: '',
      args: [],
    );
  }

  /// `Play and win`
  String get winMoneySmallText {
    return Intl.message(
      'Play and win',
      name: 'winMoneySmallText',
      desc: '',
      args: [],
    );
  }

  /// `₹ 1 Lakh every week`
  String get winMoneyBigText {
    return Intl.message(
      '₹ 1 Lakh every week',
      name: 'winMoneyBigText',
      desc: '',
      args: [],
    );
  }

  /// `Refer`
  String get winIphoneSmallText {
    return Intl.message(
      'Refer',
      name: 'winIphoneSmallText',
      desc: '',
      args: [],
    );
  }

  /// `friends and win iphone 13`
  String get winIphoneBigText {
    return Intl.message(
      'friends and win iphone 13',
      name: 'winIphoneBigText',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '----------------------------' key

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

  /// `Notifications`
  String get abNotifications {
    return Intl.message(
      'Notifications',
      name: 'abNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Buy Digital Gold`
  String get abBuyDigitalGold {
    return Intl.message(
      'Buy Digital Gold',
      name: 'abBuyDigitalGold',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-------------------------------' key

  /// `Refer and Earn`
  String get dReferNEarn {
    return Intl.message(
      'Refer and Earn',
      name: 'dReferNEarn',
      desc: '',
      args: [],
    );
  }

  /// `PAN & KYC`
  String get dPanNkyc {
    return Intl.message(
      'PAN & KYC',
      name: 'dPanNkyc',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get dTransactions {
    return Intl.message(
      'Transactions',
      name: 'dTransactions',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'dHelp&sprt' key

  /// `How it works?`
  String get dhowitworks {
    return Intl.message(
      'How it works?',
      name: 'dhowitworks',
      desc: '',
      args: [],
    );
  }

  /// `About Digital Gold`
  String get dAbtDigGold {
    return Intl.message(
      'About Digital Gold',
      name: 'dAbtDigGold',
      desc: '',
      args: [],
    );
  }

  /// `Version {version}`
  String app_version(Object version) {
    return Intl.message(
      'Version $version',
      name: 'app_version',
      desc: '',
      args: [version],
    );
  }

  // skipped getter for the '-------------------------' key

  /// `Earn ₹ 25 and 200 Fello tokens for every referral and referrer of the month will get a brand new iphone 13`
  String get refsubtitle {
    return Intl.message(
      'Earn ₹ 25 and 200 Fello tokens for every referral and referrer of the month will get a brand new iphone 13',
      name: 'refsubtitle',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get refWhatsapp {
    return Intl.message(
      'WhatsApp',
      name: 'refWhatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Share Link`
  String get refShareLink {
    return Intl.message(
      'Share Link',
      name: 'refShareLink',
      desc: '',
      args: [],
    );
  }

  /// `How it works?`
  String get refHIW {
    return Intl.message(
      'How it works?',
      name: 'refHIW',
      desc: '',
      args: [],
    );
  }

  /// `Your friend installs Fello and signs up using your referral link or referral code.`
  String get refstep1 {
    return Intl.message(
      'Your friend installs Fello and signs up using your referral link or referral code.',
      name: 'refstep1',
      desc: '',
      args: [],
    );
  }

  /// `Your friend makes their first saving of ₹ 100 on the app.`
  String get refStep2 {
    return Intl.message(
      'Your friend makes their first saving of ₹ 100 on the app.',
      name: 'refStep2',
      desc: '',
      args: [],
    );
  }

  /// `Both you and your friend receive ₹ 25 and 200 Fello tokens in your account.`
  String get refStep3 {
    return Intl.message(
      'Both you and your friend receive ₹ 25 and 200 Fello tokens in your account.',
      name: 'refStep3',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------' key

  /// `PAN Number`
  String get pkPanLabel {
    return Intl.message(
      'PAN Number',
      name: 'pkPanLabel',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get pkStateLabel {
    return Intl.message(
      'State',
      name: 'pkStateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Which state do you live in?`
  String get pkStateHint {
    return Intl.message(
      'Which state do you live in?',
      name: 'pkStateHint',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '------------------------------' key

  /// `Bank Account Details`
  String get txnBankDetailsLabel {
    return Intl.message(
      'Bank Account Details',
      name: 'txnBankDetailsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get txnHistoryLabel {
    return Intl.message(
      'Transaction History',
      name: 'txnHistoryLabel',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-----------------------------' key

  /// `Submit`
  String get btnSumbit {
    return Intl.message(
      'Submit',
      name: 'btnSumbit',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get btnYes {
    return Intl.message(
      'Yes',
      name: 'btnYes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get btnNo {
    return Intl.message(
      'No',
      name: 'btnNo',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get btnSave {
    return Intl.message(
      'Save',
      name: 'btnSave',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get btnUpdate {
    return Intl.message(
      'Update',
      name: 'btnUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get btnEdit {
    return Intl.message(
      'Edit',
      name: 'btnEdit',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '------------------' key

  /// `Name as per your PAN Card`
  String get kycNameLabel {
    return Intl.message(
      'Name as per your PAN Card',
      name: 'kycNameLabel',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '----------------------' key

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

  // skipped getter for the '-----------------------' key

  /// `Prize Day`
  String get tProcessingTitle {
    return Intl.message(
      'Prize Day',
      name: 'tProcessingTitle',
      desc: '',
      args: [],
    );
  }

  /// `We are processing your tickets to see if any of your tickets has won a category..`
  String get tProcessingSubtitle {
    return Intl.message(
      'We are processing your tickets to see if any of your tickets has won a category..',
      name: 'tProcessingSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Tambola Results`
  String get tLossTitle {
    return Intl.message(
      'Tambola Results',
      name: 'tLossTitle',
      desc: '',
      args: [],
    );
  }

  /// `None of your tickets matched this week`
  String get tLossSubtitle {
    return Intl.message(
      'None of your tickets matched this week',
      name: 'tLossSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Get ready for next week tambola from now on.`
  String get tLossSubtitle2 {
    return Intl.message(
      'Get ready for next week tambola from now on.',
      name: 'tLossSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `CONGRATULATIONS!`
  String get tWinTitle {
    return Intl.message(
      'CONGRATULATIONS!',
      name: 'tWinTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your tickets have been submitted\nfor processing`
  String get tWinSubtitle {
    return Intl.message(
      'Your tickets have been submitted\nfor processing',
      name: 'tWinSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Prizes will be announced tomorrow. be sure to check put the leaderboard`
  String get tWinSubtitle2 {
    return Intl.message(
      'Prizes will be announced tomorrow. be sure to check put the leaderboard',
      name: 'tWinSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Tambola Results`
  String get tParWinTitle {
    return Intl.message(
      'Tambola Results',
      name: 'tParWinTitle',
      desc: '',
      args: [],
    );
  }

  /// `Only users with minimun savings balance of ₹ 100 are eliglble for prizes`
  String get tParWinsubtitle {
    return Intl.message(
      'Only users with minimun savings balance of ₹ 100 are eliglble for prizes',
      name: 'tParWinsubtitle',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------------------------' key

  /// `No transactions to show yet`
  String get noTransaction {
    return Intl.message(
      'No transactions to show yet',
      name: 'noTransaction',
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

  /// `Sign Out`
  String get signout {
    return Intl.message(
      'Sign Out',
      name: 'signout',
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