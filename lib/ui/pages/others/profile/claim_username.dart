import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ClaimUsername extends StatefulWidget {
  @override
  _ClaimUsernameState createState() => _ClaimUsernameState();
}

class _ClaimUsernameState extends State<ClaimUsername> {
  final _usernameKey = new GlobalKey<UsernameState>();
  final _userService = locator<UserService>();
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool _isUpdating = false;
  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");

  setUsername() async {
    if (_usernameKey.currentState.model.formKey.currentState.validate()) {
      if (!await _usernameKey.currentState.model.validate()) {
        return false;
      }
      if (!_usernameKey.currentState.model.isLoading &&
          _usernameKey.currentState.model.isValid) {
        setState(() {
          _isUpdating = true;
        });
        String username =
            _usernameKey.currentState.model.username.trim().replaceAll('.', '@');
        if (regex.hasMatch(username) &&
            await dbProvider.checkIfUsernameIsAvailable(username)) {
          bool res = await dbProvider.setUsername(
              username, _userService.firebaseUser.uid);
          if (res) {
            baseProvider.setUsername(username);
            bool flag = await dbProvider.updateUser(_userService.baseUser);
            if (flag) {
              setState(() {
                _isUpdating = false;
              });
              BaseUtil.showPositiveAlert(
                  "Success!", "Username updated successfully");
              AppState.backButtonDispatcher.didPopRoute();
            } else {
              setState(() {
                _isUpdating = false;
              });
              BaseUtil.showNegativeAlert(
                'Oops! we ran into trouble',
                'Please try again in sometime',
              );
            }
          } else {
            setState(() {
              _isUpdating = false;
            });
            BaseUtil.showNegativeAlert(
              'Oops! we ran into trouble!',
              'Please try again in sometime',
            );
          }
        } else {
          setState(() {
            _isUpdating = false;
          });
          BaseUtil.showNegativeAlert(
            'Oops! we ran into trouble!',
            'Please try again in sometime',
          );
        }
      } else {
        BaseUtil.showNegativeAlert(
          "Error",
          "Please try again",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Scaffold(
      appBar: BaseUtil.getAppBar(context, "Claim Username"),
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
                          ? SpinKitThreeBounce(
                              color: UiConstants.spinnerColor2,
                              size: 18.0,
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
