/// This file contains the constants used in scratch card detail page

class ScratchCardConstants {
  static const String tambolaTitan = "Tambola Titan";
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
          "subtitle": 'Tambola',
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
          "title": "Won in",
          "subtitle": 'a Game',
        };
      case general:
        return {
          "title": "Won in",
          "subtitle": 'Tambola',
        };
      default:
        return {
          "title": "Won in",
          "subtitle": 'Tambola',
        };
    }
  }
}
