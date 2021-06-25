import 'package:felloapp/base_util.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AugmontConfirmRegnDialog extends StatefulWidget {
  final String panNumber;
  final String panName;
  final String bankAccNo;
  final String bankName;
  final String bankIfsc;
  final String bankHolderName;
  final String bankBranchName;
  final Function onAccept;
  final Function onReject;

  AugmontConfirmRegnDialog(
      {this.panNumber,
      this.panName,
      this.bankAccNo,
      this.bankName,
      this.bankIfsc,
      this.bankHolderName,
      this.bankBranchName,
      this.onAccept,
      this.onReject});

  @override
  State createState() => AugmontConfirmRegnDialogState();
}

class AugmontConfirmRegnDialogState extends State<AugmontConfirmRegnDialog> {
  final Log log = new Log('AugmontConfirmRegnDialog');
  TextEditingController _amountController = TextEditingController();
  BaseUtil baseProvider;
  String _amountError;
  String _errorMessage;
  bool _isLoading = false;
  bool _isButtonEnabled = false;
  double _width;
  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return WillPopScope(
        onWillPop: () async {
          print("I am here----------->");
          backButtonDispatcher.didPopRoute();
          baseProvider.isAugmontRegnInProgress = false;
          print(AppState.screenStack);
          return false;
        },
        child: Dialog(
          insetPadding:
              EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          child: dialogContent(context),
        ));
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.onboardingSlide[3]),
                        fit: BoxFit.contain,
                      ),
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Is this information correct?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (widget.panNumber != null)
                        ? _buildRow('PAN Number', widget.panNumber)
                        : Container(),
                    (widget.panNumber != null)
                        ? _buildRow('Name as per PAN', widget.panName)
                        : Container(),
                    _buildRow('Bank Account No', widget.bankAccNo),
                    _buildRow(
                        'Name of Bank account holder', widget.bankHolderName),
                    _buildRow('Name of Bank', widget.bankName),
                    _buildRow('Bank Branch Name', widget.bankBranchName),
                    _buildRow('Bank IFSC', widget.bankIfsc),
                    (widget.panNumber != null)
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Your PAN information cant be changed later',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: SizeConfig.smallTextSize),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              backButtonDispatcher.didPopRoute();
                              widget.onReject();
                            },
                            child: Text('CANCEL')),
                        TextButton(
                            onPressed: () {
                              backButtonDispatcher.didPopRoute();
                              widget.onAccept();
                            },
                            child: Text('CONFIRM')),
                      ],
                    )
                  ],
                )),
          )
        ]);
  }

  _buildRow(String title, String value) {
    return ListTile(
      // contentPadding: EdgeInsets.symmetric(
      //   horizontal: SizeConfig.blockSizeHorizontal * 8,
      //   vertical: SizeConfig.blockSizeVertical * 0.4,
      // ),
      title: Container(
        width: SizeConfig.screenWidth * 0.2,
        child: Text(
          '$title: ',
          style: TextStyle(
            color: UiConstants.accentColor,
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
      ),
      trailing: Container(
        width: SizeConfig.screenWidth * 0.3,
        child: Text(
          value,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.mediumTextSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    // return Padding(
    //     padding: const EdgeInsets.all(5),
    //     child: RichText(
    //       text: TextSpan(
    //           text: '$title: ',
    //           style: TextStyle(
    //             color: Colors.black,
    //           ),
    //           children: [
    //             TextSpan(
    //               text: value,
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //           ]),
    //     ));
  }
}
