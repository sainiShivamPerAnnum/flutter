import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NameInputScreen extends StatefulWidget {
  static const int index = 2;

  const NameInputScreen({Key key}) : super(key: key); //pager index

  @override
  State<StatefulWidget> createState() => NameInputScreenState();
}

class NameInputScreenState extends State<NameInputScreen> {
  NameInputScreenViewModel model;

  Log log = new Log("NameInputScreen");
  RegExp _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  int gen;
  int get gender => gen;

  static String stateChosenValue;
  String get state => stateChosenValue;

  String dateInputError = "";

  DateTime initialDate = DateTime(1997, 1, 1, 0, 0);
  List<bool> _selections = [false, true];

  Row abc(isInvested) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          // color: (_isInvested ?? false)
          //     ? UiConstants.primaryColor
          //     : Color(0xffe9e9ea),
          style: ElevatedButton.styleFrom(
            primary: (isInvested ?? false)
                ? UiConstants.primaryColor
                : Color(0xffe9e9ea),
            shadowColor: UiConstants.primaryColor.withOpacity(0.3),
          ),
          onPressed: () {
            setState(() {
              isInvested = true;
            });
          },
          child: Text(
            " YES ",
            style: TextStyle(
                color: (isInvested ?? false) ? Colors.white : Colors.grey),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: (isInvested ?? true)
                ? Color(0xffe9e9ea)
                : UiConstants.primaryColor,
            shadowColor: UiConstants.primaryColor.withOpacity(0.3),
          ),
          onPressed: () {
            setState(() {
              isInvested = false;
            });
          },
          child: Text(
            " NO ",
            style: TextStyle(
                color: (isInvested ?? true) ? Colors.grey : Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return BaseView<NameInputScreenViewModel>(
      onModelReady: (model) {
        model.init();
        this.model = model;
      },
      builder: (ctx, model, child) => Container(
        child: Form(
          key: model.formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFieldLabel(locale.obEmailLabel),
              model.emailEnabled
                  ? TextFormField(
                      controller: model.emailFieldController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: locale.obEmailHint,
                        prefixIcon: Icon(
                          Icons.email,
                          size: 20,
                          color: UiConstants.primaryColor,
                        ),
                        focusColor: UiConstants.primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        return (value != null &&
                                value.isNotEmpty &&
                                _emailRegex.hasMatch(value))
                            ? null
                            : 'Please enter a valid email';
                      },
                    )
                  : InkWell(
                      onTap: model.isContinuedWithGoogle
                          ? () {}
                          : model.showEmailOptions(context),
                      child: Container(
                        height: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: UiConstants.primaryColor.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.email,
                                size: 20,
                                color: model.isContinuedWithGoogle
                                    ? UiConstants.primaryColor
                                    : Colors.grey),
                            SizedBox(width: 12),
                            Text(
                              model.emailText,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            model.emailText != "Email"
                                ? Icon(
                                    Icons.verified,
                                    size: SizeConfig.blockSizeVertical * 2.4,
                                    color: UiConstants.primaryColor,
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
              TextFieldLabel(locale.obNameLabel),
              TextFormField(
                cursorColor: UiConstants.primaryColor,
                controller: model.nameFieldController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                ],
                decoration: InputDecoration(
                  hintText: locale.obNameHint,
                  prefixIcon: Icon(
                    Icons.person,
                    size: 20,
                    color: UiConstants.primaryColor,
                  ),
                ),
                autofocus: false,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please enter your name';
                },
              ),
              TextFieldLabel(locale.obGenderLabel),
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: UiConstants.primaryColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      Assets.gender,
                      height: 20,
                      color:
                          gen == null ? Colors.grey : UiConstants.primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            iconEnabledColor: UiConstants.primaryColor,
                            value: gen,
                            hint: Text(locale.obGenderHint),
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  locale.obGenderMale,
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  locale.obGenderFemale,
                                ),
                                value: 0,
                              ),
                              DropdownMenuItem(
                                  child: Text(
                                    locale.obGenderOthers,
                                    style: TextStyle(),
                                  ),
                                  value: -1),
                            ],
                            onChanged: (value) {
                              gen = value;
                              //   isLoading = true;
                              setState(() {});
                              //   filterTransactions();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              TextFieldLabel(locale.obDobLabel),
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dateInputError != ""
                        ? Colors.red
                        : UiConstants.primaryColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 5,
                    ),
                    DateField(
                      controller: model.dateFieldController,
                      fieldWidth: SizeConfig.screenWidth * 0.12,
                      labelText: "dd",
                      maxlength: 2,
                      validate: (String val) {
                        if (val.isEmpty || val == null) {
                          setState(() {
                            dateInputError = "Date field cannot be empty";
                          });
                        } else if (int.tryParse(val) > 31 ||
                            int.tryParse(val) < 1) {
                          setState(() {
                            dateInputError = "Invalid date";
                          });
                        }
                        return null;
                      },
                    ),
                    Expanded(child: Center(child: Text("/"))),
                    DateField(
                      controller: model.monthFieldController,
                      fieldWidth: SizeConfig.screenWidth * 0.12,
                      labelText: "mm",
                      maxlength: 2,
                      validate: (String val) {
                        if (val.isEmpty || val == null) {
                          setState(() {
                            dateInputError = "Date field cannot be empty";
                          });
                        } else if (int.tryParse(val) != null &&
                            (int.tryParse(val) > 13 || int.tryParse(val) < 0)) {
                          setState(() {
                            dateInputError = "Invalid date";
                          });
                        }
                        return null;
                      },
                    ),
                    Expanded(child: Center(child: Text("/"))),
                    DateField(
                      controller: model.yearFieldController,
                      fieldWidth: SizeConfig.screenWidth * 0.16,
                      labelText: "yyyy",
                      maxlength: 4,
                      validate: (String val) {
                        if (val.isEmpty || val == null) {
                          setState(() {
                            dateInputError = "Date field cannot be empty";
                          });
                        } else if (int.tryParse(val) > DateTime.now().year ||
                            int.tryParse(val) < 1950) {
                          setState(() {
                            dateInputError = "Invalid date";
                          });
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    IconButton(
                      onPressed: () => model.showAndroidDatePicker(context),
                      icon: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: UiConstants.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              if (dateInputError != "")
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        dateInputError,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              TextFieldLabel("State"),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: UiConstants.primaryColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  iconEnabledColor: UiConstants.primaryColor,
                  hint: Text("Which state do you live in?"),
                  value: stateChosenValue,
                  onChanged: (String newVal) {
                    setState(() {
                      stateChosenValue = newVal;
                      print(newVal);
                    });
                  },
                  items: AugmontResources.augmontStateList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e["id"],
                          child: Text(
                            e["name"],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: SizeConfig.navBarHeight),
              SizedBox(height: SizeConfig.viewInsets.bottom)
            ],
          ),
        ),
      ),
    );
  }
}

class DateField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final maxlength;
  final double fieldWidth;
  final Function validate;

  DateField(
      {this.controller,
      this.labelText,
      this.maxlength,
      this.fieldWidth,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fieldWidth,
      child: TextFormField(
        controller: controller,
        maxLength: maxlength,
        cursorColor: UiConstants.primaryColor,
        cursorWidth: 1,
        validator: (val) => validate(val),
        onChanged: (val) {
          if (val.length == maxlength && maxlength == 2) {
            FocusScope.of(context).nextFocus();
          } else if (val.length == maxlength && maxlength == 4) {
            FocusScope.of(context).unfocus();
          }
        },
        keyboardType: TextInputType.datetime,
        style: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class SignInOptions extends StatefulWidget {
  final Function onGoogleSignIn, onEmailSignIn;
  SignInOptions({this.onEmailSignIn, this.onGoogleSignIn});
  @override
  _SignInOptionsState createState() => _SignInOptionsState();
}

class _SignInOptionsState extends State<SignInOptions> {
  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
        return true;
      },
      child: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.all(
              SizeConfig.blockSizeHorizontal * 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose an email option",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                Divider(
                  height: 32,
                  thickness: 2,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    "images/svgs/google.svg",
                    height: 24,
                    width: 24,
                  ),
                  trailing: baseProvider.isGoogleSignInProgress
                      ? Container(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(),
                  title: Text("Continue with Google"),
                  onTap: () {
                    if (!baseProvider.isGoogleSignInProgress) {
                      setState(() {
                        baseProvider.isGoogleSignInProgress = true;
                      });
                      widget.onGoogleSignIn();
                    }
                  },
                ),
                Divider(),
                ListTile(
                    leading: Icon(
                      Icons.alternate_email,
                      color: UiConstants.primaryColor,
                    ),
                    title: Text("Use another email"),
                    subtitle: Text(
                      "this option requires an extra step",
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize * 1.3,
                        color: Colors.red[300],
                      ),
                    ),
                    onTap: () {
                      if (!baseProvider.isGoogleSignInProgress) {
                        widget.onEmailSignIn();
                      }
                    }),
                SizedBox(
                  height: 24,
                )
              ],
            ),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
