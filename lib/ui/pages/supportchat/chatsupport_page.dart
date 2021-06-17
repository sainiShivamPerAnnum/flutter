import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base_util.dart';

class ChatSupport extends StatefulWidget {
  ChatSupport({Key key}) : super(key: key);
  @override
  _ChatSupportState createState() => _ChatSupportState();
  static Future<int> getUnreadMessagesCount() async {
    Freshchat.init('745692b3-598d-44f0-a74d-1869e44d5549', '2835c3bd-78d6-4863-93d0-400786f23936', 'msdk.in.freshchat.com',
    gallerySelectionEnabled: true, themeName: 'FreshchatCustomTheme');
    var unreadCount = await Freshchat.getUnreadCountAsync;
    return unreadCount['count'];
  }
}

class _ChatSupportState extends State<ChatSupport> {
  BaseUtil _baseUtil = locator<BaseUtil>();
  var _userid;
  var _restoreStream;
  var _restoreStreamSubscription;
  @override
  void initState() { 
    super.initState();
    Freshchat.init('745692b3-598d-44f0-a74d-1869e44d5549', '2835c3bd-78d6-4863-93d0-400786f23936', 'msdk.in.freshchat.com',
    gallerySelectionEnabled: true, themeName: 'FreshchatCustomTheme');
    _userid = _baseUtil.myUser.uid;
    Freshchat.identifyUser(externalId: _userid);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: 
        FutureBuilder(
          future: _setupFreshchat(),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.done) {
              if(snapshot.data==true) {
                Freshchat.showConversations();
                Navigator.pop(context);
              }
              else {
                Future.delayed(Duration(seconds: 5),(){Navigator.pop(context);});
                Future((){
                  _baseUtil.showNegativeAlert('Error', 'Something went wrong, please try again!', context, seconds: 3);
                });
                return LottieBuilder.asset('images/lottie/phone_loading.json', height: SizeConfig.screenHeight*0.2,repeat: true,);
              }
            }
            return LottieBuilder.asset('images/lottie/phone_loading.json', height: SizeConfig.screenHeight*0.2,repeat: true,);
          },)
        // TextButton(
        //  onPressed: () async {
        //    await _setUser().then((value) {
        //      Freshchat.showConversations();
        //    });
        //  },
        //   child: Text('contact'),
        // )
      ),
    );
  }

  Future<bool> _setupFreshchat() async {
    bool _res = await _setUser();
    return _res;
  }

  Future<bool> _setUser() async {
    FreshchatUser _user = await Freshchat.getUser;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_user!=null && _prefs!=null && _baseUtil!=null && _baseUtil.myUser!=null) {
      Freshchat.setPushRegistrationToken(_baseUtil.myUser.client_token);
      storeRestoreId();
      var _restore;
      if(_prefs.getString('FRESHCHAT_RESTORE_ID')==null) {
        print('using default user restore id');
        _restore = _user.getRestoreId();
      }
      else {
        print('using stored restore id');
        _restore = _prefs.getString('FRESHCHAT_RESTORE_ID');
      }
      Freshchat.identifyUser(externalId: _userid, restoreId: _restore);
      print('user id $_userid');
      print('restore id $_restore');
      // user id - NaQ56t18oxVpJ4aJtUBpLaaUHF22 restoreid - c39d6427-0d6e-47e4-9279-e4520c991ccd
      _user.setFirstName(_baseUtil.myUser.name);
      _user.setEmail(_baseUtil.myUser.email);
      _user.setPhone('+91', _baseUtil.myUser.mobile);
      Freshchat.setUser(_user);
      return true;
    }
    else {
      return false;
    }
  }

  void storeRestoreId() {
    _restoreStream = Freshchat.onRestoreIdGenerated;
    _restoreStreamSubscription = _restoreStream.listen((event) async  {
      print('storing restore id');
      FreshchatUser _user = await Freshchat.getUser;
      var _restoreID = _user.getRestoreId();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      if(_prefs!=null) {
        if(_prefs.getString("FRESHCHAT_RESTORE_ID")==null || _prefs.getString("FRESHCHAT_RESTORE_ID")!=_restoreID) {
          _prefs.setString("FRESHCHAT_RESTORE_ID", _restoreID);
        }
      }
    });
  } 

  @override
  void dispose() {
    if(_restoreStreamSubscription!=null) {
      _restoreStreamSubscription.cancel();
    }
    super.dispose();
  }

}