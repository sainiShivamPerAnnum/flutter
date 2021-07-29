import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class PanService extends ChangeNotifier {
  PanService();

  BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();
  HttpModel httpProvider = locator<HttpModel>();


  Future<String> getUserPan() async{
    ///assumption: if they were never onboarded to augmont, they havent added their pan
    if(!baseProvider.myUser.isAugmontOnboarded) {
      return null;
    }
    ///check if user added their pan in base user
    if(baseProvider.myUser.pan != null && baseProvider.myUser.pan.isNotEmpty) {
      return baseProvider.myUser.pan;
    }else{
      Map<String,dynamic> encPan = await dbProvider.getEncodedUserPan(baseProvider.myUser.uid);
      if(encPan == null) return null;
      ///decrypt pan number

    }
  }
}