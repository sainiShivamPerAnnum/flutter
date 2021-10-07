import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/ui/dialogs/integrated_icici_disabled_dialog.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/elements/profit_calculator.dart';
import 'package:felloapp/ui/modals/icici_deposit_modal_sheet.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/icici_onboard_controller.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/pan_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/personal_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'deposit_verification.dart';
import 'icici_withdrawal_screen.dart';

class MFDetailsPage extends StatefulWidget {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;
  static const int STATUS_KYC_REQD = 3;

  @override
  _MFDetailsPageState createState() => _MFDetailsPageState();

  static int checkICICIDespositStatus(BaseUser baseUser) {
    //check who is allowed to deposit
    String _perm = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.ICICI_DEPOSIT_PERMISSION);
    int _isGeneralUserAllowed = 1;
    bool _isAllowed = false;
    if (_perm != null && _perm.isNotEmpty) {
      try {
        _isGeneralUserAllowed = int.parse(_perm);
      } catch (e) {
        _isGeneralUserAllowed = 1;
      }
    }
    if (_isGeneralUserAllowed == 0) {
      //General permission is denied. Check if specific user permission granted
      if (baseUser.isIciciEnabled != null && baseUser.isIciciEnabled) {
        //this specific user is allowed to use ICICI
        _isAllowed = true;
      } else {
        _isAllowed = false;
      }
    } else {
      _isAllowed = true;
    }

    if (!_isAllowed) return STATUS_UNAVAILABLE;
    if (baseUser.isKycVerified != null &&
        baseUser.isKycVerified == Constants.KYC_INVALID) return STATUS_KYC_REQD;
    if (baseUser.isIciciOnboarded == null || baseUser.isIciciOnboarded == false)
      return STATUS_REGISTER;
    else
      return STATUS_OPEN;
  }
}

class _MFDetailsPageState extends State<MFDetailsPage> {
  Log log = new Log('MFDetails');
  BaseUtil baseProvider;
  DBModel dbProvider;
  PaymentService payService;
  GlobalKey<DepositModalSheetState> _modalKey = GlobalKey();
  GlobalKey<ICICIWithdrawalState> _withdrawalDialogKey = GlobalKey();
  double containerHeight = 10;
  Map<String, dynamic> _withdrawalRequestDetails;
  double instantAmount = 0, nonInstantAmount = 0;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    payService = Provider.of<PaymentService>(context, listen: false);

    return Scaffold(
      appBar: BaseUtil.getAppBar(context, null),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FundInfo(),
                    FundGraph(),
                    const FundDetailsTable(),
                    ProfitCalculator(
                      calFactor: (0.06 / 12),
                      invGradient: [
                        Colors.blueGrey[600],
                        Colors.blueGrey,
                      ],
                      retGradient: [
                        UiConstants.primaryColor.withGreen(190),
                        UiConstants.primaryColor
                      ],
                    ),
                    FAQCard(
                        Assets.mfFaqHeaders, Assets.mfFaqAnswers, Colors.white),
                    _buildBetaWithdrawButton(),
                  ],
                ),
              ),
            ),
          ),
          _buildBetaSaveButton(),
        ],
      ),
    );
  }

  Widget _buildBetaSaveButton() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          UiConstants.primaryColor,
          UiConstants.primaryColor.withBlue(200),
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
      ),
      child: new Material(
        child: MaterialButton(
          child: (!baseProvider.isIciciDepositRouteLogicInProgress)
              ? Text(
                  _getActionButtonText(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                )
              : SpinKitThreeBounce(
                  color: UiConstants.spinnerColor2,
                  size: 18.0,
                ),
          onPressed: () async {
            Haptic.vibrate();
            baseProvider.isIciciDepositRouteLogicInProgress = true;
            setState(() {});
            onDepositClicked().then((value) {
              setState(() {});
            });
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  Widget _buildBetaWithdrawButton() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: MediaQuery.of(context).size.height * 0.02,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: new LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.blueGrey[800],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0),
        ),
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WITHDRAW ',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            Haptic.vibrate();
            onWithdrawalClicked();
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  String _getActionButtonText() {
    int _status = MFDetailsPage.checkICICIDespositStatus(baseProvider.myUser);
    switch (_status) {
      case MFDetailsPage.STATUS_UNAVAILABLE:
        return 'COMING SOON!';
      case MFDetailsPage.STATUS_KYC_REQD:
        return 'COMPLETE KYC';
      case MFDetailsPage.STATUS_REGISTER:
        return 'REGISTER';
      case MFDetailsPage.STATUS_OPEN:
        return 'DEPOSIT';
      default:
        return 'DEPOSIT';
    }
  }

  Future<bool> onDepositClicked() async {
    baseProvider.iciciDetail = (baseProvider.iciciDetail == null)
        ? (await dbProvider.getUserIciciDetails(baseProvider.myUser.uid))
        : baseProvider.iciciDetail;
    int _status = MFDetailsPage.checkICICIDespositStatus(baseProvider.myUser);
    switch (_status) {
      case MFDetailsPage.STATUS_UNAVAILABLE:
        {
          baseProvider.isIciciDepositRouteLogicInProgress = false;
          showDialog(
              context: context,
              builder: (BuildContext context) => IntegratedIciciDisabled());
          return true;
        }
      case MFDetailsPage.STATUS_KYC_REQD:
        {
          baseProvider.isIciciDepositRouteLogicInProgress = false;
          Navigator.of(context).pop(); //go back to save tab
          Navigator.of(context).pushNamed('/initkyc');
          return true;
        }
      case MFDetailsPage.STATUS_REGISTER:
        {
          Navigator.of(context).pop(); //go back to save tab
          if (baseProvider.iciciDetail != null &&
              baseProvider.iciciDetail.panNumber != null &&
              baseProvider.iciciDetail.appId != null &&
              baseProvider.iciciDetail.panName != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => IciciOnboardController(
                    startIndex: PersonalPage.index,
                    appIdExists: true,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => IciciOnboardController(
                    startIndex: PANPage.index,
                    appIdExists: false,
                  ),
                ));
          }
          baseProvider.isIciciDepositRouteLogicInProgress = false;
          return true;
        }
      case MFDetailsPage.STATUS_OPEN:
      default:
        {
          //move directly to depositing
          baseProvider.isIciciDepositRouteLogicInProgress = false;
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DepositModalSheet(
                  key: _modalKey,
                  onDepositConfirmed: (Map<String, dynamic> rMap) {
                    payService
                        .initiateTransaction(rMap['amount'], rMap['vpa'])
                        .then((resMap) {
                      if (!resMap['flag']) {
                        _modalKey.currentState.onErrorReceived(
                            resMap['reason'] ??
                                'Error: Unknown. Please restart the app');
                      } else {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DepositVerification(),
                            ));
                      }
                      return;
                    });
                  },
                );
              });
          return true;
        }
    }
  }

  onWithdrawalClicked() {
    if (!baseProvider.myUser.isIciciOnboarded) {
      baseProvider.showNegativeAlert(
          'Not onboarded', 'You havent been onboarded to ICICI yet', context);
    } else if (baseProvider.userFundWallet.iciciBalance == null ||
        baseProvider.userFundWallet.iciciBalance == 0) {
      baseProvider.showNegativeAlert(
          'No balance', 'Your ICICI wallet has no balance presently', context);
    } else {
      Haptic.vibrate();
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (ctx) => ICICIWithdrawal(
              key: _withdrawalDialogKey,
              currentBalance: baseProvider.userFundWallet.iciciBalance,
              onAmountConfirmed: (Map<String, double> amountDetails) {},
              onOptionConfirmed: (bool flag) {},
              onOtpConfirmed: (Map<String, String> otpMap) {
                // payService.verifyNonInstantRedemptionOtp(otp)
              }),
        ),
      );
    }
  }
}

class FundDetailsTable extends StatelessWidget {
  const FundDetailsTable();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _height * 0.02,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: _height * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(5, 5),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
                verticalInside: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              children: [
                TableRow(children: [
                  FundDetailsCell(
                    title: "NAV",
                    data: "₹301.72",
                    info: Assets.mfTableDetailsInfo[0],
                  ),
                  FundDetailsCell(
                    title: "CAGR",
                    data: "7.51%",
                    info: Assets.mfTableDetailsInfo[1],
                  ),
                ]),
                TableRow(children: [
                  FundDetailsCell(
                    title: "Age",
                    data: "15 yrs",
                    info: Assets.mfTableDetailsInfo[2],
                  ),
                  FundDetailsCell(
                    title: "AUM",
                    data: "42176.95cr",
                    info: Assets.mfTableDetailsInfo[3],
                  ),
                ]),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: RichText(
                text: TextSpan(
                    text: "For More Details visit ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: 'Official Site',
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://www.icicipruamc.com/mutual-fund/debt-funds/icici-prudential-liquid-fund';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                    ]),
              )),
        ],
      ),
    );
  }
}

class FundGraph extends StatelessWidget {
  FundGraph();
  BaseUtil baseProvider;

  final Map<int, DateTime> dates = {
    1: DateTime.utc(2018, 02, 19),
    2: DateTime.utc(2018, 06, 04),
    3: DateTime.utc(2018, 10, 01),
    4: DateTime.utc(2018, 12, 10),
    5: DateTime.utc(2019, 02, 18),
    6: DateTime.utc(2019, 06, 03),
    7: DateTime.utc(2019, 08, 02),
    8: DateTime.utc(2019, 11, 04),
    9: DateTime.utc(2020, 01, 10),
    10: DateTime.utc(2020, 05, 25),
    11: DateTime.utc(2020, 08, 17),
    12: DateTime.utc(2020, 10, 12),
    13: DateTime.utc(2020, 12, 14),
    14: DateTime.utc(2021, 01, 18),
  };

  final Map<int, double> line1 = {
    1: 255.088,
    2: 260.479,
    3: 266.677,
    4: 270.567,
    5: 274.292,
    6: 280.168,
    7: 284.682,
    8: 287.417,
    9: 292.637,
    10: 296.341,
    11: 298.870,
    12: 300.374,
    13: 301.983,
    14: 302.761,
  };

  final List<Color> gradientColors = [UiConstants.primaryColor, Colors.white];
  getValue(int val) {
    DateTime time = dates[val];
    String showText;

    return val % 2 != 0
        ? time.day.toString() + "\n" + showText + "\n" + time.year.toString()
        : "";
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    List<FlSpot> dataItems = [];
    for (int i = 0; i < line1.length; i++) {
      dataItems.add(FlSpot(i.toDouble(), line1[i + 1]));
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: SizeConfig.screenHeight * 0.24,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 13,
          minY: 0,
          maxY: 350,
          lineTouchData: LineTouchData(
            enabled: true,
          ),
          gridData: FlGridData(
            show: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d).withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          axisTitleData: FlAxisTitleData(
            show: true,
            topTitle: AxisTitle(
                showTitle: true, titleText: "FUND HISTORY FOR LAST 3 YEARS"),
          ),
          borderData: FlBorderData(
              show: false,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.4)))),
          titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTextStyles: (value) => GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: SizeConfig.smallTextSize,
                ),
                getTitles: (value) {
                  DateTime date = dates[value.toInt() + 1];
                  return value % 2 != 0
                      ? DateFormat('dd MMM\nyyyy').format(date)
                      : "";
                },
              ),
              leftTitles: SideTitles(margin: 0)),
          lineBarsData: [
            LineChartBarData(
              spots: dataItems,
              isCurved: true,
              isStrokeCapRound: false,
              colors: gradientColors,
              gradientFrom: Offset(SizeConfig.screenWidth * 0.5, 0),
              gradientTo:
                  Offset(SizeConfig.screenWidth * 0.5, SizeConfig.screenHeight),
              barWidth: 2,
              dotData: FlDotData(
                  show: false,
                  getDotPainter: (spot, d, data, i) {
                    return FlDotCirclePainter(
                      radius: 1,
                      color: UiConstants.primaryColor,
                      strokeColor: Colors.red,
                      strokeWidth: 2,
                    );
                  },
                  checkToShowDot: (spot, data) {
                    return true;
                  }),
              belowBarData: BarAreaData(
                show: true,
                gradientColorStops: [0.6, 1],
                gradientFrom: Offset(0.5, 0),
                gradientTo: Offset(0.5, 1),
                colors: gradientColors
                    .map((color) => color.withOpacity(0.2))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: _height * 0.02,
                top: _height * 0.02,
                bottom: _height * 0.02,
              ),
              width: _width * 0.2,
              child: Image.asset(Assets.iciciGraphic, fit: BoxFit.contain),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "ICICI Prudential Mutual Fund",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.largeTextSize),
              ),
            ),
            SizedBox(
              width: _height * 0.02,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: _height * 0.02, left: 20, right: 30),
          child: Text(
            'ICICI Prudential Liquid Mutual Fund is a'
            ' popular fund that has consistently given an annual return of 6-7%.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: UiConstants.accentColor, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

class FundDetailsCell extends StatelessWidget {
  final String title, data, info;

  FundDetailsCell({
    @required this.data,
    @required this.title,
    @required this.info,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      height: 75,
      width: _width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
            ),
            child: Row(
              children: [
                Text(
                  "$title ",
                ),
                GestureDetector(
                  child: Icon(
                    Icons.info_outline,
                    size: 12,
                    color: UiConstants.spinnerColor,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.cardBorderRadius),
                        ),
                        title: new Text(title),
                        content: Text(info),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(); // dismisses only the dialog and returns nothing
                            },
                            child: new Text(
                              'OK',
                              style: TextStyle(
                                color: UiConstants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(data,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black54,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
