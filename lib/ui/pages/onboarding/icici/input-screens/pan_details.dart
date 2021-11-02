import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PANPage extends StatelessWidget {
  static const int index = 0;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
        width: _width,
        height: _height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LET'S START\nWITH YOUR",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "PAN",
                    style: TextStyle(
                      fontSize: 50,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InputField(
                    child: TextField(
                      autofocus: false,
                      controller: IDP.panInput,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.characters,
                      decoration: inputFieldDecoration("Enter your PAN Number"),
                      onSubmitted: (value) {
                        IDP.panInput.text = value;
                        print(IDP.panInput.text);
                      },
                    ),
                  ),
                  Wrap(
                    spacing: 20,
                    children: [
                      ActionChip(
                        label: Text("Why is my PAN required?"),
                        backgroundColor: UiConstants.chipColor,
                        onPressed: () {
                          Haptic.vibrate();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => MoreInfoDialog(
                                    text: Assets.infoWhyPan,
                                    title: 'Why is PAN required?',
                                  ));
                        },
                      ),
                      ActionChip(
                        label: Text("Where do I find it?"),
                        backgroundColor: UiConstants.chipColor,
                        onPressed: () {
                          Haptic.vibrate();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => MoreInfoDialog(
                                    text: Assets.infoWherePan,
                                    title: 'Where can i find the PAN number?',
                                    imagePath: Assets.dummyPanCardShowNumber,
                                  ));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(),
          ],
        ));
  }
}
