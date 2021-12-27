import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class IncomeDetailsInputScreen extends StatefulWidget {
  static const int index = 2;

  @override
  _IncomeDetailsInputScreenState createState() =>
      _IncomeDetailsInputScreenState();
}

class _IncomeDetailsInputScreenState extends State<IncomeDetailsInputScreen> {
  final _incomeDetailsformKey = GlobalKey<FormState>();

  List<Map<String, String>> occupation = [
    {"OCC_CODE": "4", "OCC_NAME": "Agriculturist"},
    {"OCC_CODE": "1", "OCC_NAME": "Business"},
    {"OCC_CODE": "9", "OCC_NAME": "Doctor"},
    {"OCC_CODE": "43", "OCC_NAME": "Forex Dealer"},
    {"OCC_CODE": "44", "OCC_NAME": "Government Service"},
    {"OCC_CODE": "6", "OCC_NAME": "Housewife"},
    {"OCC_CODE": "8", "OCC_NAME": "Others"},
    {"OCC_CODE": "41", "OCC_NAME": "Private Sector Service"},
    {"OCC_CODE": "3", "OCC_NAME": "Professional"},
    {"OCC_CODE": "42", "OCC_NAME": "Public Sector Service"},
    {"OCC_CODE": "5", "OCC_NAME": "Retired"},
    {"OCC_CODE": "2", "OCC_NAME": "Service"},
    {"OCC_CODE": "7", "OCC_NAME": "Student"}
  ];

  List<Map<String, String>> wealthSource = [
    {"NAME": "Salary", "CODE": "01"},
    {"NAME": "Business Income", "CODE": "02"},
    {"NAME": "Gift", "CODE": "03"},
    {"NAME": "Ancestral Property", "CODE": "04"},
    {"NAME": "Rental Income", "CODE": "05"},
    {"NAME": "Prize Money", "CODE": "06"},
    {"NAME": "Royalty", "CODE": "07"},
    {"NAME": "Others", "CODE": "08"}
  ];

  List<Map<String, String>> incomeGroup = [
    {"NAME": "Below 1 Lac", "CODE": "Below 1 Lac"},
    {"NAME": "1-5 Lacs", "CODE": "1-5 Lacs"},
    {"NAME": "5-10 Lacs", "CODE": "5-10 Lacs"},
    {"NAME": "10-25 Lacs", "CODE": "10-25 Lacs"},
    {"NAME": ">25 Lacs-1 crore", "CODE": ">25 Lacs-1 crore"},
    {"NAME": ">1 crore", "CODE": ">1 crore"},
  ];

  List<Map<String, String>> politicalExposure = [
    {"PEP": "I am Politically Exposed Person", "CODE": "01"},
    {"RPEP": "I am Related to Politically Exposed Person", "CODE": "02"},
    {"NA": "Not Applicable", "CODE": "03"}
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          child: Center(
            child: Form(
              key: _incomeDetailsformKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "A FEW DETAILS",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "ABOUT YOUR",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "CAPITAL",
                    style: TextStyle(
                      fontSize: 50,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Occupation"),
                  InputField(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("Choose Your Occupation"),
                      value: IDP.occupationChosenValue,
                      onChanged: (String newVal) {
                        setState(() {
                          IDP.occupationChosenValue = newVal;
                          print(newVal);
                        });
                      },
                      items: occupation
                          .map(
                            (e) => DropdownMenuItem(
                              value: e["OCC_CODE"],
                              child: Text(
                                e["OCC_NAME"],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Political Exposure"),
                  InputField(
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        iconEnabledColor: UiConstants.primaryColor,
                        hint: Text("Are You involved in Politics"),
                        value: IDP.exposureChosenValue,
                        onChanged: (String newVal) {
                          setState(() {
                            IDP.exposureChosenValue = newVal;
                            print(newVal);
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: politicalExposure[0]["CODE"],
                            child: Text(
                              politicalExposure[0]["PEP"],
                            ),
                          ),
                          DropdownMenuItem(
                            value: politicalExposure[1]["CODE"],
                            child: Text(
                              politicalExposure[1]["RPEP"],
                            ),
                          ),
                          DropdownMenuItem(
                            value: politicalExposure[2]["CODE"],
                            child: Text(
                              politicalExposure[2]["NA"],
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Text("Annual Income"),
                  InputField(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("Estimated Annual Income"),
                      value: IDP.incomeChosenValue,
                      onChanged: (String newVal) {
                        setState(() {
                          IDP.incomeChosenValue = newVal;
                          print(newVal);
                        });
                      },
                      items: incomeGroup
                          .map(
                            (e) => DropdownMenuItem(
                              value: e["CODE"],
                              child: Text(
                                e["NAME"],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
