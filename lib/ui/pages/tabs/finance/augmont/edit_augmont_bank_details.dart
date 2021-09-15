import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditAugmontBankDetail extends StatefulWidget {
  final bool isWithdrawFlow;
  final VoidCallback addBankComplete;

  EditAugmontBankDetail({this.isWithdrawFlow = false, this.addBankComplete});

  @override
  _EditAugmontBankDetailState createState() => _EditAugmontBankDetailState();
}

class _EditAugmontBankDetailState extends State<EditAugmontBankDetail> {
  Log log = new Log('EditAugmontBankDetail');
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bankHolderNameController;
  TextEditingController _bankAccNoController;
  TextEditingController _bankIfscController;
  TextEditingController _bankAccNoConfirmController;
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
      _bankAccNoConfirmController = (baseProvider.augmontDetail != null &&
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
          AppState.screenStack.add(ScreenItem.dialog);
          return (await showDialog(
            context: context,
            builder: (ctx) => ConfirmActionDialog(
              title: "You changes are unsaved",
              description: "Are you sure you want to go back?",
              buttonText: "Yes",
              cancelBtnText: 'Cancel',
              confirmAction: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
              cancelAction: () {},
            ),
          ));
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Theme(
          data: ThemeData.light().copyWith(
            textTheme: GoogleFonts.montserratTextTheme(),
            colorScheme:
                ColorScheme.light(primary: augmontGoldPalette.primaryColor),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5, vertical: 10),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          (baseProvider.augmontDetail.bankAccNo == '')
                              ? 'Enter your bank account details'
                              : 'Update your bank account details',
                          style: TextStyle(
                              fontSize: SizeConfig.largeTextSize,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 3, 8, 8),
                        child: Text(
                          'This is where the amount received from selling your gold shall be credited.',
                          style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _bankHolderNameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        decoration: augmontFieldInputDecoration(
                            'Bank holder\'s name', Icons.person),
                        // InputDecoration(
                        //   labelText: 'Bank holder\'s name',
                        //   errorBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   prefixIcon: Icon(Icons.person),
                        //   focusColor: augmontGoldPalette.primaryColor2,
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
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
                        decoration: augmontFieldInputDecoration(
                            'Bank Account Number', Icons.keyboard),
                        // InputDecoration(
                        //   labelText: 'Bank Account Number',
                        //   focusColor: augmontGoldPalette.primaryColor2,
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   prefixIcon: Icon(Icons.keyboard),
                        // ),
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
                        controller: _bankAccNoConfirmController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: augmontFieldInputDecoration(
                            'Confirm Bank Account Number', Icons.keyboard),
                        //  InputDecoration(
                        //   labelText: 'Confirm Bank Account Number',
                        //   focusColor: augmontGoldPalette.primaryColor2,
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   prefixIcon: Icon(Icons.keyboard),
                        // ),
                        validator: (value) {
                          print(value);
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Field cannot be empty';
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _bankIfscController,
                        keyboardType: TextInputType.streetAddress,
                        textCapitalization: TextCapitalization.characters,
                        decoration: augmontFieldInputDecoration(
                            'Bank IFSC Code', Icons.account_balance),
                        //  InputDecoration(
                        //   labelText: 'Bank IFSC Code',
                        //   focusColor: augmontGoldPalette.primaryColor2,
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   prefixIcon: Icon(Icons.account_balance),
                        // ),
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
                          gradient: new LinearGradient(
                              colors: [
                                augmontGoldPalette.primaryColor,
                                augmontGoldPalette.primaryColor2
                              ],
                              begin: Alignment(0.5, -1.0),
                              end: Alignment(0.5, 1.0)),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Material(
                          child: MaterialButton(
                            child: (!baseProvider
                                    .isEditAugmontBankDetailInProgress)
                                ? Text(
                                    (baseProvider.augmontDetail.bankAccNo == '')
                                        ? 'WITHDRAW'
                                        : 'UPDATE',
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
                              FocusScope.of(context).unfocus();
                              if (baseProvider.showNoInternetAlert(context))
                                return;
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
                    ],
                  )),
            ),
          ),
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
    var pConfirmBankAccNo = _bankAccNoConfirmController.text;
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

    if (pConfirmBankAccNo != pBankAccNo) {
      baseProvider.showNegativeAlert(
          'Fields mismatch', 'Bank account numbers do not match', context);
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    ///NOW CHECK IF IFSC IS VALID
    if (!iProvider.isInit()) await iProvider.init();
    var bankDetail =
        await iProvider.getBankInfo(baseProvider.userRegdPan, pBankIfsc);
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
    AppState.screenStack.add(ScreenItem.dialog);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AugmontConfirmRegnDialog(
              bankHolderName: pBankHolderName,
              bankAccNo: pBankAccNo,
              bankIfsc: pBankIfsc,
              bankName: bankDetail[GetBankDetail.resBankName],
              bankBranchName: bankDetail[GetBankDetail.resBranchName],
              dialogColor: augmontGoldPalette.primaryColor2,
              customMessage: (widget.isWithdrawFlow)
                  ? 'Are you sure you want to continue? ${baseProvider.activeGoldWithdrawalQuantity.toString()} grams of digital gold shall be processed.'
                  : '',
              onAccept: () async {
                ///FINALLY NOW UPDATE THE BANK DETAILS
                // baseProvider.augmontDetail.bankHolderName = pBankHolderName;
                // baseProvider.augmontDetail.bankAccNo = pBankAccNo;
                // baseProvider.augmontDetail.ifsc = pBankIfsc;
                baseProvider.updateAugmontDetails(
                    pBankHolderName, pBankAccNo, pBankIfsc);
                dbProvider
                    .updateUserAugmontDetails(
                        baseProvider.myUser.uid, baseProvider.augmontDetail)
                    .then((flag) {
                  if (widget.isWithdrawFlow) {
                    baseProvider.isEditAugmontBankDetailInProgress = false;
                    widget.addBankComplete();
                  } else {
                    baseProvider.isEditAugmontBankDetailInProgress = false;
                    setState(() {});
                    if (flag) {
                      baseProvider.showPositiveAlert('Complete',
                          'Your details have been updated', context);
                      AppState.backButtonDispatcher.didPopRoute();
                    } else {
                      baseProvider.showNegativeAlert(
                          'Failed',
                          'Your details could not be updated at the moment. Please try again',
                          context);
                    }
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
}
