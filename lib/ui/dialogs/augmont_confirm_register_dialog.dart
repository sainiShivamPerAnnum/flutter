import 'package:felloapp/base_util.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final Color dialogColor;
  final String customMessage;

  AugmontConfirmRegnDialog(
      {this.panNumber,
      this.panName,
      this.bankAccNo,
      this.bankName,
      this.bankIfsc,
      this.bankHolderName,
      this.bankBranchName,
      this.onAccept,
      this.onReject,
      this.dialogColor,
      this.customMessage});

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
          AppState.backButtonDispatcher.didPopRoute();
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
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.globalMargin * 2,
                    horizontal: SizeConfig.globalMargin),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.globalMargin,
                          left: SizeConfig.globalMargin),
                      child: Text(
                        'Is this information correct?',
                        style: TextStyle(
                            fontSize: SizeConfig.largeTextSize,
                            fontWeight: FontWeight.w700,
                            color: widget.dialogColor),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        (widget.panNumber != null)
                            ? _buildRow('PAN Number', widget.panNumber)
                            : Container(),
                        (widget.panNumber != null)
                            ? _buildRow('Name as per PAN', widget.panName)
                            : Container(),
                        (widget.bankAccNo != null &&
                                widget.bankAccNo.isNotEmpty)
                            ? _buildRow('Bank Account No', widget.bankAccNo)
                            : Container(),
                        (widget.bankHolderName != null &&
                                widget.bankHolderName.isNotEmpty)
                            ? _buildRow('Name of Bank account holder',
                                widget.bankHolderName)
                            : Container(),
                        (widget.bankName != null && widget.bankName.isNotEmpty)
                            ? _buildRow('Name of Bank', widget.bankName)
                            : Container(),
                        (widget.bankBranchName != null &&
                                widget.bankBranchName.isNotEmpty)
                            ? _buildRow(
                                'Bank Branch Name', widget.bankBranchName)
                            : Container(),
                        (widget.bankIfsc != null && widget.bankIfsc.isNotEmpty)
                            ? _buildRow('Bank IFSC', widget.bankIfsc)
                            : Container(),
                        (widget.panNumber != null)
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "This information can't be changed later",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: SizeConfig.smallTextSize),
                                ),
                              )
                            : Container(),
                        (widget.customMessage != null &&
                                widget.customMessage.isNotEmpty)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  widget.customMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: SizeConfig.mediumTextSize,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.globalMargin),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onReject();
                                AppState.backButtonDispatcher.didPopRoute();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                AppState.backButtonDispatcher.didPopRoute();

                                widget.onAccept();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    widget.dialogColor),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
            fontSize: SizeConfig.mediumTextSize,
            fontWeight: FontWeight.w700,
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
