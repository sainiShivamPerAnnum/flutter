import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDBModel extends ChangeNotifier {
  LocalApi _api = locator<LocalApi>();
  final Log log = new Log("LocalDBModel");

  // Future<BaseUser> getUser() async {
  //   try{
  //     List<String> contents = await _api.readUserFile();
  //     return BaseUser.parseFile(contents);
  //   }catch(e) {
  //     log.error("Unable to fetch user from local store." + e.toString());
  //     return null;
  //   }
  // }
  //
  // Future<bool> saveUser(BaseUser user) async{
  //   try {
  //     await _api.writeUserFile(user.toFileString());
  //     return true;
  //   }catch(e) {
  //     log.error("Failed to store user details in local db: " + e.toString());
  //     return false;
  //   }
  // }

  Future<int> isTambolaResultProcessingDone() async {
    try {
      final file = await _api.tambolaResultFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      log.error("Didnt find onboarding flag. Defaulting to 0.");
      return 0;
    }
  }

  Future<bool> isConfettiRequired(int weekCde) async {
    try {
      final file = await _api.confettiFile;
      String contents = await file.readAsString();
      //check if confetti file has this week's code
      //if not, confetti is required
      return (int.parse(contents) != weekCde);
    } catch (e) {
      return true;
    }
  }

  Future saveConfettiUpdate(int weekCde) async {
    return _api.writeConfettiTrackFile('$weekCde');
  }

  Future saveTambolaResultProcessingStatus(bool flag) async {
    // Write the file
    int status = (flag) ? 1 : 0;
    return _api.writeTmbResultFile('$status');
  }

  Future<bool> get showTambolaTutorial async {
    try {
      final file = await _api.tambolaTutorialFile;
      if (file == null) return true;
      String contents = await file.readAsString();
      if (contents == null || contents.isEmpty) return true;

      int flag = int.parse(contents);
      return (flag == 1);
    } catch (e) {
      log.error("Didnt find fresh tambola flag. Defaulting to 0.");
      return true;
    }
  }

  set setShowTambolaTutorial(bool flag) {
    int status = (flag) ? 1 : 0;
    _api.writeFreshTambolaTutorialFile('$status');
  }

  Future<bool> get showHomeTutorial async {
    //home tutorial only shown during signup and not signin
    try {
      final file = await _api.homeTutorialFile;
      if (file == null) return true;
      String contents = await file.readAsString();
      if (contents == null || contents.isEmpty) return true; //default to true

      int flag = int.parse(contents);
      return (flag == 1);
    } catch (e) {
      log.error("Didnt find fresh home tutorial flag. Defaulting to true.");
      return true;
    }
  }

  set setShowHomeTutorial(bool flag) {
    int status = (flag) ? 1 : 0;
    _api.writeFreshHomeTutorialFile('$status');
  }

  Future<bool> savePrizeClaimChoice(PrizeClaimChoice choice) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (choice == PrizeClaimChoice.AMZ_VOUCHER) {
        prefs.setString("claimChoice", 'agv');
      } else if (choice == PrizeClaimChoice.GOLD_CREDIT) {
        prefs.setString("claimChoice", "adg");
      } else {
        prefs.setString("claimChoice", "na");
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<PrizeClaimChoice> getPrizeClaimChoice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String data = prefs.getString("claimChoice");
      if (data == "agv") {
        return PrizeClaimChoice.AMZ_VOUCHER;
      } else if (data == "adg") {
        return PrizeClaimChoice.GOLD_CREDIT;
      }

      return PrizeClaimChoice.NA;
    } catch (e) {
      return PrizeClaimChoice.NA;
    }
  }

  Future<bool> deleteLocalAppData() async {
    try {
      await _api.deleteTmbResultFile();
    } catch (e) {
      log.error('Failed to delete onboarding file:' + e.toString());
    }
    try {
      await _api.deleteFreshTambolaTutorialFile();
    } catch (e) {
      log.error('Failed to delete fresh tambola tutorial file:' + e.toString());
    }
    try {
      await _api.deleteFreshHomeTutorialFile();
    } catch (e) {
      log.error('Failed to delete fresh user file:' + e.toString());
    }
    try {
      await _api.deleteConfettiFile();
    } catch (e) {
      log.error('Failed to delete confetti track file:' + e.toString());
    }
    //User file deletion is crucial for return flag. Rest can be missing
    try {
      await _api.deleteUserFile();
      return true;
    } catch (e) {
      log.error('Failed to delete onboarding or user file:' + e.toString());
      return false;
    }
  }

  Future<void> updateSecurityPrompt(bool flag) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setBool("SECURITY_PROMPT", flag);
    } catch (e) {
      log.debug("Error while updating app open count");
      print(e.toString());
    }
  }

  Future<bool> showSecurityPrompt() async {
    bool flag = false;
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      if (_prefs.containsKey("SECURITY_PROMPT")) {
        flag = _prefs.getBool("SECURITY_PROMPT");
      } else {
        flag = false;
      }
      return flag;
    } catch (e) {
      log.debug("Error while fetching app open count.");
      return flag;
    }
  }

  Future<bool> saveDailyPicksAnimStatus(int weekday) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      _prefs.setInt("DPAS", weekday);
      return true;
    } catch (e) {
      log.debug("Error while saving the daily pick status");
      return false;
    }
  }

  Future<int> getDailyPickAnimLastDay() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt("DPAS");
  }
}
