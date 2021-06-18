import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base_util.dart';

class ChatSupport extends StatefulWidget {
  ChatSupport({Key key}) : super(key: key);
  @override
  _ChatSupportState createState() => _ChatSupportState();
  static Future<int> getUnreadMessagesCount() async {
    var unreadCount = await Freshchat.getUnreadCountAsync;
    return unreadCount['count'];
  }
}

class _ChatSupportState extends State<ChatSupport> {
  BaseUtil baseProvider;
  var _userid;
  var _restoreStream;
  var _restoreStreamSubscription;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    _setupFreshchat().then((value) {
      if (value) {
        backButtonDispatcher.didPopRoute();
        Freshchat.showConversations();
      } else {
        backButtonDispatcher.didPopRoute();
        baseProvider.showNegativeAlert(
          'Error',
          'Something went wrong, please try again!',
          context,
        );
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!isInit) {
      isInit = true;
      Freshchat.identifyUser(externalId: baseProvider.myUser.uid);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: LottieBuilder.asset(
        'images/lottie/phone_loading.json',
        height: SizeConfig.screenHeight * 0.2,
        repeat: true,
      )
          //     FutureBuilder(
          //   future: _setupFreshchat(),
          //   builder: (context, snapshot) {
          //     print(AppState.screenStack);
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       if (snapshot.data == true) {
          //         Freshchat.showConversations();
          //         Navigator.pop(context);
          //       } else {
          //         // Future.delayed(Duration(seconds: 1), () {
          //         Navigator.pop(context);
          //         // backButtonDispatcher.didPopRoute();
          //         // });
          //         // Future(() {
          // baseProvider.showNegativeAlert(
          //     'Error', 'Something went wrong, please try again!', context,
          //     seconds: 3);

          //         // });
          //         // return LottieBuilder.asset(
          //         //   'images/lottie/phone_loading.json',
          //         //   height: SizeConfig.screenHeight * 0.2,
          //         //   repeat: true,
          //         // );
          //       }
          //     }
          // return LottieBuilder.asset(
          //   'images/lottie/phone_loading.json',
          //   height: SizeConfig.screenHeight * 0.2,
          //   repeat: true,
          // );
          //   },
          // )
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
    if (_user != null &&
        _prefs != null &&
        baseProvider != null &&
        baseProvider.myUser != null) {
      Freshchat.setPushRegistrationToken(baseProvider.myUser.client_token);
      storeRestoreId();
      var _restore;
      if (_prefs.getString('FRESHCHAT_RESTORE_ID') == null) {
        print('using default user restore id');
        _restore = _user.getRestoreId();
      } else {
        print('using stored restore id');
        _restore = _prefs.getString('FRESHCHAT_RESTORE_ID');
      }
      Freshchat.identifyUser(externalId: _userid, restoreId: _restore);
      print('user id $_userid');
      print('restore id $_restore');
      // user id - NaQ56t18oxVpJ4aJtUBpLaaUHF22 restoreid - c39d6427-0d6e-47e4-9279-e4520c991ccd
      _user.setFirstName(baseProvider.myUser.name);
      _user.setEmail(baseProvider.myUser.email);
      _user.setPhone('+91', baseProvider.myUser.mobile);
      Freshchat.setUser(_user);
      return true;
    } else {
      return false;
    }
  }

  void storeRestoreId() {
    _restoreStream = Freshchat.onRestoreIdGenerated;
    _restoreStreamSubscription = _restoreStream.listen((event) async {
      print('storing restore id');
      FreshchatUser _user = await Freshchat.getUser;
      var _restoreID = _user.getRestoreId();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      if (_prefs != null) {
        if (_prefs.getString("FRESHCHAT_RESTORE_ID") == null ||
            _prefs.getString("FRESHCHAT_RESTORE_ID") != _restoreID) {
          _prefs.setString("FRESHCHAT_RESTORE_ID", _restoreID);
        }
      }
    });
  }

  @override
  void dispose() {
    if (_restoreStreamSubscription != null) {
      _restoreStreamSubscription.cancel();
    }
    super.dispose();
  }
}
