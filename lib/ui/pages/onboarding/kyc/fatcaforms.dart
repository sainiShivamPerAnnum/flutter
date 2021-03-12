import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FatcaForms extends StatefulWidget {
  @override
  _FatcaFormsState createState() => _FatcaFormsState();
}

class _FatcaFormsState extends State<FatcaForms> {
  bool isPolExp;
  bool isRelPolExp;
  bool isResOutInd;
  bool isInvestor;
  String gender;
  String mstatus;
  String occSeln;
  String addSeln;
  TextEditingController email = new TextEditingController();
  TextEditingController nominee = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController mname = new TextEditingController();

  List<Map<String, String>> occupation = [
    {"OCC_CODE": "01", "OCC_NAME": "Private Sector"},
    {"OCC_CODE": "02", "OCC_NAME": "Public Sector"},
    {"OCC_CODE": "03", "OCC_NAME": "Business"},
    {"OCC_CODE": "04", "OCC_NAME": "Professional"},
    {"OCC_CODE": "06", "OCC_NAME": "Retired"},
    {"OCC_CODE": "07", "OCC_NAME": "Housewife"},
    {"OCC_CODE": "08", "OCC_NAME": "Student"},
    {"OCC_CODE": "10", "OCC_NAME": "Government Sector"},
    {"OCC_CODE": "99", "OCC_NAME": "Others"},
    {"OCC_CODE": "11", "OCC_NAME": "Self Employed"},
    {"OCC_CODE": "12", "OCC_NAME": "Not Categorised"},
  ];

  List<Map<String, String>> address = [
    {"CODE": "01", "NAME": "Residential/Business"},
    {"CODE": "02", "NAME": "Residential"},
    {"CODE": "03", "NAME": "Business"},
    {"CODE": "04", "NAME": "Registered Office"},
    {"CODE": "05", "NAME": "Unspecified"},
  ];

  Widget createEditableField(
    TextEditingController controller,
    String title,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: InputField(
        child: TextFormField(
          decoration: InputDecoration(border: InputBorder.none),
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value.isEmpty) {
              return 'Field Cannot be Empty';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FATCA FORMS"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Are you a politally exposed person?"),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: true,
                          groupValue: isPolExp,
                          onChanged: (bool value) {
                            setState(() {
                              isPolExp = value;
                            });
                          },
                        ),
                        title: Text("Yes"),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: false,
                          groupValue: isPolExp,
                          onChanged: (bool value) {
                            setState(() {
                              isPolExp = value;
                            });
                          },
                        ),
                        title: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                    "Are you related to anyone who is politically exposed?"),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: true,
                          groupValue: isRelPolExp,
                          onChanged: (bool value) {
                            setState(() {
                              isRelPolExp = value;
                            });
                          },
                        ),
                        title: Text("Yes"),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: false,
                          groupValue: isRelPolExp,
                          onChanged: (bool value) {
                            setState(() {
                              isRelPolExp = value;
                            });
                          },
                        ),
                        title: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Are you a resident outside of India?"),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: true,
                          groupValue: isResOutInd,
                          onChanged: (bool value) {
                            setState(() {
                              isResOutInd = value;
                            });
                          },
                        ),
                        title: Text("Yes"),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: false,
                          groupValue: isResOutInd,
                          onChanged: (bool value) {
                            setState(() {
                              isResOutInd = value;
                            });
                          },
                        ),
                        title: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                    "Are you a related person to investor or investor yourself? "),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: true,
                          groupValue: isInvestor,
                          onChanged: (bool value) {
                            setState(() {
                              isInvestor = value;
                            });
                          },
                        ),
                        title: Text("Yes"),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          activeColor: UiConstants.primaryColor,
                          value: false,
                          groupValue: isInvestor,
                          onChanged: (bool value) {
                            setState(() {
                              isInvestor = value;
                            });
                          },
                        ),
                        title: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Gender"),
                subtitle: InputField(
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("What is your gender?"),
                      onChanged: (String newVal) {
                        setState(() {
                          gender = newVal;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: "M",
                          child: Text(
                            "Male",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "F",
                          child: Text(
                            "Female",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "T",
                          child: Text(
                            "Transgender",
                          ),
                        ),
                      ]),
                ),
              ),
              ListTile(
                title: Text("Marital Status"),
                subtitle: InputField(
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("What is your Marital Status?"),
                      onChanged: (String newVal) {
                        setState(() {
                          mstatus = newVal;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: "MARRIED",
                          child: Text(
                            "Married",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "UNMARRIED",
                          child: Text(
                            "Unmarried",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "OTHERS",
                          child: Text(
                            "Others",
                          ),
                        ),
                      ]),
                ),
              ),
              createEditableField(email, "Enter Your Email"),
              createEditableField(nominee, "Enter Nominee Name"),
              createEditableField(fname, "Enter Your Father's Name"),
              createEditableField(mname, "Enter Your Mohter's Name"),
              ListTile(
                title: Text("Occupation"),
                subtitle: InputField(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    iconEnabledColor: UiConstants.primaryColor,
                    hint: Text("Choose Your Occupation"),
                    onChanged: (String newVal) {
                      setState(() {
                        occSeln = newVal;
                        print(newVal);
                        // print(occupation.firstWhere(
                        //     (element) => element["OCC_CODE"] == newVal));
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
              ),
              ListTile(
                title: Text("Address Type"),
                subtitle: InputField(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    iconEnabledColor: UiConstants.primaryColor,
                    hint: Text("What kind of place you live in."),
                    onChanged: (String newVal) {
                      setState(() {
                        addSeln = newVal;
                        print(newVal);
                        // print(occupation.firstWhere(
                        //     (element) => element["OCC_CODE"] == newVal));
                      });
                    },
                    items: address
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: new LinearGradient(
                        colors: [
                          UiConstants.primaryColor.withGreen(190),
                          UiConstants.primaryColor
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
