import 'package:felloapp/util/assets.dart';

/// This file contains the constants used in scratch card detail page

class ScratchCardConstants {
  static const String tambolaTitan = "Ticket Titan";
  static const String explorer = "Explorer";
  static const String welcomeFello = "Welcome to Fello";
  static const String whatAFello = "What a Fello";
  static const String savingsMarvel = "Savings Marvel";
  static const String happyFello = "Happy Fello";
  static const String sevenDayChamp = "7 Day Champ";
  static const String quizMaster = "Quiz Master";
  static const String referralNinja = "Referral Ninja";
  static const String gamingLegend = "Gaming Legend";
  static const String dailyBonus = "dailyBonus";
  static const String general = "General";

  static Map<String, String> getTitle(String tag) {
    switch (tag) {
      case dailyBonus:
      case sevenDayChamp:
        return {
          "title": "Claimed",
          "subtitle": 'Daily Bonus',
        };
      case tambolaTitan:
        return {
          "title": "Won in",
          "subtitle": 'Ticket Draws',
        };
      case explorer:
        return {
          "title": "Completed a",
          "subtitle": 'Journey Milestone',
        };

      case welcomeFello:
        return {
          "title": "Started your",
          "subtitle": 'Savings Journey',
        };
      case whatAFello:
        return {
          "title": "Completed",
          "subtitle": 'Investment',
        };
      case savingsMarvel:
        return {
          "title": "Completed",
          "subtitle": 'Autosave',
        };
      case happyFello:
        return {
          "title": "Saved in",
          "subtitle": 'Happy Hours',
        };
      case quizMaster:
        return {
          "title": "Won in",
          "subtitle": 'Quiz',
        };
      case referralNinja:
        return {
          "title": "Completed",
          "subtitle": 'Friend Referral',
        };
      case gamingLegend:
        return {
          "title": "Won in a",
          "subtitle": 'Game',
        };
      case general:
        return {
          "title": "Won on",
          "subtitle": 'Fello',
        };
      default:
        return {
          "title": "Won on",
          "subtitle": 'Fello',
        };
    }
  }

  static String getBadges(String tag) {
    switch (tag) {
      case dailyBonus:
      case sevenDayChamp:
        return Assets.sevenDayChampBadge;
      case tambolaTitan:
        return Assets.tambolaTitanBadge;
      case explorer:
        return Assets.explorerBadge;
      case welcomeFello:
        return Assets.sevenDayChampBadge;
      case whatAFello:
        return Assets.whatAFelloBadge;
      case savingsMarvel:
        return Assets.savingsMarvelBadge;
      case happyFello:
        return Assets.happyFelloBadge;
      case quizMaster:
        return Assets.quizMasterBadge;
      case referralNinja:
        return Assets.referralNinjaBadge;
      case gamingLegend:
        return Assets.gamingLegendBadge;
      case general:
        return Assets.tambolaTitanBadge;
      default:
        return Assets.tambolaTitanBadge;
    }
  }
}
