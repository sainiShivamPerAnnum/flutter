import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base_util.dart';

class ChatSupport extends StatefulWidget {
  const ChatSupport({Key key}) : super(key: key);

  @override
  _ChatSupportState createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {
  BaseUtil baseProvider;
  var _userid;
  var _restoreStream;
  var _restoreStreamSubscription;
  bool isInit = false;
  String isFreshchatLoaded = "waiting";

  @override
  void initState() {
    super.initState();
    _setUser().then((value) {
      setState(() {
        isFreshchatLoaded = (value) ? 'done' : 'error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!isInit) {
      isInit = true;
      Freshchat.identifyUser(externalId: baseProvider.myUser.uid);
    }
    if (isFreshchatLoaded == "done") {
      Freshchat.showConversations();
      Navigator.pop(context);
    } else if (isFreshchatLoaded == "error") {
      Navigator.of(context).pop();
      baseProvider.showNegativeAlert(
          'Error', 'Something went wrong, please try again!', context,
          seconds: 3);
    }
    return Container(
      color: Colors.white24,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SpinKitFadingCircle(
              size: SizeConfig.screenWidth * 0.2,
              color: UiConstants.primaryColor,
            ),
          ),
        ),
      ),
    );
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
