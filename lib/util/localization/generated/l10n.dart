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

  /// `My Profile`
  String get profileTitle {
    return Intl.message(
      'My Profile',
      name: 'profileTitle',
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