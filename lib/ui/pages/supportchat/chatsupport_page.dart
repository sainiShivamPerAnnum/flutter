import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:lottie/lottie.dart';

import '../../../base_util.dart';

class ChatSupport extends StatefulWidget {
  ChatSupport({Key key}) : super(key: key);
  @override
  _ChatSupportState createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {
  BaseUtil _baseUtil = locator<BaseUtil>();
  var _userid;
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
    return Scaffold(
      body: Center(child: 
        FutureBuilder(
          future: _setupFreshchat(),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.done) {
              Freshchat.showConversations();
              Navigator.pop(context);
            }
            return LottieBuilder.asset('images/lottie/phone_loading.json', height: SizeConfig.screenHeight*0.2,);
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
    bool res = await _setUser();
    return res;
  }

  Future<bool> _setUser() async {
    print('device token : ${_baseUtil.myUser.client_token}');
    Freshchat.setPushRegistrationToken(_baseUtil.myUser.client_token);
    FreshchatUser user = await Freshchat.getUser;
    print('user : ${user.toString()}');
    var _restore = user.getRestoreId();
    Freshchat.identifyUser(externalId: _userid, restoreId: 'c39d6427-0d6e-47e4-9279-e4520c991ccd');
    print('user id $_userid');
    print('restore id $_restore');
    // user id - NaQ56t18oxVpJ4aJtUBpLaaUHF22 restoreid - c39d6427-0d6e-47e4-9279-e4520c991ccd
    user.setFirstName('Nimit Test - 4');
    user.setEmail(_baseUtil.myUser.email);
    user.setPhone('+91', _baseUtil.myUser.mobile);
    Freshchat.setUser(user);
    return true;
  }
}