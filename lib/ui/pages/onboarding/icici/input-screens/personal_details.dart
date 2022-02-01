import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/icici_onboard_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  static const int index = 1;
  final personalForm;
  final isNameDisabled;

  PersonalPage({@required this.personalForm, this.isNameDisabled = false});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _userService = locator<UserService>();
  BaseUtil baseProvider;
  IciciOnboardController controllerInstance = new IciciOnboardController();
  TextEditingController _dateController = new TextEditingController(
      text: '${IDP.selectedDate.toLocal()}'.split(' ')[0]);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: IDP.selectedDate,
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: UiConstants.primaryColor,
                onPrimary: Colors.black,
                surface: UiConstants.primaryColor,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blueGrey[50],
            ),
            child: child,
          );
        });
    if (picked != null && picked != IDP.selectedDate)
      setState(() {
        IDP.selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    IDP.name.text = (baseProvider.iciciDetail != null)
        ? baseProvider.iciciDetail.panName
        : '';
    IDP.email.text =
        (_userService.baseUser != null) ? _userService.baseUser.email : '';
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          child: Form(
            key: widget.personalForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Text(
                  "CONFIRM YOUR",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "PERSONAL",
                  style: TextStyle(
                    fontSize: 50,
                    color: UiConstants.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "DETAILS",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 20),
                Text("Mobile No"),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    top: 5,
                  ),
                  padding:
                      EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 11, top: 11, right: 15),
                    child: Text(
                      _userService.baseUser.mobile,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Text("Name as per your PAN Card"),
                InputField(
                  child: TextFormField(
                    decoration: inputFieldDecoration('Enter Full Name'),
                    controller: IDP.name,
                    textCapitalization: TextCapitalization.characters,
                    enabled: !widget.isNameDisabled,
                    validator: (value) {
                      RegExp nameCheck = RegExp(r"^[a-zA-Z ]+$");
                      if (value.isEmpty) {
                        return 'Name Field Cannot be Empty';
                      } else if (nameCheck.hasMatch(value)) {
                        return null;
                      } else {
                        return "invalid name";
                      }
                    },
                  ),
                ),
                Text("Email"),
                InputField(
                  child: TextFormField(
                    decoration: inputFieldDecoration('Enter email'),
                    controller: IDP.email,
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      RegExp emailCheck = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (value.isEmpty) {
                        return 'Email field Cannot be empty';
                      } else if (emailCheck.hasMatch(value)) {
                        return null;
                      } else {
                        return "Invalid Email";
                      }
                    },
                  ),
                ),
                Text("Date of Birth"),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputField(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Date',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: UiConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(height: _height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
