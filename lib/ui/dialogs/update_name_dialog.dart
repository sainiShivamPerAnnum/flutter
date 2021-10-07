import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateNameDialog extends StatefulWidget {
  @override
  _UpdateNameDialogState createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends State<UpdateNameDialog> {
  final userService = locator<UserService>();
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isUploading = false;
  TextEditingController _nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (_nameController.text == "") {
      _nameController.text = baseProvider.myUser.name;
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Update Name",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.largeTextSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              isUploading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: UiConstants.primaryColor,
                        size: 24.0,
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.7,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: UiConstants.primaryColor),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isUploading = !isUploading;
                                });
                                // baseProvider.myUser.name = _nameController.text.trim();
                                //Todo: update user service.
                                userService
                                    .setMyUserName(_nameController.text.trim());

                                baseProvider
                                    .setName(_nameController.text.trim());
                                dbProvider
                                    .updateUser(baseProvider.myUser)
                                    .then((flag) {
                                  setState(() {
                                    isUploading = false;
                                  });
                                  if (flag) {
                                    baseProvider.showPositiveAlert(
                                        'Update Succesful',
                                        'Your name has been updated',
                                        context);
                                    AppState.backButtonDispatcher.didPopRoute();
                                  } else {
                                    baseProvider.showNegativeAlert(
                                        'Update failed',
                                        'Your name could not be updated at the moment',
                                        context);
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Update",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth * 0.7,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () =>
                                AppState.backButtonDispatcher.didPopRoute(),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
