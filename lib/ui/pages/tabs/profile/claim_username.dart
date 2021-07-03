import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/ui/pages/login/screens/username.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClaimUsername extends StatefulWidget {
  @override
  _ClaimUsernameState createState() => _ClaimUsernameState();
}

class _ClaimUsernameState extends State<ClaimUsername> {
  final _usernameKey = new GlobalKey<UsernameState>();
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool _isUpdating = false;
  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");

  setUsername() async {
    setState(() {
      _isUpdating = true;
    });
    String username =
        _usernameKey.currentState.username.text.trim().replaceAll('.', '@');
    if (regex.hasMatch(username) &&
        await dbProvider.checkIfUsernameIsAvailable(username)) {
      bool res =
          await dbProvider.setUsername(username, baseProvider.firebaseUser.uid);
      if (res) {
        baseProvider.setUsername(username);
        bool flag = await dbProvider.updateUser(baseProvider.myUser);
        if (flag) {
          setState(() {
            _isUpdating = false;
          });
          baseProvider.showPositiveAlert("Username Added!", "Yayy", context);
          backButtonDispatcher.didPopRoute();
        } else {
          setState(() {
            _isUpdating = false;
          });
          baseProvider.showNegativeAlert('Oops! we ran into trouble',
              'Please try again in sometime', context);
        }
      } else {
        setState(() {
          _isUpdating = false;
        });
        baseProvider.showNegativeAlert('Oops! we ran into trouble!',
            'Please try again in sometime', context);
      }
    } else {
      setState(() {
        _isUpdating = false;
      });
      baseProvider.showNegativeAlert('Oops! we ran into trouble!',
          'Please try again in sometime', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Scaffold(
      appBar: BaseUtil.getAppBar(context),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: ListView(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                ),
                Username(
                  key: _usernameKey,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: SizeConfig.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _isUpdating ? () {} : setUsername,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 24),
                      width: SizeConfig.screenWidth -
                          SizeConfig.blockSizeHorizontal * 10,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: UiConstants.primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: _isUpdating
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Set username",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
