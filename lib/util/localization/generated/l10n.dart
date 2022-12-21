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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
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

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '----------------------------------' key

  /// `Login/Sign up`
  String get obLoginHeading {
    return Intl.message(
      'Login/Sign up',
      name: 'obLoginHeading',
      desc: '',
      args: [],
    );
  }

  /// ` Enter your 10 digit phone number`
  String get obEnterMobile {
    return Intl.message(
      ' Enter your 10 digit phone number',
      name: 'obEnterMobile',
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

  /// `Verify OTP`
  String get obOtpLabel {
    return Intl.message(
      'Verify OTP',
      name: 'obOtpLabel',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive? `
  String get obDidntGetOtp {
    return Intl.message(
      'Didn\'t receive? ',
      name: 'obDidntGetOtp',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get an OTP? Request in `
  String get obOtpRequest {
    return Intl.message(
      'Didn\'t get an OTP? Request in ',
      name: 'obOtpRequest',
      desc: '',
      args: [],
    );
  }

  /// `RESEND`
  String get obResend {
    return Intl.message(
      'RESEND',
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

  /// `Enter Details`
  String get obEnterDetails {
    return Intl.message(
      'Enter Details',
      name: 'obEnterDetails',
      desc: '',
      args: [],
    );
  }

  /// `You're one step away from 10% returns`
  String get obEnterDetailsTitle {
    return Intl.message(
      'You\'re one step away from 10% returns',
      name: 'obEnterDetailsTitle',
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

  /// `Please enter a valid email`
  String get obValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'obValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full name`
  String get obNameHint {
    return Intl.message(
      'Enter Full name',
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

  /// `Please enter your name as per PAN`
  String get obNameAsPerPan {
    return Intl.message(
      'Please enter your name as per PAN',
      name: 'obNameAsPerPan',
      desc: '',
      args: [],
    );
  }

  /// `At least 3 characters required`
  String get obNameRules {
    return Intl.message(
      'At least 3 characters required',
      name: 'obNameRules',
      desc: '',
      args: [],
    );
  }

  /// `We will send you a 6 digit code on this email`
  String get ob6DigitEmailCode {
    return Intl.message(
      'We will send you a 6 digit code on this email',
      name: 'ob6DigitEmailCode',
      desc: '',
      args: [],
    );
  }

  /// `Please check your promotions or spam folders if you can't find the email`
  String get obCheckSpamFolder {
    return Intl.message(
      'Please check your promotions or spam folders if you can\'t find the email',
      name: 'obCheckSpamFolder',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get ObGenderLabel {
    return Intl.message(
      'Gender',
      name: 'ObGenderLabel',
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

  /// `By proceeding, you agree that you are 18 years and older.`
  String get obIsOlder {
    return Intl.message(
      'By proceeding, you agree that you are 18 years and older.',
      name: 'obIsOlder',
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

  /// `Date field cannot be empty`
  String get obDateFieldVal {
    return Intl.message(
      'Date field cannot be empty',
      name: 'obDateFieldVal',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date`
  String get obInValidDate {
    return Intl.message(
      'Invalid date',
      name: 'obInValidDate',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get obUsernameLabel {
    return Intl.message(
      'Username',
      name: 'obUsernameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter a username`
  String get obUsernameHint {
    return Intl.message(
      'Enter a username',
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

  /// `Your KYC Details`
  String get obKYCDetailsLabel {
    return Intl.message(
      'Your KYC Details',
      name: 'obKYCDetailsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Your Bank Account Details`
  String get obBankDetails {
    return Intl.message(
      'Your Bank Account Details',
      name: 'obBankDetails',
      desc: '',
      args: [],
    );
  }

  /// `App Lock`
  String get obAppLock {
    return Intl.message(
      'App Lock',
      name: 'obAppLock',
      desc: '',
      args: [],
    );
  }

  /// `Account Information`
  String get obBlockedAb {
    return Intl.message(
      'Account Information',
      name: 'obBlockedAb',
      desc: '',
      args: [],
    );
  }

  /// `Your Account Has Been Blocked`
  String get obBlockedTitle {
    return Intl.message(
      'Your Account Has Been Blocked',
      name: 'obBlockedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get obSomeThingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'obSomeThingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch T&C right now. Please try again later`
  String get obCouldNotLaunch {
    return Intl.message(
      'Could not launch T&C right now. Please try again later',
      name: 'obCouldNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Your Fello Account has been banned for activity that violates our policy`
  String get obBlockedSubtitle1 {
    return Intl.message(
      'Your Fello Account has been banned for activity that violates our policy',
      name: 'obBlockedSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Join over 5 Lakh users who save and win with us!`
  String get obJoinUsBottomTitle {
    return Intl.message(
      'Join over 5 Lakh users who save and win with us!',
      name: 'obJoinUsBottomTitle',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our `
  String get obAgreeText {
    return Intl.message(
      'By continuing, you agree to our ',
      name: 'obAgreeText',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get obTermsofService {
    return Intl.message(
      'Terms of Service',
      name: 'obTermsofService',
      desc: '',
      args: [],
    );
  }

  /// `Logging in with`
  String get obLoggingInWith {
    return Intl.message(
      'Logging in with',
      name: 'obLoggingInWith',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get obLoading {
    return Intl.message(
      'Loading...',
      name: 'obLoading',
      desc: '',
      args: [],
    );
  }

  /// `FINISH`
  String get obFinish {
    return Intl.message(
      'FINISH',
      name: 'obFinish',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get obNext {
    return Intl.message(
      'NEXT',
      name: 'obNext',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get obHelp {
    return Intl.message(
      'Help',
      name: 'obHelp',
      desc: '',
      args: [],
    );
  }

  /// `EDIT`
  String get obEdit {
    return Intl.message(
      'EDIT',
      name: 'obEdit',
      desc: '',
      args: [],
    );
  }

  /// `DONE`
  String get obDone {
    return Intl.message(
      'DONE',
      name: 'obDone',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get obVerify {
    return Intl.message(
      'Verify',
      name: 'obVerify',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get obSendOTP {
    return Intl.message(
      'Send OTP',
      name: 'obSendOTP',
      desc: '',
      args: [],
    );
  }

  /// `Need Help?`
  String get obNeedHelp {
    return Intl.message(
      'Need Help?',
      name: 'obNeedHelp',
      desc: '',
      args: [],
    );
  }

  /// `App Update Required`
  String get obAppUpdate {
    return Intl.message(
      'App Update Required',
      name: 'obAppUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get obPleaseTryAgain {
    return Intl.message(
      'Please try again',
      name: 'obPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `We have come up with critical features and experience improvements that require an update of the application`
  String get obCritialFeaturesUpdate {
    return Intl.message(
      'We have come up with critical features and experience improvements that require an update of the application',
      name: 'obCritialFeaturesUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Update Avatar`
  String get obUpdateAvatar {
    return Intl.message(
      'Update Avatar',
      name: 'obUpdateAvatar',
      desc: '',
      args: [],
    );
  }

  /// `verify Email`
  String get obVerifyEmail {
    return Intl.message(
      'verify Email',
      name: 'obVerifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Sending OTP`
  String get obSendingOtp {
    return Intl.message(
      'Sending OTP',
      name: 'obSendingOtp',
      desc: '',
      args: [],
    );
  }

  /// `Enter the OTP`
  String get obEnterOTP {
    return Intl.message(
      'Enter the OTP',
      name: 'obEnterOTP',
      desc: '',
      args: [],
    );
  }

  /// `OTP is only valid for `
  String get obOTPValidFor {
    return Intl.message(
      'OTP is only valid for ',
      name: 'obOTPValidFor',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the email where you would like to receive all transaction and support related updates`
  String get obEmailSub {
    return Intl.message(
      'Please enter the email where you would like to receive all transaction and support related updates',
      name: 'obEmailSub',
      desc: '',
      args: [],
    );
  }

  /// `Session Expired!`
  String get obSessionExpired {
    return Intl.message(
      'Session Expired!',
      name: 'obSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `OTP is incorrect,please try again`
  String get obIncorrectOTP {
    return Intl.message(
      'OTP is incorrect,please try again',
      name: 'obIncorrectOTP',
      desc: '',
      args: [],
    );
  }

  /// ` minutes.`
  String get obMinutes {
    return Intl.message(
      ' minutes.',
      name: 'obMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Change your avatar`
  String get obChangeAvatar {
    return Intl.message(
      'Change your avatar',
      name: 'obChangeAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Choose an email option`
  String get obChooseEmail {
    return Intl.message(
      'Choose an email option',
      name: 'obChooseEmail',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get obChooseGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'obChooseGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Use another email`
  String get obUseAnotherEmail {
    return Intl.message(
      'Use another email',
      name: 'obUseAnotherEmail',
      desc: '',
      args: [],
    );
  }

  /// `Create your username`
  String get obCreateUserName {
    return Intl.message(
      'Create your username',
      name: 'obCreateUserName',
      desc: '',
      args: [],
    );
  }

  /// `This will be your unique name across our games and challenges leaderboard`
  String get obuniqueNameText {
    return Intl.message(
      'This will be your unique name across our games and challenges leaderboard',
      name: 'obuniqueNameText',
      desc: '',
      args: [],
    );
  }

  /// `Your username`
  String get obUserNameHint {
    return Intl.message(
      'Your username',
      name: 'obUserNameHint',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-----------------------------------' key

  /// `Journey`
  String get navBarJourney {
    return Intl.message(
      'Journey',
      name: 'navBarJourney',
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

  /// `SELL`
  String get saveSellButton {
    return Intl.message(
      'SELL',
      name: 'saveSellButton',
      desc: '',
      args: [],
    );
  }

  /// `Gold Balance:`
  String get saveGoldBalancelabel {
    return Intl.message(
      'Gold Balance:',
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

  /// `My Active Winnings`
  String get saveWinningsLabel {
    return Intl.message(
      'My Active Winnings',
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

  /// `Buy 24K pure DigitalYou own Gold`
  String get buyGold {
    return Intl.message(
      'Buy 24K pure DigitalYou own Gold',
      name: 'buyGold',
      desc: '',
      args: [],
    );
  }

  /// `You own`
  String get youOwn {
    return Intl.message(
      'You own',
      name: 'youOwn',
      desc: '',
      args: [],
    );
  }

  /// `Fello Tokens`
  String get felloTokens {
    return Intl.message(
      'Fello Tokens',
      name: 'felloTokens',
      desc: '',
      args: [],
    );
  }

  /// `Sold`
  String get sold {
    return Intl.message(
      'Sold',
      name: 'sold',
      desc: '',
      args: [],
    );
  }

  /// `Safest Digital Investment`
  String get safestDigitalInvestment {
    return Intl.message(
      'Safest Digital Investment',
      name: 'safestDigitalInvestment',
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

  /// `Balance`
  String get balanceText {
    return Intl.message(
      'Balance',
      name: 'balanceText',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Invest safely in Gold\nwith our Auto SIP to win tokens`
  String get investSafelyInGoldText {
    return Intl.message(
      'Invest safely in Gold\nwith our Auto SIP to win tokens',
      name: 'investSafelyInGoldText',
      desc: '',
      args: [],
    );
  }

  /// `Get started with a weekly/ daily SIP`
  String get getStartedWithSIP {
    return Intl.message(
      'Get started with a weekly/ daily SIP',
      name: 'getStartedWithSIP',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawable Gold Balance`
  String get withdrawGoldBalance {
    return Intl.message(
      'Withdrawable Gold Balance',
      name: 'withdrawGoldBalance',
      desc: '',
      args: [],
    );
  }

  /// `Upto ₹ 50,000 can be sold at one go.`
  String get goldSellingCapacity {
    return Intl.message(
      'Upto ₹ 50,000 can be sold at one go.',
      name: 'goldSellingCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Fello Flo`
  String get felloFloText {
    return Intl.message(
      'Fello Flo',
      name: 'felloFloText',
      desc: '',
      args: [],
    );
  }

  /// `10% p.a. returns | RBI regulated | P2P asset`
  String get felloFloSubTitle {
    return Intl.message(
      '10% p.a. returns | RBI regulated | P2P asset',
      name: 'felloFloSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Minimum sell amount is ₹ 10`
  String get minimumAmount {
    return Intl.message(
      'Minimum sell amount is ₹ 10',
      name: 'minimumAmount',
      desc: '',
      args: [],
    );
  }

  /// `10% returns on investment`
  String get flo10PercentReturns {
    return Intl.message(
      '10% returns on investment',
      name: 'flo10PercentReturns',
      desc: '',
      args: [],
    );
  }

  /// `Earn 10% returns`
  String get floEarn10Percent {
    return Intl.message(
      'Earn 10% returns',
      name: 'floEarn10Percent',
      desc: '',
      args: [],
    );
  }

  /// `Digital Gold`
  String get digitalGoldText {
    return Intl.message(
      'Digital Gold',
      name: 'digitalGoldText',
      desc: '',
      args: [],
    );
  }

  /// `Choose your asset`
  String get chooseYourAsset {
    return Intl.message(
      'Choose your asset',
      name: 'chooseYourAsset',
      desc: '',
      args: [],
    );
  }

  /// `Earn 1 Token for every ₹1 you invest`
  String get earnOneToken {
    return Intl.message(
      'Earn 1 Token for every ₹1 you invest',
      name: 'earnOneToken',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy stable returns of 10%`
  String get felloFloEarnTxt {
    return Intl.message(
      'Enjoy stable returns of 10%',
      name: 'felloFloEarnTxt',
      desc: '',
      args: [],
    );
  }

  /// `What makes you want to sell?`
  String get goldSellReason {
    return Intl.message(
      'What makes you want to sell?',
      name: 'goldSellReason',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Rate:`
  String get purchaseRate {
    return Intl.message(
      'Purchase Rate:',
      name: 'purchaseRate',
      desc: '',
      args: [],
    );
  }

  /// `Gold Purchased:`
  String get goldPurchased {
    return Intl.message(
      'Gold Purchased:',
      name: 'goldPurchased',
      desc: '',
      args: [],
    );
  }

  /// `Sell Rate:`
  String get sellRate {
    return Intl.message(
      'Sell Rate:',
      name: 'sellRate',
      desc: '',
      args: [],
    );
  }

  /// `Gold Sold:`
  String get goldSold {
    return Intl.message(
      'Gold Sold:',
      name: 'goldSold',
      desc: '',
      args: [],
    );
  }

  /// `Start Saving`
  String get startSaving {
    return Intl.message(
      'Start Saving',
      name: 'startSaving',
      desc: '',
      args: [],
    );
  }

  /// `Total Savings`
  String get totalSavings {
    return Intl.message(
      'Total Savings',
      name: 'totalSavings',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `Your Savings`
  String get yourSavings {
    return Intl.message(
      'Your Savings',
      name: 'yourSavings',
      desc: '',
      args: [],
    );
  }

  /// `Highest\nSaving`
  String get highestSaving {
    return Intl.message(
      'Highest\nSaving',
      name: 'highestSaving',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message(
      'Rank',
      name: 'rank',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get na {
    return Intl.message(
      'N/A',
      name: 'na',
      desc: '',
      args: [],
    );
  }

  /// `BEST`
  String get best {
    return Intl.message(
      'BEST',
      name: 'best',
      desc: '',
      args: [],
    );
  }

  /// `Users have earned huge interests on their savings by holding for more than a year 💰`
  String get holdSavingsMoreThanYear {
    return Intl.message(
      'Users have earned huge interests on their savings by holding for more than a year 💰',
      name: 'holdSavingsMoreThanYear',
      desc: '',
      args: [],
    );
  }

  /// `gms`
  String get gms {
    return Intl.message(
      'gms',
      name: 'gms',
      desc: '',
      args: [],
    );
  }

  /// `gm`
  String get gm {
    return Intl.message(
      'gm',
      name: 'gm',
      desc: '',
      args: [],
    );
  }

  /// `g`
  String get g {
    return Intl.message(
      'g',
      name: 'g',
      desc: '',
      args: [],
    );
  }

  /// `Your`
  String get your {
    return Intl.message(
      'Your',
      name: 'your',
      desc: '',
      args: [],
    );
  }

  /// `could have grown to `
  String get couldHaveGrown {
    return Intl.message(
      'could have grown to ',
      name: 'couldHaveGrown',
      desc: '',
      args: [],
    );
  }

  /// `by 2030! 💸`
  String get by2030 {
    return Intl.message(
      'by 2030! 💸',
      name: 'by2030',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sell?`
  String get wantToSell {
    return Intl.message(
      'Are you sure you want to sell?',
      name: 'wantToSell',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, ₹{amount} will be credited to your linked bank account instantly`
  String creditedToYourLinkedBankAccount(Object amount) {
    return Intl.message(
      'By continuing, ₹$amount will be credited to your linked bank account instantly',
      name: 'creditedToYourLinkedBankAccount',
      desc: '',
      args: [amount],
    );
  }

  /// `99.9% pure | 24K Gold | 100% secure`
  String get digitalGoldSubTitle {
    return Intl.message(
      '99.9% pure | 24K Gold | 100% secure',
      name: 'digitalGoldSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upto ₹ 50,000 can be invested at one go`
  String get upto50000 {
    return Intl.message(
      'Upto ₹ 50,000 can be invested at one go',
      name: 'upto50000',
      desc: '',
      args: [],
    );
  }

  /// `Minimum purchase amount is ₹ 10`
  String get minPurchaseText {
    return Intl.message(
      'Minimum purchase amount is ₹ 10',
      name: 'minPurchaseText',
      desc: '',
      args: [],
    );
  }

  /// `Minimum purchase amount is ₹ 100`
  String get minPurchaseText1 {
    return Intl.message(
      'Minimum purchase amount is ₹ 100',
      name: 'minPurchaseText1',
      desc: '',
      args: [],
    );
  }

  /// `Your transaction is in progress`
  String get transactionProgress {
    return Intl.message(
      'Your transaction is in progress',
      name: 'transactionProgress',
      desc: '',
      args: [],
    );
  }

  /// `Invested`
  String get invested {
    return Intl.message(
      'Invested',
      name: 'invested',
      desc: '',
      args: [],
    );
  }

  /// `Bought`
  String get bought {
    return Intl.message(
      'Bought',
      name: 'bought',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentText {
    return Intl.message(
      'Current',
      name: 'currentText',
      desc: '',
      args: [],
    );
  }

  /// `Interest\non Gold`
  String get interestOnGold {
    return Intl.message(
      'Interest\non Gold',
      name: 'interestOnGold',
      desc: '',
      args: [],
    );
  }

  /// `Current Price`
  String get currentPrice {
    return Intl.message(
      'Current Price',
      name: 'currentPrice',
      desc: '',
      args: [],
    );
  }

  /// `Valid for: `
  String get validFor {
    return Intl.message(
      'Valid for: ',
      name: 'validFor',
      desc: '',
      args: [],
    );
  }

  /// `ACTIVE SIP`
  String get autoSIP {
    return Intl.message(
      'ACTIVE SIP',
      name: 'autoSIP',
      desc: '',
      args: [],
    );
  }

  /// `Sell your Digital Gold \nat current market rate`
  String get sellCardTitle1 {
    return Intl.message(
      'Sell your Digital Gold \nat current market rate',
      name: 'sellCardTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw from Flo`
  String get sellCardTitle2 {
    return Intl.message(
      'Withdraw from Flo',
      name: 'sellCardTitle2',
      desc: '',
      args: [],
    );
  }

  /// `With every withdrawal, some tokens and tambola tickets will be deducted.`
  String get sellCardSubTitle1 {
    return Intl.message(
      'With every withdrawal, some tokens and tambola tickets will be deducted.',
      name: 'sellCardSubTitle1',
      desc: '',
      args: [],
    );
  }

  /// `To enable sell,\ncomplete the following:`
  String get enableSell {
    return Intl.message(
      'To enable sell,\ncomplete the following:',
      name: 'enableSell',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------------' key

  /// `Add Bank information`
  String get addBankInformationText {
    return Intl.message(
      'Add Bank information',
      name: 'addBankInformationText',
      desc: '',
      args: [],
    );
  }

  /// `With every transaction, some\ntokens will be deducted.`
  String get tokenDeductionOnTransaction {
    return Intl.message(
      'With every transaction, some\ntokens will be deducted.',
      name: 'tokenDeductionOnTransaction',
      desc: '',
      args: [],
    );
  }

  /// `To enable selling gold, complete the following:`
  String get enableSellGold {
    return Intl.message(
      'To enable selling gold, complete the following:',
      name: 'enableSellGold',
      desc: '',
      args: [],
    );
  }

  /// `Complete KYC`
  String get completeKYCText {
    return Intl.message(
      'Complete KYC',
      name: 'completeKYCText',
      desc: '',
      args: [],
    );
  }

  /// `You need to complete your KYC before you can invest`
  String get kycIncomplete {
    return Intl.message(
      'You need to complete your KYC before you can invest',
      name: 'kycIncomplete',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '---------------------------------' key

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

  /// `Refer friends`
  String get winIphoneSmallText {
    return Intl.message(
      'Refer friends',
      name: 'winIphoneSmallText',
      desc: '',
      args: [],
    );
  }

  /// `and win iPad Air`
  String get winIphoneBigText {
    return Intl.message(
      'and win iPad Air',
      name: 'winIphoneBigText',
      desc: '',
      args: [],
    );
  }

  /// ` from every Golden Ticket. Highest referrer wins iPad every month`
  String get winIpadFromGT {
    return Intl.message(
      ' from every Golden Ticket. Highest referrer wins iPad every month',
      name: 'winIpadFromGT',
      desc: '',
      args: [],
    );
  }

  /// `Win ₹1 Crore!`
  String get win1Crore {
    return Intl.message(
      'Win ₹1 Crore!',
      name: 'win1Crore',
      desc: '',
      args: [],
    );
  }

  /// `Current Winnings`
  String get currentWinings {
    return Intl.message(
      'Current Winnings',
      name: 'currentWinings',
      desc: '',
      args: [],
    );
  }

  /// `Winnings can be redeemed as `
  String get winRedeemText {
    return Intl.message(
      'Winnings can be redeemed as ',
      name: 'winRedeemText',
      desc: '',
      args: [],
    );
  }

  /// `on reaching ₹`
  String get onReaching {
    return Intl.message(
      'on reaching ₹',
      name: 'onReaching',
      desc: '',
      args: [],
    );
  }

  /// `Golden Tickets`
  String get goldenTicketText {
    return Intl.message(
      'Golden Tickets',
      name: 'goldenTicketText',
      desc: '',
      args: [],
    );
  }

  /// `Earn upto `
  String get earnUpto {
    return Intl.message(
      'Earn upto ',
      name: 'earnUpto',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// ` from every Golden Ticket. Highest referrer wins an iPad every month.`
  String get winipadText {
    return Intl.message(
      ' from every Golden Ticket. Highest referrer wins an iPad every month.',
      name: 'winipadText',
      desc: '',
      args: [],
    );
  }

  /// `COPY`
  String get copy {
    return Intl.message(
      'COPY',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderBoard {
    return Intl.message(
      'Leaderboard',
      name: 'leaderBoard',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewards {
    return Intl.message(
      'Rewards',
      name: 'rewards',
      desc: '',
      args: [],
    );
  }

  /// `No rewards yet`
  String get noRewards {
    return Intl.message(
      'No rewards yet',
      name: 'noRewards',
      desc: '',
      args: [],
    );
  }

  /// `This Week’s Highlights`
  String get weekHighlights {
    return Intl.message(
      'This Week’s Highlights',
      name: 'weekHighlights',
      desc: '',
      args: [],
    );
  }

  /// `Past Winners`
  String get pastWinners {
    return Intl.message(
      'Past Winners',
      name: 'pastWinners',
      desc: '',
      args: [],
    );
  }

  /// `Top Participants`
  String get topParticipants {
    return Intl.message(
      'Top Participants',
      name: 'topParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get participants {
    return Intl.message(
      'Participants',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard will be updated soon`
  String get leaderboardUpdateSoon {
    return Intl.message(
      'Leaderboard will be updated soon',
      name: 'leaderboardUpdateSoon',
      desc: '',
      args: [],
    );
  }

  /// `Use tokens to play games!`
  String get winChipsTitle1 {
    return Intl.message(
      'Use tokens to play games!',
      name: 'winChipsTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Scratch and win rewards!`
  String get winChipsTitle2 {
    return Intl.message(
      'Scratch and win rewards!',
      name: 'winChipsTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Win upto ₹1 Crore in Tambola!`
  String get winChipsTitle3 {
    return Intl.message(
      'Win upto ₹1 Crore in Tambola!',
      name: 'winChipsTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Golden Ticket`
  String get goldenTicket {
    return Intl.message(
      'Golden Ticket',
      name: 'goldenTicket',
      desc: '',
      args: [],
    );
  }

  /// `Fetching last week winners.`
  String get fetchWinners {
    return Intl.message(
      'Fetching last week winners.',
      name: 'fetchWinners',
      desc: '',
      args: [],
    );
  }

  /// `Last week winners`
  String get lastWeekWinners {
    return Intl.message(
      'Last week winners',
      name: 'lastWeekWinners',
      desc: '',
      args: [],
    );
  }

  /// `Past Week Winners`
  String get pastWeekWinners {
    return Intl.message(
      'Past Week Winners',
      name: 'pastWeekWinners',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard will be updated soon`
  String get leaderBoardUpdate {
    return Intl.message(
      'Leaderboard will be updated soon',
      name: 'leaderBoardUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Names`
  String get names {
    return Intl.message(
      'Names',
      name: 'names',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Cashprize`
  String get cashPrize {
    return Intl.message(
      'Cashprize',
      name: 'cashPrize',
      desc: '',
      args: [],
    );
  }

  /// `My Rewards`
  String get winRewardsTitle {
    return Intl.message(
      'My Rewards',
      name: 'winRewardsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `No Rewards won`
  String get rewardsEmpty {
    return Intl.message(
      'No Rewards won',
      name: 'rewardsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Keep investing, keep playing and win big!`
  String get keepInvestingText {
    return Intl.message(
      'Keep investing, keep playing and win big!',
      name: 'keepInvestingText',
      desc: '',
      args: [],
    );
  }

  /// `Hurray!`
  String get hurray {
    return Intl.message(
      'Hurray!',
      name: 'hurray',
      desc: '',
      args: [],
    );
  }

  /// `You’ve earned a golden ticket.`
  String get earnedGTText {
    return Intl.message(
      'You’ve earned a golden ticket.',
      name: 'earnedGTText',
      desc: '',
      args: [],
    );
  }

  /// `Scratch and win exciting rewards.`
  String get scratchAndWin {
    return Intl.message(
      'Scratch and win exciting rewards.',
      name: 'scratchAndWin',
      desc: '',
      args: [],
    );
  }

  /// `Rewards have been credited to your wallet`
  String get rewardsCredited {
    return Intl.message(
      'Rewards have been credited to your wallet',
      name: 'rewardsCredited',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed on `
  String get redeemedOn {
    return Intl.message(
      'Redeemed on ',
      name: 'redeemedOn',
      desc: '',
      args: [],
    );
  }

  /// `Received on `
  String get receivedOn {
    return Intl.message(
      'Received on ',
      name: 'receivedOn',
      desc: '',
      args: [],
    );
  }

  /// `Adding prize to your wallet`
  String get addingPrice {
    return Intl.message(
      'Adding prize to your wallet',
      name: 'addingPrice',
      desc: '',
      args: [],
    );
  }

  /// `You won a golden ticket`
  String get wonGT {
    return Intl.message(
      'You won a golden ticket',
      name: 'wonGT',
      desc: '',
      args: [],
    );
  }

  /// `Win`
  String get win {
    return Intl.message(
      'Win',
      name: 'win',
      desc: '',
      args: [],
    );
  }

  /// `Entry`
  String get entry {
    return Intl.message(
      'Entry',
      name: 'entry',
      desc: '',
      args: [],
    );
  }

  /// `Prize ${i}`
  String price(Object i) {
    return Intl.message(
      'Prize \$$i',
      name: 'price',
      desc: '',
      args: [i],
    );
  }

  /// `Rs`
  String get rs {
    return Intl.message(
      'Rs',
      name: 'rs',
      desc: '',
      args: [],
    );
  }

  /// `Daily Bonus`
  String get dailyBonusText {
    return Intl.message(
      'Daily Bonus',
      name: 'dailyBonusText',
      desc: '',
      args: [],
    );
  }

  /// `Open the app everyday for a week and win assured rewards`
  String get dailyBonusSubtitleText {
    return Intl.message(
      'Open the app everyday for a week and win assured rewards',
      name: 'dailyBonusSubtitleText',
      desc: '',
      args: [],
    );
  }

  /// `Reward claimed for today, come back tomorrow for more.`
  String get claimMessage {
    return Intl.message(
      'Reward claimed for today, come back tomorrow for more.',
      name: 'claimMessage',
      desc: '',
      args: [],
    );
  }

  /// `You have won a `
  String get youWonA {
    return Intl.message(
      'You have won a ',
      name: 'youWonA',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get gotIt {
    return Intl.message(
      'Got it',
      name: 'gotIt',
      desc: '',
      args: [],
    );
  }

  /// `Claim day {currentDay} Reward`
  String dayRerward(Object currentDay) {
    return Intl.message(
      'Claim day $currentDay Reward',
      name: 'dayRerward',
      desc: '',
      args: [currentDay],
    );
  }

  /// `Total Rewards`
  String get totalRewards {
    return Intl.message(
      'Total Rewards',
      name: 'totalRewards',
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

  /// `Pick a Username`
  String get abGamingName {
    return Intl.message(
      'Pick a Username',
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

  /// `Alerts`
  String get abNotifications {
    return Intl.message(
      'Alerts',
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

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get subTitle {
    return Intl.message(
      'Subtitle',
      name: 'subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Looking for more alerts, please wait ..`
  String get moreAlerts {
    return Intl.message(
      'Looking for more alerts, please wait ..',
      name: 'moreAlerts',
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

  /// `My Referrals`
  String get myreferrals {
    return Intl.message(
      'My Referrals',
      name: 'myreferrals',
      desc: '',
      args: [],
    );
  }

  /// `How do you earn?`
  String get refHIW {
    return Intl.message(
      'How do you earn?',
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

  /// `Referral Code (Optional)`
  String get refCodeOptional {
    return Intl.message(
      'Referral Code (Optional)',
      name: 'refCodeOptional',
      desc: '',
      args: [],
    );
  }

  /// `Enter your referral code here`
  String get refCodeHint {
    return Intl.message(
      'Enter your referral code here',
      name: 'refCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid referral code`
  String get refInvalid {
    return Intl.message(
      'Invalid referral code',
      name: 'refInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Have a referral code?`
  String get refHaveReferral {
    return Intl.message(
      'Have a referral code?',
      name: 'refHaveReferral',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get refUnAvailable {
    return Intl.message(
      'Unavailable',
      name: 'refUnAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Refer your friends`
  String get referFriends {
    return Intl.message(
      'Refer your friends',
      name: 'referFriends',
      desc: '',
      args: [],
    );
  }

  /// `Earn Golden Tickets for every referral`
  String get getGoldenTickets {
    return Intl.message(
      'Earn Golden Tickets for every referral',
      name: 'getGoldenTickets',
      desc: '',
      args: [],
    );
  }

  /// `Referral Policy`
  String get refPolicy {
    return Intl.message(
      'Referral Policy',
      name: 'refPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load the Referral Policy at the moment. Please try again later`
  String get refPolicyFailed {
    return Intl.message(
      'Failed to load the Referral Policy at the moment. Please try again later',
      name: 'refPolicyFailed',
      desc: '',
      args: [],
    );
  }

  /// `Share the good news with\nyour friend`
  String get shareGoodNews {
    return Intl.message(
      'Share the good news with\nyour friend',
      name: 'shareGoodNews',
      desc: '',
      args: [],
    );
  }

  /// `1 Golden\nTicket`
  String get oneGoldenTicket {
    return Intl.message(
      '1 Golden\nTicket',
      name: 'oneGoldenTicket',
      desc: '',
      args: [],
    );
  }

  /// `50 Fello\nTokens`
  String get fiftyFelloTokens {
    return Intl.message(
      '50 Fello\nTokens',
      name: 'fiftyFelloTokens',
      desc: '',
      args: [],
    );
  }

  /// `Fetching your referrals. Please wait..`
  String get refFetch {
    return Intl.message(
      'Fetching your referrals. Please wait..',
      name: 'refFetch',
      desc: '',
      args: [],
    );
  }

  /// `referrals`
  String get referrals {
    return Intl.message(
      'referrals',
      name: 'referrals',
      desc: '',
      args: [],
    );
  }

  /// `Referrals`
  String get referralsTitle {
    return Intl.message(
      'Referrals',
      name: 'referralsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No referrals yet`
  String get refEmpty {
    return Intl.message(
      'No referrals yet',
      name: 'refEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Successful`
  String get successful {
    return Intl.message(
      'Successful',
      name: 'successful',
      desc: '',
      args: [],
    );
  }

  /// `My Reward`
  String get myReward {
    return Intl.message(
      'My Reward',
      name: 'myReward',
      desc: '',
      args: [],
    );
  }

  /// `Have not saved`
  String get notSaved {
    return Intl.message(
      'Have not saved',
      name: 'notSaved',
      desc: '',
      args: [],
    );
  }

  /// `Once your friend makes their first investment of `
  String get askfrndForInvesText {
    return Intl.message(
      'Once your friend makes their first investment of ',
      name: 'askfrndForInvesText',
      desc: '',
      args: [],
    );
  }

  /// `, you and your friend both receive ₹`
  String get askfrndForInvesText1 {
    return Intl.message(
      ', you and your friend both receive ₹',
      name: 'askfrndForInvesText1',
      desc: '',
      args: [],
    );
  }

  /// ` and {Value} Fello tokens.`
  String askfrndForInvesText2(Object Value) {
    return Intl.message(
      ' and $Value Fello tokens.',
      name: 'askfrndForInvesText2',
      desc: '',
      args: [Value],
    );
  }

  /// `Refer`
  String get refer {
    return Intl.message(
      'Refer',
      name: 'refer',
      desc: '',
      args: [],
    );
  }

  /// `Earn`
  String get earn {
    return Intl.message(
      'Earn',
      name: 'earn',
      desc: '',
      args: [],
    );
  }

  /// `Top Referrers`
  String get topRef {
    return Intl.message(
      'Top Referrers',
      name: 'topRef',
      desc: '',
      args: [],
    );
  }

  /// `Referral Leaderboard will be updated soon`
  String get refLeaderboardUpdate {
    return Intl.message(
      'Referral Leaderboard will be updated soon',
      name: 'refLeaderboardUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Start playing to see yourself on the leaderboard`
  String get startPlayingToSeeLB {
    return Intl.message(
      'Start playing to see yourself on the leaderboard',
      name: 'startPlayingToSeeLB',
      desc: '',
      args: [],
    );
  }

  /// `Savings of ₹ {refUnlock} required to redeem your winnings.`
  String refUnlockText(Object refUnlock) {
    return Intl.message(
      'Savings of ₹ $refUnlock required to redeem your winnings.',
      name: 'refUnlockText',
      desc: '',
      args: [refUnlock],
    );
  }

  /// `Redeem for amazon pay`
  String get reedomAmznPay {
    return Intl.message(
      'Redeem for amazon pay',
      name: 'reedomAmznPay',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '---------------------------' key

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

  /// `SHARE`
  String get btnShare {
    return Intl.message(
      'SHARE',
      name: 'btnShare',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get btnComplete {
    return Intl.message(
      'Complete',
      name: 'btnComplete',
      desc: '',
      args: [],
    );
  }

  /// `SIGN OUT`
  String get btnSignout {
    return Intl.message(
      'SIGN OUT',
      name: 'btnSignout',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get btnGrantPermission {
    return Intl.message(
      'Grant Permission',
      name: 'btnGrantPermission',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get btnCancel {
    return Intl.message(
      'Cancel',
      name: 'btnCancel',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get btnLoading {
    return Intl.message(
      'Loading',
      name: 'btnLoading',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get btnEnable {
    return Intl.message(
      'Enable',
      name: 'btnEnable',
      desc: '',
      args: [],
    );
  }

  /// `Not Now`
  String get btnNotNow {
    return Intl.message(
      'Not Now',
      name: 'btnNotNow',
      desc: '',
      args: [],
    );
  }

  /// `Download Invoice`
  String get btnDownloadInvoice {
    return Intl.message(
      'Download Invoice',
      name: 'btnDownloadInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get btnRetry {
    return Intl.message(
      'Retry',
      name: 'btnRetry',
      desc: '',
      args: [],
    );
  }

  /// `Let's Go`
  String get btnLetsGo {
    return Intl.message(
      'Let\'s Go',
      name: 'btnLetsGo',
      desc: '',
      args: [],
    );
  }

  /// `Save Now`
  String get btnSaveNow {
    return Intl.message(
      'Save Now',
      name: 'btnSaveNow',
      desc: '',
      args: [],
    );
  }

  /// `SKIP WITH TOKENS`
  String get btnSkipWithTokens {
    return Intl.message(
      'SKIP WITH TOKENS',
      name: 'btnSkipWithTokens',
      desc: '',
      args: [],
    );
  }

  /// `PLAY`
  String get btnPlay {
    return Intl.message(
      'PLAY',
      name: 'btnPlay',
      desc: '',
      args: [],
    );
  }

  /// `WIN`
  String get btnWin {
    return Intl.message(
      'WIN',
      name: 'btnWin',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get btnStart {
    return Intl.message(
      'Start',
      name: 'btnStart',
      desc: '',
      args: [],
    );
  }

  /// `Start Playing`
  String get btnStartPlaying {
    return Intl.message(
      'Start Playing',
      name: 'btnStartPlaying',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get btnSeeAll {
    return Intl.message(
      'See All',
      name: 'btnSeeAll',
      desc: '',
      args: [],
    );
  }

  /// `NOTIFY ME`
  String get btnNotifyMe {
    return Intl.message(
      'NOTIFY ME',
      name: 'btnNotifyMe',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get btnCongratulations {
    return Intl.message(
      'Congratulations!',
      name: 'btnCongratulations',
      desc: '',
      args: [],
    );
  }

  /// `Apply Coupon`
  String get btnApplyCoupon {
    return Intl.message(
      'Apply Coupon',
      name: 'btnApplyCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get btnContinue {
    return Intl.message(
      'Continue',
      name: 'btnContinue',
      desc: '',
      args: [],
    );
  }

  /// `Check here`
  String get btnCheckHere {
    return Intl.message(
      'Check here',
      name: 'btnCheckHere',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get btnGetStarted {
    return Intl.message(
      'Get Started',
      name: 'btnGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get btnOpen {
    return Intl.message(
      'Open',
      name: 'btnOpen',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get btnPause {
    return Intl.message(
      'Pause',
      name: 'btnPause',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get btnWithDraw {
    return Intl.message(
      'Withdraw',
      name: 'btnWithDraw',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get btnDeposit {
    return Intl.message(
      'Deposit',
      name: 'btnDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Save More`
  String get btnSaveMore {
    return Intl.message(
      'Save More',
      name: 'btnSaveMore',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get btnAdd {
    return Intl.message(
      'Add',
      name: 'btnAdd',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get btnVerified {
    return Intl.message(
      'Verified',
      name: 'btnVerified',
      desc: '',
      args: [],
    );
  }

  /// `Alert!`
  String get btnAlert {
    return Intl.message(
      'Alert!',
      name: 'btnAlert',
      desc: '',
      args: [],
    );
  }

  /// `Buttom`
  String get btn {
    return Intl.message(
      'Buttom',
      name: 'btn',
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

  /// `KYC DETAILS`
  String get kycTitle {
    return Intl.message(
      'KYC DETAILS',
      name: 'kycTitle',
      desc: '',
      args: [],
    );
  }

  /// `This is required to securely verify your identity.`
  String get kycVerifyText {
    return Intl.message(
      'This is required to securely verify your identity.',
      name: 'kycVerifyText',
      desc: '',
      args: [],
    );
  }

  /// `Upload your PAN Card`
  String get kycPanUpload {
    return Intl.message(
      'Upload your PAN Card',
      name: 'kycPanUpload',
      desc: '',
      args: [],
    );
  }

  /// `Use Camera`
  String get kycUseCamera {
    return Intl.message(
      'Use Camera',
      name: 'kycUseCamera',
      desc: '',
      args: [],
    );
  }

  /// `Please grant camera access permission to continue`
  String get kycGrantPermissionText {
    return Intl.message(
      'Please grant camera access permission to continue',
      name: 'kycGrantPermissionText',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, please try again.`
  String get someThingWentWrongError {
    return Intl.message(
      'Something went wrong, please try again.',
      name: 'someThingWentWrongError',
      desc: '',
      args: [],
    );
  }

  /// `mb`
  String get mb {
    return Intl.message(
      'mb',
      name: 'mb',
      desc: '',
      args: [],
    );
  }

  /// `Max size: 5 MB`
  String get maxSizeText {
    return Intl.message(
      'Max size: 5 MB',
      name: 'maxSizeText',
      desc: '',
      args: [],
    );
  }

  /// `Formats: PNG, JPEG, JPG`
  String get formatsText {
    return Intl.message(
      'Formats: PNG, JPEG, JPG',
      name: 'formatsText',
      desc: '',
      args: [],
    );
  }

  /// `Upload from device`
  String get uploadFromDevice {
    return Intl.message(
      'Upload from device',
      name: 'uploadFromDevice',
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

  /// `Tambola Ticket`
  String get tTicket {
    return Intl.message(
      'Tambola Ticket',
      name: 'tTicket',
      desc: '',
      args: [],
    );
  }

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

  /// `Your prizes will be credited tomorrow. Be sure to check out the leaderboard!`
  String get tWinSubtitle2 {
    return Intl.message(
      'Your prizes will be credited tomorrow. Be sure to check out the leaderboard!',
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

  /// `NEW`
  String get tambolaNew {
    return Intl.message(
      'NEW',
      name: 'tambolaNew',
      desc: '',
      args: [],
    );
  }

  /// `Generated on :`
  String get tGeneratedOn {
    return Intl.message(
      'Generated on :',
      name: 'tGeneratedOn',
      desc: '',
      args: [],
    );
  }

  /// `How to participate`
  String get howToParticipate {
    return Intl.message(
      'How to participate',
      name: 'howToParticipate',
      desc: '',
      args: [],
    );
  }

  /// `Today’s draw at 6 PM `
  String get tDrawTime {
    return Intl.message(
      'Today’s draw at 6 PM ',
      name: 'tDrawTime',
      desc: '',
      args: [],
    );
  }

  /// `Win grand rewards\nas digital gold.`
  String get winGrandRewards {
    return Intl.message(
      'Win grand rewards\nas digital gold.',
      name: 'winGrandRewards',
      desc: '',
      args: [],
    );
  }

  /// `DAY`
  String get day {
    return Intl.message(
      'DAY',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Tambola Tickets Deducted`
  String get tTicketsDeducted {
    return Intl.message(
      'Tambola Tickets Deducted',
      name: 'tTicketsDeducted',
      desc: '',
      args: [],
    );
  }

  /// `Daily Picks`
  String get tDailyPicks {
    return Intl.message(
      'Daily Picks',
      name: 'tDailyPicks',
      desc: '',
      args: [],
    );
  }

  /// `Today's Picks are:`
  String get todaysPicks {
    return Intl.message(
      'Today\'s Picks are:',
      name: 'todaysPicks',
      desc: '',
      args: [],
    );
  }

  /// `Please wait, loading today's picks`
  String get loadingTodaysPicks {
    return Intl.message(
      'Please wait, loading today\'s picks',
      name: 'loadingTodaysPicks',
      desc: '',
      args: [],
    );
  }

  /// `Find out how many numbers matched today..`
  String get tNoMatched {
    return Intl.message(
      'Find out how many numbers matched today..',
      name: 'tNoMatched',
      desc: '',
      args: [],
    );
  }

  /// `How to play`
  String get tHowToPlay {
    return Intl.message(
      'How to play',
      name: 'tHowToPlay',
      desc: '',
      args: [],
    );
  }

  /// `Tambola`
  String get tTitle {
    return Intl.message(
      'Tambola',
      name: 'tTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total Tickets: `
  String get tTotalTickets {
    return Intl.message(
      'Total Tickets: ',
      name: 'tTotalTickets',
      desc: '',
      args: [],
    );
  }

  /// `+ Get Tickets`
  String get tGetTickets {
    return Intl.message(
      '+ Get Tickets',
      name: 'tGetTickets',
      desc: '',
      args: [],
    );
  }

  /// `Get Tickets`
  String get getTickets {
    return Intl.message(
      'Get Tickets',
      name: 'getTickets',
      desc: '',
      args: [],
    );
  }

  /// ` Ticket`
  String get tOneTicket {
    return Intl.message(
      ' Ticket',
      name: 'tOneTicket',
      desc: '',
      args: [],
    );
  }

  /// `Get your first ticket`
  String get tgetFirstTkt {
    return Intl.message(
      'Get your first ticket',
      name: 'tgetFirstTkt',
      desc: '',
      args: [],
    );
  }

  /// `every week for lifetime`
  String get tEveryWeekText {
    return Intl.message(
      'every week for lifetime',
      name: 'tEveryWeekText',
      desc: '',
      args: [],
    );
  }

  /// `Will be drawn at 6pm`
  String get tDrawnAtText1 {
    return Intl.message(
      'Will be drawn at 6pm',
      name: 'tDrawnAtText1',
      desc: '',
      args: [],
    );
  }

  /// `Drawn at 6pm`
  String get tDrawnAtText2 {
    return Intl.message(
      'Drawn at 6pm',
      name: 'tDrawnAtText2',
      desc: '',
      args: [],
    );
  }

  /// `Fetching your tambola tickets..`
  String get tFetch {
    return Intl.message(
      'Fetching your tambola tickets..',
      name: 'tFetch',
      desc: '',
      args: [],
    );
  }

  /// `Better luck next time!`
  String get tBetterLuckText {
    return Intl.message(
      'Better luck next time!',
      name: 'tBetterLuckText',
      desc: '',
      args: [],
    );
  }

  /// `None of your tickets matched this time.\nSave & get Tambola tickets for the coming week!`
  String get tNoneOfTicketsMatched {
    return Intl.message(
      'None of your tickets matched this time.\nSave & get Tambola tickets for the coming week!',
      name: 'tNoneOfTicketsMatched',
      desc: '',
      args: [],
    );
  }

  /// `View All Tickets`
  String get tViewAllTicks {
    return Intl.message(
      'View All Tickets',
      name: 'tViewAllTicks',
      desc: '',
      args: [],
    );
  }

  /// `Apple is not associated with Fello Tambola`
  String get tAppleInfo {
    return Intl.message(
      'Apple is not associated with Fello Tambola',
      name: 'tAppleInfo',
      desc: '',
      args: [],
    );
  }

  /// `Generated`
  String get tgenerated {
    return Intl.message(
      'Generated',
      name: 'tgenerated',
      desc: '',
      args: [],
    );
  }

  /// `of your {ticketGenerateCount} tickets`
  String tgeneratedCount(Object ticketGenerateCount) {
    return Intl.message(
      'of your $ticketGenerateCount tickets',
      name: 'tgeneratedCount',
      desc: '',
      args: [ticketGenerateCount],
    );
  }

  /// `Tambola results are out   `
  String get tResultsOut {
    return Intl.message(
      'Tambola results are out   ',
      name: 'tResultsOut',
      desc: '',
      args: [],
    );
  }

  /// `Find out if your tickets won`
  String get tCheckIfWon {
    return Intl.message(
      'Find out if your tickets won',
      name: 'tCheckIfWon',
      desc: '',
      args: [],
    );
  }

  /// `Top Row`
  String get tTopRow {
    return Intl.message(
      'Top Row',
      name: 'tTopRow',
      desc: '',
      args: [],
    );
  }

  /// `Middle Row`
  String get tMiddleRow {
    return Intl.message(
      'Middle Row',
      name: 'tMiddleRow',
      desc: '',
      args: [],
    );
  }

  /// `Bottom Row`
  String get tBottomRow {
    return Intl.message(
      'Bottom Row',
      name: 'tBottomRow',
      desc: '',
      args: [],
    );
  }

  /// ` left`
  String get tLeft {
    return Intl.message(
      ' left',
      name: 'tLeft',
      desc: '',
      args: [],
    );
  }

  /// `Corners`
  String get tCorners {
    return Intl.message(
      'Corners',
      name: 'tCorners',
      desc: '',
      args: [],
    );
  }

  /// `Full House`
  String get tFullHouse {
    return Intl.message(
      'Full House',
      name: 'tFullHouse',
      desc: '',
      args: [],
    );
  }

  /// `Get more tickets`
  String get tGetMore {
    return Intl.message(
      'Get more tickets',
      name: 'tGetMore',
      desc: '',
      args: [],
    );
  }

  /// `Get 1 Ticket for every ₹{Value} saved`
  String get1Ticket(Object Value) {
    return Intl.message(
      'Get 1 Ticket for every ₹$Value saved',
      name: 'get1Ticket',
      desc: '',
      args: [Value],
    );
  }

  /// `View Prizes`
  String get viewPrizes {
    return Intl.message(
      'View Prizes',
      name: 'viewPrizes',
      desc: '',
      args: [],
    );
  }

  /// `Tambola Prizes`
  String get tPrizes {
    return Intl.message(
      'Tambola Prizes',
      name: 'tPrizes',
      desc: '',
      args: [],
    );
  }

  /// `Winners are announced every Sunday at midnight, Complete a Full House and win 1Crore!`
  String get tWin1Crore {
    return Intl.message(
      'Winners are announced every Sunday at midnight, Complete a Full House and win 1Crore!',
      name: 'tWin1Crore',
      desc: '',
      args: [],
    );
  }

  /// `Complete {prize} to get `
  String tCompleteToGet(Object prize) {
    return Intl.message(
      'Complete $prize to get ',
      name: 'tCompleteToGet',
      desc: '',
      args: [prize],
    );
  }

  /// `Ticket No`
  String get tTicketNo {
    return Intl.message(
      'Ticket No',
      name: 'tTicketNo',
      desc: '',
      args: [],
    );
  }

  /// `This account will be used for crediting your \n withdrawals`
  String get txnWithdrawAccountText {
    return Intl.message(
      'This account will be used for crediting your \n withdrawals',
      name: 'txnWithdrawAccountText',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-------------------------------------------' key

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

  // skipped getter for the '------------------------------------------' key

  /// `Play fun games and get a chance to\nwin rewards as Digital Gold!`
  String get shareCardTitle {
    return Intl.message(
      'Play fun games and get a chance to\nwin rewards as Digital Gold!',
      name: 'shareCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've won an Amazon Gift Voucher\n worth`
  String get priceClaimTitle1 {
    return Intl.message(
      'You\'ve won an Amazon Gift Voucher\n worth',
      name: 'priceClaimTitle1',
      desc: '',
      args: [],
    );
  }

  /// `I've won ₹${prizeAmount} as\nDigital Gold on Fello!`
  String priceClaimTitle2(Object prizeAmount) {
    return Intl.message(
      'I\'ve won ₹\$$prizeAmount as\nDigital Gold on Fello!',
      name: 'priceClaimTitle2',
      desc: '',
      args: [prizeAmount],
    );
  }

  /// `You've won Fello Rewards\n worth`
  String get priceClaimTitle3 {
    return Intl.message(
      'You\'ve won Fello Rewards\n worth',
      name: 'priceClaimTitle3',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-----------------------------------------------' key

  /// `Autosave`
  String get autoSave {
    return Intl.message(
      'Autosave',
      name: 'autoSave',
      desc: '',
      args: [],
    );
  }

  /// `How it works?`
  String get howItworks {
    return Intl.message(
      'How it works?',
      name: 'howItworks',
      desc: '',
      args: [],
    );
  }

  /// `Make sure your bank supports autopay.`
  String get autopayBankSupport {
    return Intl.message(
      'Make sure your bank supports autopay.',
      name: 'autopayBankSupport',
      desc: '',
      args: [],
    );
  }

  /// `Check your`
  String get checkYour {
    return Intl.message(
      'Check your',
      name: 'checkYour',
      desc: '',
      args: [],
    );
  }

  /// `for the request.`
  String get forTheRequest {
    return Intl.message(
      'for the request.',
      name: 'forTheRequest',
      desc: '',
      args: [],
    );
  }

  /// `Set an amount you want to invest`
  String get setAutoPayAmount {
    return Intl.message(
      'Set an amount you want to invest',
      name: 'setAutoPayAmount',
      desc: '',
      args: [],
    );
  }

  /// `You can change the amount anytime.`
  String get amountChangeTxt {
    return Intl.message(
      'You can change the amount anytime.',
      name: 'amountChangeTxt',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get dateTime {
    return Intl.message(
      'Date & Time',
      name: 'dateTime',
      desc: '',
      args: [],
    );
  }

  /// `SETUP AUTO SAVE`
  String get setUpAutoSave {
    return Intl.message(
      'SETUP AUTO SAVE',
      name: 'setUpAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `cancelledUI`
  String get cancelledUi {
    return Intl.message(
      'cancelledUI',
      name: 'cancelledUi',
      desc: '',
      args: [],
    );
  }

  /// `Supported by 60+ banks for AutoPay`
  String get autoPayBanksSupported {
    return Intl.message(
      'Supported by 60+ banks for AutoPay',
      name: 'autoPayBanksSupported',
      desc: '',
      args: [],
    );
  }

  /// `Approve Request`
  String get autoPayApproveReq {
    return Intl.message(
      'Approve Request',
      name: 'autoPayApproveReq',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE AUTOSAVE`
  String get updateAutoSave {
    return Intl.message(
      'UPDATE AUTOSAVE',
      name: 'updateAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Additional Daily Benefits`
  String get additionalBenefits {
    return Intl.message(
      'Additional Daily Benefits',
      name: 'additionalBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Set up Autosave`
  String get saveAutoSaveTitle {
    return Intl.message(
      'Set up Autosave',
      name: 'saveAutoSaveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set up Autosave & earn daily tokens `
  String get saveAutoSaveSubTitle {
    return Intl.message(
      'Set up Autosave & earn daily tokens ',
      name: 'saveAutoSaveSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set Up`
  String get setUpText {
    return Intl.message(
      'Set Up',
      name: 'setUpText',
      desc: '',
      args: [],
    );
  }

  /// `Congrats!`
  String get congrats {
    return Intl.message(
      'Congrats!',
      name: 'congrats',
      desc: '',
      args: [],
    );
  }

  /// `Your fello Autosave account has been\nsuccessfully setup!`
  String get autoSaveSetUpSuccess {
    return Intl.message(
      'Your fello Autosave account has been\nsuccessfully setup!',
      name: 'autoSaveSetUpSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Autosave Details`
  String get autoSaveDetails {
    return Intl.message(
      'Autosave Details',
      name: 'autoSaveDetails',
      desc: '',
      args: [],
    );
  }

  /// `Primary UPI`
  String get primaryUPI {
    return Intl.message(
      'Primary UPI',
      name: 'primaryUPI',
      desc: '',
      args: [],
    );
  }

  /// `No Autosave Details available`
  String get autoSaveDetailsEmpty {
    return Intl.message(
      'No Autosave Details available',
      name: 'autoSaveDetailsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Autosave Inactive`
  String get autoSaveInActive {
    return Intl.message(
      'Autosave Inactive',
      name: 'autoSaveInActive',
      desc: '',
      args: [],
    );
  }

  /// `AMOUNT SAVED`
  String get amountSaved {
    return Intl.message(
      'AMOUNT SAVED',
      name: 'amountSaved',
      desc: '',
      args: [],
    );
  }

  /// `Your Autosave account is `
  String get yourAutoSave {
    return Intl.message(
      'Your Autosave account is ',
      name: 'yourAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Restart Autosave`
  String get btnRestartAutoSave {
    return Intl.message(
      'Restart Autosave',
      name: 'btnRestartAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Resume Autosave`
  String get resumeAutoSave {
    return Intl.message(
      'Resume Autosave',
      name: 'resumeAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Pause Autosave`
  String get pauseAutoSave {
    return Intl.message(
      'Pause Autosave',
      name: 'pauseAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure ?`
  String get areYouSure {
    return Intl.message(
      'Are you sure ?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `You will lose out on automated savings & many exclusive rewards⏸️`
  String get loseAutoSave {
    return Intl.message(
      'You will lose out on automated savings & many exclusive rewards⏸️',
      name: 'loseAutoSave',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message(
      'Single',
      name: 'single',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid bank IFSC`
  String get validIFSC {
    return Intl.message(
      'Please enter a valid bank IFSC',
      name: 'validIFSC',
      desc: '',
      args: [],
    );
  }

  /// `Bank IFSC Code`
  String get bankIFSC {
    return Intl.message(
      'Bank IFSC Code',
      name: 'bankIFSC',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Bank Account Number`
  String get invalidBankAcc {
    return Intl.message(
      'Invalid Bank Account Number',
      name: 'invalidBankAcc',
      desc: '',
      args: [],
    );
  }

  /// `Bank account numbers did not match`
  String get bankAccDidNotMatch {
    return Intl.message(
      'Bank account numbers did not match',
      name: 'bankAccDidNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid account number`
  String get enterValidAcc {
    return Intl.message(
      'Please enter a valid account number',
      name: 'enterValidAcc',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Account Number`
  String get confirmAccNo {
    return Intl.message(
      'Confirm Account Number',
      name: 'confirmAccNo',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Number`
  String get bankAccNoTitle {
    return Intl.message(
      'Bank Account Number',
      name: 'bankAccNoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter you name as per your bank`
  String get enterNameAsPerBank {
    return Intl.message(
      'Please enter you name as per your bank',
      name: 'enterNameAsPerBank',
      desc: '',
      args: [],
    );
  }

  /// `Bank Holder's Name`
  String get bankHolderName {
    return Intl.message(
      'Bank Holder\'s Name',
      name: 'bankHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Details`
  String get bankAccDetails {
    return Intl.message(
      'Bank Account Details',
      name: 'bankAccDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add Bank Details`
  String get addBankDetails {
    return Intl.message(
      'Add Bank Details',
      name: 'addBankDetails',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '------------------------' key

  /// `Apply a Coupon`
  String get txnApplyCoupon {
    return Intl.message(
      'Apply a Coupon',
      name: 'txnApplyCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Enter a Coupon Code here`
  String get txnEnterCoupon {
    return Intl.message(
      'Enter a Coupon Code here',
      name: 'txnEnterCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get txnApply {
    return Intl.message(
      'Apply',
      name: 'txnApply',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a code to continue`
  String get txnEnterCode {
    return Intl.message(
      'Please enter a code to continue',
      name: 'txnEnterCode',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Coupon code`
  String get txnInvalidCouponCode {
    return Intl.message(
      'Invalid Coupon code',
      name: 'txnInvalidCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Active Coupons`
  String get txnActiveCoupon {
    return Intl.message(
      'Active Coupons',
      name: 'txnActiveCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Details`
  String get txnDetailsTitle {
    return Intl.message(
      'Transaction Details',
      name: 'txnDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Amount`
  String get txnAmountTitle {
    return Intl.message(
      'Transaction Amount',
      name: 'txnAmountTitle',
      desc: '',
      args: [],
    );
  }

  /// ` coupon applied`
  String get couponApplied {
    return Intl.message(
      ' coupon applied',
      name: 'couponApplied',
      desc: '',
      args: [],
    );
  }

  /// `Invoice could not be loaded`
  String get txnInvoiceFailed {
    return Intl.message(
      'Invoice could not be loaded',
      name: 'txnInvoiceFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please try in some time`
  String get txnTryAfterSomeTime {
    return Intl.message(
      'Please try in some time',
      name: 'txnTryAfterSomeTime',
      desc: '',
      args: [],
    );
  }

  /// `Have a different coupon code? `
  String get txnHavDiffCoupunCode {
    return Intl.message(
      'Have a different coupon code? ',
      name: 'txnHavDiffCoupunCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter here`
  String get txnEnterHereText {
    return Intl.message(
      'Enter here',
      name: 'txnEnterHereText',
      desc: '',
      args: [],
    );
  }

  /// `Your investment was successfully processed`
  String get txnInvestmentSuccess {
    return Intl.message(
      'Your investment was successfully processed',
      name: 'txnInvestmentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully saved`
  String get successfullySavedText {
    return Intl.message(
      'You have successfully saved',
      name: 'successfullySavedText',
      desc: '',
      args: [],
    );
  }

  /// `Please select a UPI App`
  String get txnSelectUPI {
    return Intl.message(
      'Please select a UPI App',
      name: 'txnSelectUPI',
      desc: '',
      args: [],
    );
  }

  /// `No UPI apps available`
  String get txnNoUPI {
    return Intl.message(
      'No UPI apps available',
      name: 'txnNoUPI',
      desc: '',
      args: [],
    );
  }

  /// `Could not find any installed UPI applications`
  String get txnCouldNotFindUPI {
    return Intl.message(
      'Could not find any installed UPI applications',
      name: 'txnCouldNotFindUPI',
      desc: '',
      args: [],
    );
  }

  /// `Your withdrawal is in progress`
  String get txnWithDrawalProgress {
    return Intl.message(
      'Your withdrawal is in progress',
      name: 'txnWithDrawalProgress',
      desc: '',
      args: [],
    );
  }

  /// `Your withdrawal was successfully processed`
  String get txnWithDrawalSuccess {
    return Intl.message(
      'Your withdrawal was successfully processed',
      name: 'txnWithDrawalSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter UPI ID`
  String get txnEnterUPI {
    return Intl.message(
      'Enter UPI ID',
      name: 'txnEnterUPI',
      desc: '',
      args: [],
    );
  }

  /// `Enter your UPI address: `
  String get txnEnterUPIFeild {
    return Intl.message(
      'Enter your UPI address: ',
      name: 'txnEnterUPIFeild',
      desc: '',
      args: [],
    );
  }

  /// `Approve Request on UPI app`
  String get txnApproveUPIReq {
    return Intl.message(
      'Approve Request on UPI app',
      name: 'txnApproveUPIReq',
      desc: '',
      args: [],
    );
  }

  /// `Pending UPI transactions`
  String get txnsPendingUPI {
    return Intl.message(
      'Pending UPI transactions',
      name: 'txnsPendingUPI',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Status`
  String get txnStatus {
    return Intl.message(
      'Transaction Status',
      name: 'txnStatus',
      desc: '',
      args: [],
    );
  }

  /// `COMPLETED`
  String get txnCompleted {
    return Intl.message(
      'COMPLETED',
      name: 'txnCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get txnEnterAmount {
    return Intl.message(
      'Enter amount',
      name: 'txnEnterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Approve payment\nrequest on your UPI app`
  String get txnApprovePaymentReq {
    return Intl.message(
      'Approve payment\nrequest on your UPI app',
      name: 'txnApprovePaymentReq',
      desc: '',
      args: [],
    );
  }

  /// `Do not press back until the payment is completed`
  String get txnDontPressBack {
    return Intl.message(
      'Do not press back until the payment is completed',
      name: 'txnDontPressBack',
      desc: '',
      args: [],
    );
  }

  /// `Page Expires in `
  String get txnPageExpiresIn {
    return Intl.message(
      'Page Expires in ',
      name: 'txnPageExpiresIn',
      desc: '',
      args: [],
    );
  }

  /// `Update amount`
  String get txnUpdateAmount {
    return Intl.message(
      'Update amount',
      name: 'txnUpdateAmount',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transaction`
  String get txnRecent {
    return Intl.message(
      'Recent Transaction',
      name: 'txnRecent',
      desc: '',
      args: [],
    );
  }

  /// `No Transactions to show yet`
  String get txnsEmpty {
    return Intl.message(
      'No Transactions to show yet',
      name: 'txnsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawable Balance`
  String get txnWithdrawablebalance {
    return Intl.message(
      'Withdrawable Balance',
      name: 'txnWithdrawablebalance',
      desc: '',
      args: [],
    );
  }

  /// `You can't withdraw more than available balance`
  String get txnWithDrawLimit {
    return Intl.message(
      'You can\'t withdraw more than available balance',
      name: 'txnWithDrawLimit',
      desc: '',
      args: [],
    );
  }

  /// `how are you gonna withdraw less than 1?`
  String get txnWithDrawMin {
    return Intl.message(
      'how are you gonna withdraw less than 1?',
      name: 'txnWithDrawMin',
      desc: '',
      args: [],
    );
  }

  /// `Your withdrawal request has been placed and the money will be credited to your account in the next 1-2 business working days`
  String get txnWithDrawReq {
    return Intl.message(
      'Your withdrawal request has been placed and the money will be credited to your account in the next 1-2 business working days',
      name: 'txnWithDrawReq',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get txns {
    return Intl.message(
      'Transactions',
      name: 'txns',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get txnHistory {
    return Intl.message(
      'Transaction History',
      name: 'txnHistory',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Looking for more transactions, please wait ...`
  String get moretxns {
    return Intl.message(
      'Looking for more transactions, please wait ...',
      name: 'moretxns',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------' key

  /// `Happy Hour is over`
  String get happyHourIsOver {
    return Intl.message(
      'Happy Hour is over',
      name: 'happyHourIsOver',
      desc: '',
      args: [],
    );
  }

  /// `Missed out on the happy hour offer?`
  String get missedHappyHour {
    return Intl.message(
      'Missed out on the happy hour offer?',
      name: 'missedHappyHour',
      desc: '',
      args: [],
    );
  }

  /// `Get notified when the next happy hour is live`
  String get getHappyHourNotified {
    return Intl.message(
      'Get notified when the next happy hour is live',
      name: 'getHappyHourNotified',
      desc: '',
      args: [],
    );
  }

  /// `Your Happy hour notifications is set!`
  String get happyHourNotificationSetPrimary {
    return Intl.message(
      'Your Happy hour notifications is set!',
      name: 'happyHourNotificationSetPrimary',
      desc: '',
      args: [],
    );
  }

  /// `We will notify you before the next happy hour starts`
  String get happyHourNotificationSetSecondary {
    return Intl.message(
      'We will notify you before the next happy hour starts',
      name: 'happyHourNotificationSetSecondary',
      desc: '',
      args: [],
    );
  }

  /// `You have made a transaction during \nHappy Hours!`
  String get txnHappyHours {
    return Intl.message(
      'You have made a transaction during \nHappy Hours!',
      name: 'txnHappyHours',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Happy Hour ending in `
  String get happyHoursEndingin {
    return Intl.message(
      'Happy Hour ending in ',
      name: 'happyHoursEndingin',
      desc: '',
      args: [],
    );
  }

  /// `Happy Hour ends in `
  String get happyHoursEndsIn {
    return Intl.message(
      'Happy Hour ends in ',
      name: 'happyHoursEndsIn',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '---------------------------------------------' key

  /// `Secure Fello`
  String get secureFelloTitle {
    return Intl.message(
      'Secure Fello',
      name: 'secureFelloTitle',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Need more help?`
  String get needHelp {
    return Intl.message(
      'Need more help?',
      name: 'needHelp',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------------------------' key

  /// `Current Tokens:`
  String get currentTokens {
    return Intl.message(
      'Current Tokens:',
      name: 'currentTokens',
      desc: '',
      args: [],
    );
  }

  /// `You ran out of Fello tokens, here are some ways to get back on the track:`
  String get ranOutOfTokens {
    return Intl.message(
      'You ran out of Fello tokens, here are some ways to get back on the track:',
      name: 'ranOutOfTokens',
      desc: '',
      args: [],
    );
  }

  /// `Save More Money`
  String get saveMoney {
    return Intl.message(
      'Save More Money',
      name: 'saveMoney',
      desc: '',
      args: [],
    );
  }

  /// `Get 1 token for every Rupee saved`
  String get get1Token {
    return Intl.message(
      'Get 1 token for every Rupee saved',
      name: 'get1Token',
      desc: '',
      args: [],
    );
  }

  /// `Tokens Required`
  String get tokensRequired {
    return Intl.message(
      'Tokens Required',
      name: 'tokensRequired',
      desc: '',
      args: [],
    );
  }

  /// `SKIP WITH {cost} TOKENS`
  String skipWithtokenCost(Object cost) {
    return Intl.message(
      'SKIP WITH $cost TOKENS',
      name: 'skipWithtokenCost',
      desc: '',
      args: [cost],
    );
  }

  /// `Tokens Deducted`
  String get tokensDeducted {
    return Intl.message(
      'Tokens Deducted',
      name: 'tokensDeducted',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '--------------------------------------' key

  /// `Journey failed to load`
  String get jFailed {
    return Intl.message(
      'Journey failed to load',
      name: 'jFailed',
      desc: '',
      args: [],
    );
  }

  /// `Loading more levels for you,please wait`
  String get jLoadinglevels {
    return Intl.message(
      'Loading more levels for you,please wait',
      name: 'jLoadinglevels',
      desc: '',
      args: [],
    );
  }

  /// `Level `
  String get jLevel {
    return Intl.message(
      'Level ',
      name: 'jLevel',
      desc: '',
      args: [],
    );
  }

  /// `Hello World`
  String get jBanner1 {
    return Intl.message(
      'Hello World',
      name: 'jBanner1',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to this Universe and win `
  String get jBanner2 {
    return Intl.message(
      'Welcome to this Universe and win ',
      name: 'jBanner2',
      desc: '',
      args: [],
    );
  }

  /// `Milestone {index}`
  String jMileStone(Object index) {
    return Intl.message(
      'Milestone $index',
      name: 'jMileStone',
      desc: '',
      args: [index],
    );
  }

  /// `You have completed this milestone`
  String get mileStoneCompleted {
    return Intl.message(
      'You have completed this milestone',
      name: 'mileStoneCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Win a {ticketType} ticket`
  String winATicket(Object ticketType) {
    return Intl.message(
      'Win a $ticketType ticket',
      name: 'winATicket',
      desc: '',
      args: [ticketType],
    );
  }

  /// `SKIP MILESTONE`
  String get jSkipMileStone {
    return Intl.message(
      'SKIP MILESTONE',
      name: 'jSkipMileStone',
      desc: '',
      args: [],
    );
  }

  /// `YOU WON`
  String get jWon {
    return Intl.message(
      'YOU WON',
      name: 'jWon',
      desc: '',
      args: [],
    );
  }

  /// `Skip Milestone?`
  String get jSkipMilestoneSecondary {
    return Intl.message(
      'Skip Milestone?',
      name: 'jSkipMilestoneSecondary',
      desc: '',
      args: [],
    );
  }

  /// `To skip this milestone and go one level ahead, save in any of the asset`
  String get jSkipMileStoneDesc {
    return Intl.message(
      'To skip this milestone and go one level ahead, save in any of the asset',
      name: 'jSkipMileStoneDesc',
      desc: '',
      args: [],
    );
  }

  /// `Amount of Invest`
  String get jInvestAmountTitile {
    return Intl.message(
      'Amount of Invest',
      name: 'jInvestAmountTitile',
      desc: '',
      args: [],
    );
  }

  /// `Milestone Skipped Successfully`
  String get jMileStoneSKipSuccessTitle1 {
    return Intl.message(
      'Milestone Skipped Successfully',
      name: 'jMileStoneSKipSuccessTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Let's get to the next milestone`
  String get jMileStoneSKipSuccessTitle2 {
    return Intl.message(
      'Let\'s get to the next milestone',
      name: 'jMileStoneSKipSuccessTitle2',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-------------------' key

  /// `FAQs`
  String get faqs {
    return Intl.message(
      'FAQs',
      name: 'faqs',
      desc: '',
      args: [],
    );
  }

  /// `No FAQs available at the moment`
  String get faqEmpty {
    return Intl.message(
      'No FAQs available at the moment',
      name: 'faqEmpty',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '---------------------------------------' key

  /// `Win upto Rs.{prizeAmount}`
  String gameRewardsAmount(Object prizeAmount) {
    return Intl.message(
      'Win upto Rs.$prizeAmount',
      name: 'gameRewardsAmount',
      desc: '',
      args: [prizeAmount],
    );
  }

  /// `Win upto `
  String get gameWinUptoTitle {
    return Intl.message(
      'Win upto ',
      name: 'gameWinUptoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Game of the week`
  String get gameOfWeek {
    return Intl.message(
      'Game of the week',
      name: 'gameOfWeek',
      desc: '',
      args: [],
    );
  }

  /// `Explore More Games`
  String get moreGamesTitle {
    return Intl.message(
      'Explore More Games',
      name: 'moreGamesTitle',
      desc: '',
      args: [],
    );
  }

  /// `New games are added regularly. Keep checking out`
  String get moreGamesSubTitle {
    return Intl.message(
      'New games are added regularly. Keep checking out',
      name: 'moreGamesSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Games are played with Fello tokens`
  String get gamesSafetyTitle {
    return Intl.message(
      'Games are played with Fello tokens',
      name: 'gamesSafetyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fello games do not use any money from your savings or investments`
  String get gamesSafetySubTitle {
    return Intl.message(
      'Fello games do not use any money from your savings or investments',
      name: 'gamesSafetySubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed`
  String get redeemed {
    return Intl.message(
      'Redeemed',
      name: 'redeemed',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message(
      'Redeem',
      name: 'redeem',
      desc: '',
      args: [],
    );
  }

  /// `Playing`
  String get playing {
    return Intl.message(
      'Playing',
      name: 'playing',
      desc: '',
      args: [],
    );
  }

  /// `This week`
  String get topScroresText1 {
    return Intl.message(
      'This week',
      name: 'topScroresText1',
      desc: '',
      args: [],
    );
  }

  /// `s top scorers: `
  String get topScroresText2 {
    return Intl.message(
      's top scorers: ',
      name: 'topScroresText2',
      desc: '',
      args: [],
    );
  }

  /// `Updated on:`
  String get updatedOn {
    return Intl.message(
      'Updated on:',
      name: 'updatedOn',
      desc: '',
      args: [],
    );
  }

  /// `Game Winners`
  String get gameWinners {
    return Intl.message(
      'Game Winners',
      name: 'gameWinners',
      desc: '',
      args: [],
    );
  }

  /// `Top Winners`
  String get topWinners {
    return Intl.message(
      'Top Winners',
      name: 'topWinners',
      desc: '',
      args: [],
    );
  }

  /// `Players`
  String get players {
    return Intl.message(
      'Players',
      name: 'players',
      desc: '',
      args: [],
    );
  }

  /// `Best :`
  String get bestPoints {
    return Intl.message(
      'Best :',
      name: 'bestPoints',
      desc: '',
      args: [],
    );
  }

  /// `YOU`
  String get you {
    return Intl.message(
      'YOU',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get btnNew {
    return Intl.message(
      'New',
      name: 'btnNew',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '----------------------------------------' key

  /// `Fin-gyan`
  String get blogsTitle {
    return Intl.message(
      'Fin-gyan',
      name: 'blogsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message(
      'Blogs',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Read about the world of games and finance`
  String get blogsSubTitle {
    return Intl.message(
      'Read about the world of games and finance',
      name: 'blogsSubTitle',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '-----------------------------------------' key

  /// `Challenges`
  String get challenges {
    return Intl.message(
      'Challenges',
      name: 'challenges',
      desc: '',
      args: [],
    );
  }

  /// `Take part in fun and exciting contests`
  String get contestTitle {
    return Intl.message(
      'Take part in fun and exciting contests',
      name: 'contestTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Made with `
  String get madeWith {
    return Intl.message(
      'Made with ',
      name: 'madeWith',
      desc: '',
      args: [],
    );
  }

  /// ` in India`
  String get inIndia {
    return Intl.message(
      ' in India',
      name: 'inIndia',
      desc: '',
      args: [],
    );
  }

  /// `Enjoying Fello?`
  String get enjoyingFello {
    return Intl.message(
      'Enjoying Fello?',
      name: 'enjoyingFello',
      desc: '',
      args: [],
    );
  }

  /// `We are constantly improving the app and your feedback would be really valuable.`
  String get improvingAppText {
    return Intl.message(
      'We are constantly improving the app and your feedback would be really valuable.',
      name: 'improvingAppText',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get selectRating {
    return Intl.message(
      'Please select a rating',
      name: 'selectRating',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message(
      'Rate',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your feedback`
  String get feedBackGreeting1 {
    return Intl.message(
      'Thank you for your feedback',
      name: 'feedBackGreeting1',
      desc: '',
      args: [],
    );
  }

  /// `We hope to serve you better`
  String get feedBackGreeting2 {
    return Intl.message(
      'We hope to serve you better',
      name: 'feedBackGreeting2',
      desc: '',
      args: [],
    );
  }

  /// `Maybe later`
  String get mayBeLater {
    return Intl.message(
      'Maybe later',
      name: 'mayBeLater',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
