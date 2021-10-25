import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum UsernameResponse { AVAILABLE, UNAVAILABLE, INVALID, EMPTY }

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class Username extends StatefulWidget {
  static const int index = 3;

  Username({Key key}) : super(key: key);

  @override
  UsernameState createState() => UsernameState();
}

class UsernameState extends State<Username> {
  TextEditingController usernameController = TextEditingController();
  BaseUtil baseProvider;
  DBModel dbProvider;
  String username = "";
  FocusNode focusNode;
  bool enabled = true;
  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  bool isValid;
  bool isLoading = false;
  bool isUpdating = false;
  bool isUpdated = false;
  final _formKey = GlobalKey<FormState>();
  UsernameResponse response;

  // @override
  // void initState() {
  //   focusNode = new FocusNode();
  //   focusNode.addListener(
  //       () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));
  //   super.initState();
  // }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  Future<bool> validate() async {
    username = usernameController.text.trim();
    setState(() {
      isLoading = true;
    });
    if (username == "" || username == null)
      setState(() {
        isValid = null;
        response = UsernameResponse.EMPTY;
      });
    else if (regex.hasMatch(username)) {
      bool res = await dbProvider
          .checkIfUsernameIsAvailable(username.replaceAll('.', '@'));
      setState(() {
        isValid = res;
        if (res)
          response = UsernameResponse.AVAILABLE;
        else
          response = UsernameResponse.UNAVAILABLE;
      });
    } else {
      setState(() {
        isValid = false;
        response = UsernameResponse.INVALID;
      });
    }
    setState(() {
      isLoading = false;
    });
    return isValid;
  }

  Widget showResult() {
    print(response);
    if (isLoading) {
      return Container(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (response == UsernameResponse.EMPTY
        // isValid == true
        )
      return Text("username cannot be empty",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500));
    else if (response == UsernameResponse.AVAILABLE
        // isValid == true
        )
      return Text("@${usernameController.text.trim()} is available",
          style: TextStyle(
              color: UiConstants.primaryColor, fontWeight: FontWeight.w500));
    else if (response == UsernameResponse.UNAVAILABLE
        // isValid == false
        )
      return Text("@${usernameController.text.trim()} is not available",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500));
    else if (response == UsernameResponse.INVALID
        // isValid == false
        )
      return Text(
          "@${usernameController.text.trim()} is invalid. please refer to rules",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500));
    return SizedBox(
      height: 16,
    );
  }

  @override
  void didChangeDependencies() {
    if (mounted)
      Future.delayed(Duration(seconds: 2), () {
        FocusScope.of(context).requestFocus(focusNode);
      });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.username,
                  width: SizeConfig.screenWidth * 0.28,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            TextFieldLabel(locale.obUsernameLabel),
            SizedBox(height: SizeConfig.padding6),
            Form(
              key: _formKey,
              child: Container(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: usernameController,
                  inputFormatters: [
                    LowerCaseTextFormatter(),
                    //FilteringTextInputFormatter.allow(regex)
                  ],
                  textCapitalization: TextCapitalization.none,
                  autofocus: true,
                  enabled: enabled,
                  cursorColor: UiConstants.primaryColor,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "username cannot be empty";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: locale.obUsernameHint,
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                      size: 20,
                      color: UiConstants.primaryColor,
                    ),
                  ),
                  onChanged: (value) {
                    validate();
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.only(
                bottom: 24,
                left: 8,
              ),
              height: 40,
              child: showResult(),
            ),
            //Text(responseText),
            SizedBox(height: SizeConfig.padding40),
            Text(
              locale.obUsernameRulesTitle,
              style: TextStyles.title4.bold,
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            RuleTile(rule: locale.obUsernameRule1),
            RuleTile(rule: locale.obUsernameRule2),
            RuleTile(rule: locale.obUsernameRule3),
            RuleTile(rule: locale.obUsernameRule4),
            SizedBox(
              height: SizeConfig.screenHeight * 0.3,
            ),
            SizedBox(
              height: SizeConfig.viewInsets.bottom,
            )
          ],
        ),
      ),
    );
  }

  get formKey => _formKey;
}

class RuleTile extends StatelessWidget {
  final String rule;

  const RuleTile({this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding16),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: UiConstants.primaryColor,
              radius: SizeConfig.padding4),
          SizedBox(width: SizeConfig.padding4 * 2),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }
}
