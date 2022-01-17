//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/transfer_amount_api_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/verify_amount_api_response_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/repository/signzy_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Dart and Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:felloapp/util/custom_logger.dart';
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
  final _userService = locator<UserService>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bankHolderNameController;
  TextEditingController _bankAccNoController;
  TextEditingController _bankIfscController;
  TextEditingController _bankAccNoConfirmController;
  final BaseAnalyticsService _analyticsService = locator<AnalyticsService>();
  final SignzyRepository _signzyRepository = locator<SignzyRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  bool _isInitialized = false;
  DBModel dbProvider;
  BaseUtil baseProvider;
  ICICIModel iProvider;
  bool isConfirm = false;
  bool inEditMode = false;
  FocusNode focusNode = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      baseProvider = Provider.of<BaseUtil>(context, listen: false);
      dbProvider = Provider.of<DBModel>(context, listen: false);
      iProvider = Provider.of<ICICIModel>(context, listen: false);
      if (baseProvider.myUser.isAugmontOnboarded &&
          baseProvider.augmontDetail == null) {
        setState(() {
          isLoading = true;
        });
        dbProvider
            .getUserAugmontDetails(baseProvider.myUser.uid)
            .then((detail) {
          _isInitialized = false;
          isLoading = false;
          print(detail.bankAccNo);
          baseProvider.augmontDetail = detail;
          if (baseProvider.augmontDetail == null ||
              widget.isWithdrawFlow ||
              baseProvider.augmontDetail.bankAccNo == null ||
              baseProvider.augmontDetail.bankAccNo == "") {
            inEditMode = true;
          } else {
            inEditMode = false;
          }
          setState(() {});
        });
      }
      if (baseProvider.augmontDetail == null)
        baseProvider.augmontDetail =
            UserAugmontDetail.newUser('', '', '', '', '', '');
      if (baseProvider.augmontDetail == null ||
          widget.isWithdrawFlow ||
          baseProvider.augmontDetail.bankAccNo == null ||
          baseProvider.augmontDetail.bankAccNo == "") {
        setState(() {
          inEditMode = true;
        });
      } else {
        setState(() {
          inEditMode = false;
        });
      }

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
        backgroundColor: UiConstants.primaryColor,
        resizeToAvoidBottomInset: false,
        body: HomeBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  FelloAppBar(
                    leading: FelloAppBarBackButton(),
                    title: "Bank Account Details",
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.padding40),
                            topRight: Radius.circular(SizeConfig.padding40),
                          ),
                          color: Colors.white),
                      child: isLoading
                          ? Container(
                              child: Center(
                                child: SpinKitWave(
                                  color: UiConstants.primaryColor,
                                  size: 30,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.pageHorizontalMargins),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Padding(
                                        //   padding: EdgeInsets.all(8),
                                        //   child: Text(
                                        //     (baseProvider.augmontDetail.bankAccNo == '')
                                        //         ? 'Enter your bank account details'
                                        //         : 'Update your bank account details',
                                        //     style: TextStyle(
                                        //         fontSize: SizeConfig.largeTextSize,
                                        //         fontWeight: FontWeight.w600),
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.fromLTRB(8, 3, 8, 8),
                                        //   child: Text(
                                        //     'This is where the amount received from selling your gold shall be credited.',
                                        //     style: TextStyle(
                                        //         fontSize: SizeConfig.mediumTextSize,
                                        //         fontWeight: FontWeight.w400),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bank Holder's Name",
                                              style: TextStyles.body3,
                                            ),
                                            SizedBox(height: 6),
                                            TextFormField(
                                              autofocus: true,
                                              enabled: inEditMode,
                                              keyboardType: TextInputType.name,
                                              inputFormatters: [
                                                UpperCaseTextFormatter(),
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[A-Z ]'))
                                              ],
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              controller:
                                                  _bankHolderNameController,
                                              validator: (value) {
                                                return (value == null ||
                                                        value.isEmpty ||
                                                        value.trim().length < 4)
                                                    ? 'Please enter you name as per your bank'
                                                    : null;
                                              },
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              },
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bank Account Number",
                                              style: TextStyles.body3,
                                            ),
                                            SizedBox(height: 6),
                                            TextFormField(
                                              enabled: inEditMode,
                                              controller: _bankAccNoController,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      signed: true),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    18),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              validator: (value) {
                                                print(value);

                                                if (value == null &&
                                                    value.trim().isEmpty)
                                                  return 'Please enter a valid account number';
                                                else if (value.trim().length <
                                                        9 ||
                                                    value.trim().length > 18)
                                                  return 'Invalid Bank Account Number';
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Confirm Account Number",
                                              style: TextStyles.body3,
                                            ),
                                            SizedBox(height: 6),
                                            TextFormField(
                                              enabled: inEditMode,
                                              controller:
                                                  _bankAccNoConfirmController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              obscureText: true,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    18),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              validator: (value) {
                                                print(value);
                                                if (value == null &&
                                                    value.trim().isEmpty)
                                                  return 'Please enter a valid account number';
                                                else if (value.trim() !=
                                                    _bankAccNoController.text
                                                        .trim())
                                                  return "Bank account numbers did not match";
                                                else if (value.trim().length <
                                                        9 ||
                                                    value.trim().length > 18)
                                                  return 'Invalid Bank Account Number';

                                                return null;
                                              },
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bank IFSC Code',
                                              style: TextStyles.body3,
                                            ),
                                            SizedBox(height: 6),
                                            TextFormField(
                                              enabled: inEditMode,
                                              controller: _bankIfscController,
                                              keyboardType:
                                                  TextInputType.streetAddress,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              validator: (value) {
                                                print(value);
                                                if (value == null &&
                                                    value.trim().isEmpty)
                                                  return 'Please enter a valid bank IFSC';
                                                else if (value.trim().length <
                                                        6 ||
                                                    value.trim().length > 25)
                                                  return 'Please enter a valid bank IFSC';
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (!isLoading)
                Positioned(
                  bottom: 10,
                  child: SafeArea(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Container(
                        width: SizeConfig.navBarWidth,
                        child: FelloButtonLg(
                          child:
                              (!baseProvider.isEditAugmontBankDetailInProgress)
                                  ? Text(
                                      inEditMode ? 'UPDATE' : 'EDIT',
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
                            if (inEditMode) {
                              FocusScope.of(context).unfocus();
                              if (BaseUtil.showNoInternetAlert()) return;

                              if (_formKey.currentState.validate()) {
                                _onUpdateClicked();
                              }
                            } else {
                              setState(() {
                                inEditMode = true;
                              });
                              FocusScope.of(context).autofocus(focusNode);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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

    var curBankHolderName = baseProvider.augmontDetail?.bankHolderName;
    var curBankAccNo = baseProvider.augmontDetail?.bankAccNo;
    var curBankIfsc = baseProvider.augmontDetail?.ifsc;

    bool noChanges = true;
    if (curBankHolderName == null || pBankHolderName != curBankHolderName)
      noChanges = false;
    if (curBankAccNo == null || pBankAccNo != curBankAccNo) noChanges = false;
    if (curBankIfsc == null || pBankIfsc != curBankIfsc) noChanges = false;
    if (noChanges) {
      BaseUtil.showNegativeAlert(
        'No Update',
        'No changes were made',
      );
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    if (pConfirmBankAccNo != pBankAccNo) {
      BaseUtil.showNegativeAlert(
        'Fields mismatch',
        'Bank account numbers do not match',
      );
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    final ifscCodeValidation = RegExp(r'^[^\s]{4}\d{7}$');
    if (!ifscCodeValidation.hasMatch(pBankIfsc)) {
      BaseUtil.showNegativeAlert(
        'Invalid IFSC Code',
        'Please check your ifsc code.',
      );
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    final accountNoValidation = RegExp(r'^\d{9,18}$');
    if (!accountNoValidation.hasMatch(pConfirmBankAccNo)) {
      BaseUtil.showNegativeAlert(
        'Invalid Account Number',
        'Please check your account number.',
      );
      baseProvider.isEditAugmontBankDetailInProgress = false;
      setState(() {});
      return;
    }

    final ApiResponse<TransferAmountApiResponseModel> response =
        await _signzyRepository.transferAmount(
            mobile: baseProvider.myUser.mobile,
            name: pBankHolderName,
            ifsc: pBankIfsc,
            accountNo: pConfirmBankAccNo);

    if (response.code == 200) {
      final TransferAmountApiResponseModel _transferAmountResponse =
          response.model;

      _logger.d(_transferAmountResponse.toString());

      if (!_transferAmountResponse.active ||
          !_transferAmountResponse.nameMatch) {
        BaseUtil.showNegativeAlert(
          'Account Verification Failed',
          'Please recheck your entered account number and name',
        );
        baseProvider.isEditAugmontBankDetailInProgress = false;
        setState(() {});
        return;
      }

      //Verify Transfer
      final ApiResponse<VerifyAmountApiResponseModel> res =
          await _signzyRepository.verifyAmount(
        signzyId: _transferAmountResponse.signzyReferenceId,
      );

      if (res.code != 200) {
        BaseUtil.showNegativeAlert(
          'Account Verification Failed',
          'Please verify your account details and try again',
        );
        baseProvider.isEditAugmontBankDetailInProgress = false;
        setState(() {});
        return;
      }

      // BaseUtil.showPositiveAlert(
      //   'Account Verification Successful',
      //   'Your bank account details has been successfully verified!',
      // );
    } else {
      BaseUtil.showNegativeAlert(
        'Account could not be verified',
        'Please verify your account details and try again',
      );
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
              bankName: "",
              dialogColor: UiConstants.primaryColor,
              customMessage: (widget.isWithdrawFlow)
                  ? 'Are you sure you want to continue? ${baseProvider.activeGoldWithdrawalQuantity.toString()} grams of digital gold shall be processed.'
                  : '',
              onAccept: () async {
                ///FINALLY NOW UPDATE THE BANK DETAILS
                baseProvider.augmontDetail.bankHolderName =
                    pBankHolderName.trim();
                baseProvider.augmontDetail.bankAccNo = pBankAccNo.trim();
                baseProvider.augmontDetail.ifsc = pBankIfsc.trim();
                baseProvider.updateAugmontDetails(pBankHolderName.trim(),
                    pBankAccNo.trim(), pBankIfsc.trim());
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
                      _analyticsService.track(
                          eventName: AnalyticsEvents.bankDetailsUpdated);
                      BaseUtil.showPositiveAlert(
                          'Complete', 'Your details have been updated');
                      AppState.backButtonDispatcher.didPopRoute();
                    } else {
                      BaseUtil.showNegativeAlert(
                        'Failed',
                        'Your details could not be updated at the moment. Please try again',
                      );
                    }
                  }
                });
              },
              onReject: () {
                BaseUtil.showNegativeAlert(
                  'Update Cancelled',
                  'Please try again',
                );
                baseProvider.isEditAugmontBankDetailInProgress = false;
                setState(() {});
                return;
              },
            ));
  }
}
