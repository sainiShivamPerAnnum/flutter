import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final regex = RegExp(r"^(?!\.)(?!.*\.$)(?!.*?\.\.)[a-z0-9.]{4,20}$");
  bool isValid;
  bool isLoading = false;
  bool isUpdating = false;
  bool isUpdated = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusNode = new FocusNode();
    focusNode.addListener(
        () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
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
      });
    else if (regex.hasMatch(username)) {
      bool res = await dbProvider
          .checkIfUsernameIsAvailable(username.replaceAll('.', '@'));
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
    return isValid;
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
      return Text("${usernameController.text.trim()} is available",
          style: TextStyle(
              color: UiConstants.primaryColor, fontWeight: FontWeight.w500));
    else if (isValid == false)
      return Text("${usernameController.text.trim()} is not available",
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
                "Pick a username",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: SizeConfig.screenWidth * 0.06,
                ),
              ),
            ),
            const Text("This is going to be your unique ID✨"),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Container(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: usernameController,
                  autofocus: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "username cannot be empty";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "username",
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                      size: 20,
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
            SizedBox(height: SizeConfig.screenHeight * .1),
            const Text(
              "Rules for a valid username",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const RuleTile(
                rule: "• must be more than 4 and less than 20 letters"),
            const RuleTile(
                rule:
                    "• only lowercase alphabets, numbers and dot(.) symbols allowed."),
            const RuleTile(
                rule:
                    "• consecutive dot(.) are not allowed. example: abc..xyz is an invalid username"),
            const RuleTile(
                rule:
                    "• dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames "),
            const SizedBox(
              height: kToolbarHeight * 2,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        rule,
        style: TextStyle(color: Colors.black26),
      ),
    );
  }
}
