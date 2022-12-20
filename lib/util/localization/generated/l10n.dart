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

  /// `Your Account Has Been blocked`
  String get obBlockedTitle {
    return Intl.message(
      'Your Account Has Been blocked',
      name: 'obBlockedTitle',
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

  /// `Need Help?`
  String get obNeedHelp {
    return Intl.message(
      'Need Help?',
      name: 'obNeedHelp',
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

  /// `Buy 24K pure Digital Gold`
  String get buyGold {
    return Intl.message(
      'Buy 24K pure Digital Gold',
      name: 'buyGold',
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

  /// `Minimum sell amount is ₹ 10`
  String get minimumAmount {
    return Intl.message(
      'Minimum sell amount is ₹ 10',
      name: 'minimumAmount',
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

  /// `Win ₹1 Crore!`
  String get win1Crore {
    return Intl.message(
      'Win ₹1 Crore!',
      name: 'win1Crore',
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
