import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/ui/elements/animated_line_chrt.dart';
import 'package:felloapp/ui/elements/deposit_modal_sheet.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/elements/profit_calculator.dart';
import 'package:felloapp/ui/elements/withdraw_dialog.dart';
import 'package:felloapp/ui/pages/deposit_verification.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/icici_onboard_controller.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/pan_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/personal_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MFDetailsPage extends StatefulWidget {
  @override
  _MFDetailsPageState createState() => _MFDetailsPageState();
}

class _MFDetailsPageState extends State<MFDetailsPage> {
  Log log = new Log('MFDetails');
  BaseUtil baseProvider;
  DBModel dbProvider;
  PaymentService payService;
  GlobalKey<DepositModalSheetState> _modalKey = GlobalKey();
  double containerHeight = 10;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    payService = Provider.of<PaymentService>(context);

    return Scaffold(
      appBar: BaseUtil.getAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    FundInfo(),
                    FundGraph(),
                    FundDetailsTable(),
                    ProfitCalculator(),
                    FAQCard(),
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

  String _getActionButtonText() {
    if (baseProvider.myUser.isKycVerified == BaseUtil.KYC_INVALID)
      return 'COMPLETE KYC';
    if (!baseProvider.myUser.isIciciOnboarded)
      return 'REGISTER';
    else
      return 'DEPOSIT';
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
          child: (!baseProvider.isDepositRouteLogicInProgress)
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
            HapticFeedback.vibrate();
            baseProvider.isDepositRouteLogicInProgress = true;
            setState(() {});
            ///////////DUMMY///////////////////////////////////
            // baseProvider.iciciDetail =
            // await dbProvider.getUserIciciDetails(baseProvider.myUser.uid);
            // Navigator.of(context).pop();
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (ctx) => DepositVerification(tranId: '3433559',userTxnId: 'tdcT4bxF0Gyv9qlhqmlx',
            //     panNumber: baseProvider.iciciDetail.panNumber,),
            // ));
            //////////////////////////////////////
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
        // boxShadow: [
        //   new BoxShadow(
        //     color: Colors.black12,
        //     offset: Offset.fromDirection(20, 7),
        //     blurRadius: 3.0,
        //   )
        // ],
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
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (BuildContext context) => WithdrawDialog(
                      balance: baseProvider.myUser.account_balance,
                      withdrawAction: (String wAmount, String recUpiAddress) {
                        Navigator.of(context).pop();
                        baseProvider.showPositiveAlert(
                            'Withdrawal Request Added',
                            'Your withdrawal amount shall be credited shortly',
                            context);
                        dbProvider
                            .addFundWithdrawal(
                                baseProvider.myUser.uid, wAmount, recUpiAddress)
                            .then((value) {});
                      },
                    ));
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  Future<bool> onDepositClicked() async {
    baseProvider.iciciDetail =
        await dbProvider.getUserIciciDetails(baseProvider.myUser.uid);
    if (baseProvider.myUser.isKycVerified == BaseUtil.KYC_VALID &&
        baseProvider.myUser.isIciciOnboarded) {
      //move directly to depositing
      baseProvider.isDepositRouteLogicInProgress = false;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return DepositModalSheet(
              key: _modalKey,
              onDepositConfirmed: (Map<String, dynamic> rMap) {
                payService.initiateTransaction(rMap['amount'], rMap['vpa']).then((resMap) {
                  if (!resMap['flag']) {
                    _modalKey.currentState.onErrorReceived(resMap['reason']??'Error: Unknown. Please restart the app');
                  }else{
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(
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
    if (baseProvider.myUser.isKycVerified == BaseUtil.KYC_INVALID) {
      baseProvider.isDepositRouteLogicInProgress = false;
      Navigator.of(context).pop(); //go back to save tab
      Navigator.of(context).pushNamed('/verifykyc');
      return true;
    } else {
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
      baseProvider.isDepositRouteLogicInProgress = false;
    }
    return true;
  }
}

class FundDetailsTable extends StatelessWidget {
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
                    title: "Current Price",
                    data: "999",
                    info: Assets.mfTableDetailsInfo[0],
                  ),
                  FundDetailsCell(
                    title: "CAGR%",
                    data: "5.0",
                    info: Assets.mfTableDetailsInfo[1],
                  ),
                ]),
                TableRow(children: [
                  FundDetailsCell(
                    title: "Age",
                    data: "15",
                    info: Assets.mfTableDetailsInfo[2],
                  ),
                  FundDetailsCell(
                    title: "Yeild%",
                    data: "4.55",
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
                              const url = 'https://flutter.dev';
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
  final Map<DateTime, double> line1 = {
    DateTime.utc(2018, 02, 19): 255.088,
    DateTime.utc(2018, 06, 04): 260.479,
    DateTime.utc(2018, 10, 01): 266.677,
    DateTime.utc(2018, 12, 10): 270.567,
    DateTime.utc(2019, 02, 18): 274.292,
    DateTime.utc(2019, 06, 03): 280.168,
    DateTime.utc(2019, 08, 02): 284.682,
    DateTime.utc(2019, 11, 04): 287.417,
    DateTime.utc(2020, 01, 10): 292.637,
    DateTime.utc(2020, 05, 25): 296.341,
    DateTime.utc(2020, 08, 17): 298.870,
    DateTime.utc(2020, 10, 12): 300.374,
    DateTime.utc(2020, 12, 14): 301.983,
    DateTime.utc(2021, 01, 18): 302.761,
  };

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    LineChart chart = AreaLineChart.fromDateTimeMaps(
      [line1],
      [UiConstants.primaryColor],
      ['₹'],
      gradients: [
        Pair(Colors.white, UiConstants.primaryColor.withOpacity(0.1))
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _height * 0.02,
      ),
      height: _height * 0.3,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomAnimatedLineChart(
          chart,
        ), //Unique key to force animations
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
                child: FittedBox(
              child: Text(
                "ICICI Prudential Mutual Fund",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
            )),
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
                          borderRadius:
                              BorderRadius.circular(UiConstants.padding),
                        ),
                        title: new Text(title),
                        content: Text(info),
                        actions: <Widget>[
                          new FlatButton(
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
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Colors.black54,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
