import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FatcaForms extends StatefulWidget {
  @override
  _FatcaFormsState createState() => _FatcaFormsState();
}

class _FatcaFormsState extends State<FatcaForms> {
  bool isPolExp = false;
  bool isRelPolExp = false;
  bool isResOutInd = false;
  bool isInvestor = false;

  createboolTile(String title, bool response) {
    return ListTile(
      title: Text(title),
      subtitle: Row(
        children: [
          Expanded(
            flex: 4,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Radio(
                activeColor: UiConstants.primaryColor,
                value: true,
                groupValue: response,
                onChanged: (bool value) {
                  setState(() {
                    response = value;
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
                groupValue: response,
                onChanged: (bool value) {
                  setState(() {
                    response = value;
                  });
                },
              ),
              title: Text("No"),
            ),
          ),
        ],
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
              createboolTile(
                  "Are you a Politically exposed person ?", isPolExp),
              createboolTile(
                  "Are you related to anyone who is politically exposed?",
                  isRelPolExp),
              createboolTile(
                  "Are you a resident outside of India?", isResOutInd),
              createboolTile(
                  "Are you a related person to investor or investor yourself? ",
                  isInvestor),
              RaisedButton(
                  onPressed: () {
                    print(isPolExp);
                    print(isInvestor);
                  },
                  child: Text("Print"))
            ],
          ),
        ),
      ),
    );
  }
}
