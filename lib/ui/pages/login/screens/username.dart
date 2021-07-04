import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Username extends StatefulWidget {
  static const int index = 3;

  Username({Key key}) : super(key: key);

  @override
  UsernameState createState() => UsernameState();
}

class UsernameState extends State<Username> {
  TextEditingController username = TextEditingController();
  BaseUtil baseProvider;
  DBModel dbProvider;

  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  bool isValid;
  bool isLoading = false;
  bool isUpdating = false;
  bool isUpdated = false;

  void validate(String value) async {
    setState(() {
      isLoading = true;
    });
    if (value == "" || value == null)
      setState(() {
        isValid = null;
      });
    else if (regex.hasMatch(value)) {
      String username = value.replaceAll('.', '@');
      bool res = await dbProvider.checkIfUsernameIsAvailable(username);
      setState(() {
        isValid = res;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget showResult() {
    if (isLoading) {
      return Container(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (isValid == true)
      return Text("${username.text} is available",
          style: TextStyle(
              color: UiConstants.primaryColor, fontWeight: FontWeight.w500));
    else if (isValid == false)
      return Text("${username.text} is not available",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500));
    return SizedBox(
      height: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Choose a cool username",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: SizeConfig.screenWidth * 0.06,
                ),
              ),
            ),
            Text("You cannot change your username anytime later"),
            SizedBox(
              height: 16,
            ),
            Container(
              child: TextFormField(
                controller: username,
                autofocus: true,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "username",
                  prefixIcon: Icon(Icons.account_circle_rounded),
                ),
                onChanged: (value) {
                  validate(value);
                },
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
            SizedBox(height: SizeConfig.screenHeight * .1),
            Text(
              "Rules for a valid username",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RuleTile(rule: "• must be more than 4 and less than 20 letters"),
            RuleTile(
                rule:
                    "• only lowercase alphabets, numbers and dot(.) symbols allowed."),
            RuleTile(
                rule:
                    "• consecutive dot(.) are not allowed. example: abc..xyz is an invalid username"),
            RuleTile(
                rule:
                    "• dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames "),
            SizedBox(
              height: kToolbarHeight * 2,
            )
          ],
        ),
      ),
    );
  }
}

class RuleTile extends StatelessWidget {
  final String rule;

  RuleTile({this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        rule,
        style: TextStyle(color: Colors.black26),
      ),
    );
  }
}
