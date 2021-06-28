import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/base_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAugmontBankDetailScreen extends StatefulWidget {
  CreateAugmontBankDetailScreen({Key key}) : super(key: key);

  @override
  _CreateAugmontBankDetailScreenState createState() => _CreateAugmontBankDetailScreenState();
}

class _CreateAugmontBankDetailScreenState extends State<CreateAugmontBankDetailScreen> {
  AppState appState;
  BaseUtil baseProvider;
  static TextEditingController _bankHolderNameInput =
      new TextEditingController();
  static TextEditingController _bankAccountNumberInput =
      new TextEditingController();
  static TextEditingController _reenterbankAccountNumberInput =
      new TextEditingController();
  static TextEditingController _bankIfscInput = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Register Bank Details",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
       body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 40, left: 35, right: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: SizedBox(
                  child: Image(
                    image: AssetImage(Assets.onboardingSlide[2]),
                    fit: BoxFit.contain,
                  ),
                  width: 180,
                  height: 150,
                )),
                Center(
                  child: Text(
                'Register Bank Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: UiConstants.primaryColor),
                )),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Bank Details",
                    style: TextStyle(color: Colors.blueGrey[600]),
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Text("Account Holder Name"),
                ),
                InputField(
                  child: TextFormField(
                    decoration:
                        inputFieldDecoration('Your name as per your bank'),
                    controller: _bankHolderNameInput,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    enabled: true,
                    autofocus: false,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Bank Account Number"),
                ),
                InputField(
                  child: TextFormField(
                    decoration: inputFieldDecoration('Your bank account number'),
                    controller: _bankAccountNumberInput,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    validator: (value) => null,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Confirm Bank Account Number"),
                ),
                InputField(
                  child: TextFormField(
                    decoration:
                        inputFieldDecoration('Re-enter bank account number'),
                    controller: _reenterbankAccountNumberInput,
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    validator: (value) => null,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Bank IFSC"),
                ),
                InputField(
                  child: TextFormField(
                    decoration: inputFieldDecoration('Your bank\'s IFSC code'),
                    controller: _bankIfscInput,
                    autofocus: false,
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization: TextCapitalization.characters,
                    enabled: true,
                    validator: (value) => null,
                  ),
                ),
              ]
            ),
        ),
      )
    );
  }
}
