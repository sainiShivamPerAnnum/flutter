import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class MobileInputScreen extends StatefulWidget {
  static const int index = 0; //pager index
  MobileInputScreen({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() => MobileInputScreenState();

}

class MobileInputScreenState extends State<MobileInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _validate = true;
  Log log = new Log("MobileInputScreen");

  @override
  Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child:
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    prefixIcon: Icon(Icons.phone),
                  ),
                  controller: _mobileController,
                  validator: (value) => _validateMobile(value),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              )
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   width: 230.0,
          //   height: 60.0,
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     borderRadius: new BorderRadius.circular(30.0),
          //     border: Border.all(color: UiConstants.primaryColor, width: 1.5),
          //     color: Colors.transparent,
          //   ),
          //   child:Tooltip(
          //   message:'Check here',
          //   child: new Material(
          //     child: MaterialButton(
          //       child: Text(
          //         'We are currently servicing only select societies',
          //         textAlign: TextAlign.center,
          //         style: Theme.of(context).textTheme.button.copyWith(color: UiConstants.primaryColor),
          //       ),
          //       onPressed: (){
          //         showDialog(context: context,
          //             builder: (BuildContext context) => LocationAvailabilityDialog()
          //         );
          //       },
          //       highlightColor: Colors.white30,
          //       splashColor: Colors.white30,
          //     ),
          //     color: Colors.transparent,
          //     borderRadius: new BorderRadius.circular(30.0),
          //   ),
          //   ),
          // ),
        ],
      //)
    );
  }

  setError() {
    setState(() {
      _validate = false;
    });
  }

  String _validateMobile(String value) {
    Pattern pattern = "^[0-9]*\$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value.length != 10)
      return 'Enter a valid Mobile';
    else
      return null;
  }

  String getMobile() => _mobileController.text;

  get formKey => _formKey;
}