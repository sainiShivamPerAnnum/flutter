import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FatcaForms extends StatefulWidget {
  @override
  _FatcaFormsState createState() => _FatcaFormsState();
}

// *** Fields that are required and not added ******

//Required fields kycAccountDescription

// Mobile Number with country code is also required //

// PAN Number is also required //

// Application status code and description (Required)
// R	Resident Indian
// N	Non-Resident Indian
// P	Foreign National
// I	Person of Indian Origin

// Father name and Title (Required)

// Mother titile required it can be “Mrs.” / “Ms.” / “Mx.”

// Nominee Relation must be one of [FATHER, SPOUSE] //

//KYC Acc Type  Code	KYC Acc. Description
// 01	New
// 02	Modify with documents
// 03	Modify without documents
// 04	Dump
// 05	Suspended
// 06	Deceased

class _FatcaFormsState extends State<FatcaForms> {
  bool isPolExp;
  bool isRelPolExp;
  bool isResOutInd;
  bool isInvestor;
  String gender;
  String nRelationship;
  String mstatus;
  String occSeln;
  String occDescriptionSeln;
  String addSeln;
  String addDescSeln;

  String residentialSeln;
  String residentialDescSeln;

  String kycAccountCodeSeln;
  String kycAccountDescriptionSeln;
  TextEditingController email = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController panNumber = new TextEditingController();
  TextEditingController nominee = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController mName = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> maritalStatus = ['MARRIED', 'UNMARRIED', "OTHERS"];

  List<String> nomineeRelationShip = ['FATHER', 'SPOUSE'];

  KYCModel kycModel = KYCModel();

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

  //KYC Application status code
  //kycData.applicationStatusCode
  // "applicationStatusCode": "R",
  // "applicationStatusDescription": "Resident Indian",
  List<Map<String, String>> residential = [
    {"CODE": "R", "NAME": "Resident Indian"},
    {"CODE": "N", "NAME": "Non-Resident Indian"},
    {"CODE": "P", "NAME": "Foreign National"},
    {"CODE": "I", "NAME": "Person of Indian Origin"},
  ];

  List<Map<String, String>> kycCode = [
    {"CODE": "01", "NAME": "New"},
    {"CODE": "02", "NAME": "Modify with documents"},
    {"CODE": "03", "NAME": "Modify without documents"},
    {"CODE": "04", "NAME": "Dump"},
    {"CODE": "05", "NAME": "Suspended"},
    {"CODE": "06", "NAME": "Deceased"},
  ];

  Widget createDropdown(var title, var text, var data) {
    return ListTile(
      title: Text("$title"),
      subtitle: InputField(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          iconEnabledColor: UiConstants.primaryColor,
          hint: Text("$text"),
          onChanged: (String newVal) {
            setState(() {
              mstatus = newVal;
            });
          },
          items: data.map<DropdownMenuItem<String>>((String valueItem) {
            return DropdownMenuItem<String>(
              value: valueItem,
              child: Text(valueItem),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget createEditableField(
      TextEditingController controller, String title, var inputType) {
    return ListTile(
      title: Text(title),
      subtitle: InputField(
        child: TextFormField(
          decoration: InputDecoration(border: InputBorder.none),
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          keyboardType:
              inputType == "mobile" ? TextInputType.number : TextInputType.text,
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
      body: Form(
        key: _formKey,
        child: Padding(
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
                  title: Text("Are you a politically exposed person?"),
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
                ListTile(
                  title: Text("Nominee Relationship"),
                  subtitle: InputField(
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        iconEnabledColor: UiConstants.primaryColor,
                        hint: Text("Select a relationship"),
                        onChanged: (String newVal) {
                          setState(() {
                            nRelationship = newVal;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: "FATHER",
                            child: Text(
                              "Father",
                            ),
                          ),
                          DropdownMenuItem(
                            value: "SPOUSE",
                            child: Text(
                              "Spouse",
                            ),
                          ),
                        ]),
                  ),
                ),

                // createDropdown("Gender", "What is your gender?", maritalStatus),

                // createDropdown("Nominee Relationship", "Select a relationship", nomineeRelationShip),

                createEditableField(email, "Enter Your Email", "text"),
                createEditableField(
                    mobileNumber, "Enter Your Mobile Number", "mobile"),
                createEditableField(panNumber, "Enter Your PAN Number", "text"),
                createEditableField(nominee, "Enter Nominee Name", "text"),
                createEditableField(fname, "Enter Your Father's Name", "text"),
                createEditableField(mName, "Enter Your Mother's Name", "text"),

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

                // Table 1.5 (Application status code and description)
                ListTile(
                  title: Text("Residential Status"),
                  subtitle: InputField(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("What is your residential status"),
                      onChanged: (String newVal) {
                        setState(() {
                          residentialSeln = newVal;
                          print(newVal);
                          // print(occupation.firstWhere(
                          //     (element) => element["OCC_CODE"] == newVal));
                        });
                      },
                      items: residential
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

                //KYC account code and desciption
                ListTile(
                  title: Text("Application Status"),
                  subtitle: InputField(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: UiConstants.primaryColor,
                      hint: Text("Select application status"),
                      onChanged: (String newVal) {
                        setState(() {
                          kycAccountCodeSeln = newVal;
                          print(newVal);
                          // print(occupation.firstWhere(
                          //     (element) => element["OCC_CODE"] == newVal));
                        });
                      },
                      items: kycCode
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
                      child: FlatButton(
                        onPressed: () async {
                          getOccupationDesc();

                          getKycApplicationDesc();

                          getAddress();

                          var polExp;
                          isPolExp == true ? polExp = "YES" : polExp = "NO";

                          var relPolExp;
                          isRelPolExp == true
                              ? relPolExp = "YES"
                              : relPolExp = "NO";

                          var resOutInd;
                          isResOutInd == true
                              ? resOutInd = "YES"
                              : resOutInd = "NO";

                          var relatedPerson;
                          isInvestor == true
                              ? relatedPerson = "YES"
                              : relatedPerson = "NO";

                          var result = await kycModel.fatcaForms(
                              polExp.toString(),
                              relPolExp.toString(),
                              resOutInd.toString(),
                              relatedPerson.toString(),
                              //FORMS
                              // relatedPersonType,
                              gender,
                              mstatus,
                              nRelationship,
                              "Mr.",
                              panNumber.text,
                              "Mrs.",
                              residentialDescSeln,
                              occDescriptionSeln,
                              occSeln,
                              kycAccountCodeSeln,
                              kycAccountDescriptionSeln,
                              addSeln,
                              addDescSeln,
                              addSeln,
                              addDescSeln,
                              101,
                              "India",
                              residentialSeln,
                              residentialDescSeln,
                              mobileNumber.text,
                              91,
                              email.text,
                              fname.text,
                              mName.text);
                          print(result);

                          if (result['flag'] == true) {
                            // setState(() {
                            //   loading = false;
                            // });

                            Navigator.of(context).pop(result);
                          } else {
                            Navigator.of(context).pop(result);

                            print("error");
                          }
                        },
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
      ),
    );
  }

  getKycApplicationDesc() {
    // get kyc applicatiopn description
    for (var i in kycCode) {
      if (kycAccountCodeSeln == i['CODE']) {
        print(i['NAME']);
        kycAccountDescriptionSeln = i['NAME'];
      }
    }
  }

  getOccupationDesc() {
    for (var i in occupation) {
      if (occSeln == i['OCC_CODE']) {
        occDescriptionSeln = i['OCC_NAME'];
      }
      print(occDescriptionSeln);
    }
  }

  getAddress() {
    for (var i in address) {
      if (addSeln == i['CODE']) {
        addDescSeln = i['NAME'];
      }
      print(addDescSeln);
    }
  }

  getResidentialDesc() {
    for (var i in residential) {
      if (residentialSeln == i['CODE']) {
        residentialDescSeln = i['NAME'];
      }
      print(residentialDescSeln);
    }
  }
}
