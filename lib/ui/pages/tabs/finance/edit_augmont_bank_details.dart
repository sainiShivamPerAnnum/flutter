import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/elements/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/login/screens/Field-Container.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../root.dart';

class EditAugmontBankDetail extends StatefulWidget {
  final String prevImage;

  EditAugmontBankDetail({this.prevImage});

  @override
  _EditAugmontBankDetailState createState() => _EditAugmontBankDetailState();
}

class _EditAugmontBankDetailState extends State<EditAugmontBankDetail> {
  Log log = new Log('EditAugmontBankDetail');
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bankHolderNameController;
  TextEditingController _bankAccNoController;
  TextEditingController _bankIfscController;
  bool _isInitialized = false;
  DBModel dbProvider;
  BaseUtil baseProvider;
  ICICIModel iProvider;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      baseProvider = Provider.of<BaseUtil>(context, listen: false);
      dbProvider = Provider.of<DBModel>(context, listen: false);
      iProvider = Provider.of<ICICIModel>(context, listen: false);
      _bankHolderNameController = (baseProvider.augmontDetail != null &&
              baseProvider.augmontDetail.bankHolderName != null)
          ? new TextEditingController(
              text: baseProvider.augmontDetail.bankHolderName)
          : new TextEditingController();
      _bankAccNoController = (baseProvider.augmontDetail != null &&
              baseProvider.augmontDetail.bankAccNo != null)
          ? new TextEditingController(
              text: baseProvider.augmontDetail.bankAccNo)
          : new TextEditingController();
      _bankIfscController = (baseProvider.augmontDetail != null &&
              baseProvider.augmontDetail.ifsc != null)
          ? new TextEditingController(text: baseProvider.augmontDetail.ifsc)
          : new TextEditingController();
    }

    return WillPopScope(
      onWillPop: () async {
        var pBankHolderName = _bankHolderNameController.text;
        var pBankAccNo = _bankAccNoController.text;
        var pBankIfsc = _bankIfscController.text;

        var curBankHolderName = baseProvider.augmontDetail.bankHolderName;
        var curBankAccNo = baseProvider.augmontDetail.bankAccNo;
        var curBankIfsc = baseProvider.augmontDetail.ifsc;

        bool noChanges = true;
        if (curBankHolderName == null || pBankHolderName != curBankHolderName)
          noChanges = false;
        if (curBankAccNo == null || pBankAccNo != curBankAccNo)
          noChanges = false;
        if (curBankIfsc == null || pBankIfsc != curBankIfsc) noChanges = false;

        if (!noChanges) {
          return (await showDialog(
            context: context,
            builder: (ctx) => ConfirmActionDialog(
              title: "You changes are unsaved",
              description: "Are you sure you want to go back?",
              buttonText: "Yes",
              cancelBtnText: 'Cancel',
              confirmAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              cancelAction: () {
                Navigator.pop(context);
              },
            ),
          ));
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: BaseUtil.getAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5, vertical: 20),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Update your bank account details',
                      style: TextStyle(fontSize: SizeConfig.largeTextSize, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 8),
                    child: Text(
                      'This is where the amount received from selling your gold shall be credited.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: SizeConfig.mediumTextSize, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bankHolderNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Bank holder\'s name',
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                      focusColor: UiConstants.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return (value.isEmpty || value.length < 4)
                          ? 'Please enter you name as per your bank'
                          : null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Text("Email"),
                  TextFormField(
                    controller: _bankAccNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Bank Account Number',
                      focusColor: UiConstants.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.keyboard),
                    ),
                    validator: (value) {
                      print(value);
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Please enter a valid account number';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _bankIfscController,
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Bank IFSC Code',
                      focusColor: UiConstants.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    validator: (value) {
                      print(value);
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Please enter a valid bank IFSC';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(colors: [
                        UiConstants.primaryColor,
                        UiConstants.primaryColor.withBlue(200),
                      ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Material(
                      child: MaterialButton(
                        child: (!baseProvider.isEditAugmontBankDetailInProgress)
                            ? Text(
                                'UPDATE',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white),
                              )
                            : SpinKitThreeBounce(
                                color: UiConstants.spinnerColor2,
                                size: 18.0,
                              ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _onUpdateClicked();
                          }
                        },
                        highlightColor: Colors.white30,
                        splashColor: Colors.white30,
                      ),
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  Spacer(),
                ],
              )),
        ),
      ),
    );
  }

  _onUpdateClicked() async {
    baseProvider.isEditAugmontBankDetailInProgress = true;
    setState(() {});
    ///CHECK FOR CHANGES
    var pBankHolderName = _bankHolderNameController.text;
    var pBankAccNo = _bankAccNoController.text;
    var pBankIfsc = _bankIfscController.text;

    var curBankHolderName = baseProvider.augmontDetail.bankHolderName;
    var curBankAccNo = baseProvider.augmontDetail.bankAccNo;
    var curBankIfsc = baseProvider.augmontDetail.ifsc;

    bool noChanges = true;
    if (curBankHolderName == null || pBankHolderName != curBankHolderName)
      noChanges = false;
    if (curBankAccNo == null || pBankAccNo != curBankAccNo) noChanges = false;
    if (curBankIfsc == null || pBankIfsc != curBankIfsc) noChanges = false;
    if (noChanges) {
      baseProvider.showNegativeAlert(
          'No Update', 'No changes were made', context);
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    ///NOW CHECK IF IFSC IS VALID
    if(!iProvider.isInit())await iProvider.init();
    var bankDetail =
        await iProvider.getBankInfo(baseProvider.myUser.pan, pBankIfsc);
    if (bankDetail == null ||
        bankDetail[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
        bankDetail[GetBankDetail.resBankName] == null) {
      log.error('Couldnt fetch an appropriate response');
      baseProvider.showNegativeAlert(
          'Update Failed', 'Invalid IFSC Code entered', context);
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    ///NOW SHOW CONFIRMATION DIALOG TO USER
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AugmontConfirmRegnDialog(
              bankHolderName: pBankHolderName,
              bankAccNo: pBankAccNo,
              bankIfsc: pBankIfsc,
              bankName: bankDetail[GetBankDetail.resBankName],
              bankBranchName: bankDetail[GetBankDetail.resBranchName],
              onAccept: () async{
                ///FINALLY NOW UPDATE THE BANK DETAILS
                baseProvider.augmontDetail.bankHolderName = pBankHolderName;
                baseProvider.augmontDetail.bankAccNo = pBankAccNo;
                baseProvider.augmontDetail.ifsc = pBankIfsc;
                dbProvider
                    .updateUserAugmontDetails(
                        baseProvider.myUser.uid, baseProvider.augmontDetail)
                    .then((flag) {
                  baseProvider.isEditAugmontBankDetailInProgress = false;
                  setState(() {});
                  if (flag) {
                    _goBack();
                    baseProvider.showPositiveAlert(
                        'Complete', 'Your details have been updated', context);
                  } else {
                    baseProvider.showNegativeAlert(
                        'Failed',
                        'Your details could not be updated at the moment. Please try again',
                        context);
                  }
                });
              },
              onReject: () {
                baseProvider.showNegativeAlert(
                    'Update Cancelled', 'Please try again', context);
                baseProvider.isEditAugmontBankDetailInProgress = false;
                setState(() {});
                return;
              },
            ));
  }

  _goBack() => Navigator.of(context).pop();
}
