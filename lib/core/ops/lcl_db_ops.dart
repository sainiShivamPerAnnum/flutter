import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

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

  Future<int> isUserOnboarded() async {
    try {
      final file = await _api.onboardFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      log.error("Didnt find onboarding flag. Defaulting to 0.");
      return 0;
    }
  }

  Future<bool> isConfettiRequired(int weekCde) async{
    try{
      final file = await _api.confettiFile;
      String contents = await file.readAsString();
      //check if confetti file has this week's code
      //if not, confetti is required
      return (int.parse(contents) != weekCde);
    }catch(e) {
      return true;
    }
  }

  Future saveConfettiUpdate(int weekCde) async {
    return _api.writeConfettiTrackFile('$weekCde');
  }

  Future saveOnboardStatus(bool flag) async {
    // Write the file
    int status = (flag)?1:0;
    return _api.writeOnboardFile('$status');
  }

  Future<int> isFreshUser() async {
    try {
      final file = await _api.freshUserFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      log.error("Didnt find fresh user flag. Defaulting to 0.");
      return 0;
    }
  }

  Future saveFreshUserStatus(bool flag) async {
    // Write the file
    int status = (flag)?1:0;
    return _api.writeFreshUserFile('$status');
  }

  Future<bool> deleteLocalAppData() async{
    try{
      await _api.deleteOnboardFile();
    }catch(e) {
      log.error('Failed to delete onboarding file:' + e.toString());
    }
    try{
      await _api.deleteFreshUserFile();
    }catch(e) {
      log.error('Failed to delete fresh user file:' + e.toString());
    }
    try{
      await _api.deleteConfettiFile();
    }catch(e) {
      log.error('Failed to delete confetti track file:' + e.toString());
    }
    //User file deletion is crucial for return flag. Rest can be missing
    try{
      await _api.deleteUserFile();
      return true;
    }catch(e) {
      log.error('Failed to delete onboarding or user file:' + e.toString());
      return false;
    }

  }

}