import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/more_info_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DepositModalSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDepositConfirmed;

  DepositModalSheet({this.onDepositConfirmed});

  _DepositModalSheetState createState() => _DepositModalSheetState();
}

class _DepositModalSheetState extends State<DepositModalSheet> with SingleTickerProviderStateMixin {
  _DepositModalSheetState();

  Log log = new Log('DepositModalSheet');
  var heightOfModalBottomSheet = 100.0;
  bool _isCostRequestCalled = false;
  bool _isCostFetched = false;
  bool _isCostAvailable = false;
  Widget _requestCostWidget;
  BaseUtil baseProvider;
  final _amtController = new TextEditingController();
  final _vpaController = new TextEditingController();

  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: new Wrap(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
            child: _costConfirmDialog(),
          ),
        ],
      ),
    );
  }

  Widget _costConfirmDialog() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            child: TextField(
              autofocus: false,
              controller: _amtController,
              keyboardType: TextInputType.number,
              decoration: inputFieldDecoration(
                  "Enter an amount"
              ),
              onSubmitted: (value) {
                //add firsrt investmetn flag
                //add vpa check and autofill
                //add invt approval flag in baseuser obj
              },
            ),
          ),
          InputField(
            child: TextField(
              autofocus: false,
              controller: _vpaController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputFieldDecoration(
                  "Enter your UPI id"
              ),
              onSubmitted: (value) {
                //add firsrt investmetn flag
                //add vpa check and autofill
                //add invt approval flag in baseuser obj
              },
            ),
          ),
          Wrap(
            spacing: 20,
            children: [
              ActionChip(
                label: Text("What is my UPI?"),
                backgroundColor: UiConstants.chipColor,
                onPressed: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => MoreInfoDialog(
                        text: Assets.infoWhyPan,
                        title: 'Why is my UPI?',
                      ));
                },
              ),
              ActionChip(
                label: Text("Where do I find it?"),
                backgroundColor: UiConstants.chipColor,
                onPressed: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => MoreInfoDialog(
                        text: Assets.infoWherePan,
                        title: 'Where can i find UPI Id?',
                        imagePath: Assets.dummyPanCard,
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
