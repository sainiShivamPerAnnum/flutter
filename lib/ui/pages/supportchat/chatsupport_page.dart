import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';

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
    gallerySelectionEnabled: true);
    _userid = _baseUtil.myUser.email;
    Freshchat.identifyUser(externalId: _userid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
        TextButton(
          child: Text('Contact'), 
          onPressed: () async {
            await _setUser();
            await _setupNotifications();
            Freshchat.showConversations();
          },
        ),
      ),
    );
  }
  Future<void> _setupNotifications() async {
    Freshchat.setPushRegistrationToken(_baseUtil.myUser.client_token);
  }
  Future<void> _setUser() async {
    FreshchatUser user = await Freshchat.getUser;
    var _restore = user.getRestoreId();
    Freshchat.identifyUser(externalId: _userid, restoreId: _restore);
    print('user id $_userid');
    print('restore id $_restore');
    user.setFirstName('Nimit Test - 2');
    user.setEmail(_baseUtil.myUser.email);
    user.setPhone('+91', _baseUtil.myUser.mobile);
    Freshchat.setUser(user);
  }
}