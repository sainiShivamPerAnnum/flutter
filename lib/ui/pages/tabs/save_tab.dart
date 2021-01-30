import 'dart:async';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/guide_dialog.dart';
import 'package:felloapp/ui/elements/roulette_trial.dart';
import 'package:felloapp/ui/elements/scrolling_text.dart';
import 'package:felloapp/ui/pages/mf_details_page.dart';
import 'package:felloapp/ui/pages/onboarding/interface/kyc_onboarding_interface.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  int acctBalance = 0;
  bool displayInfoText = false;
  bool displayTransactionText = false;

  @override
  void initState() {
    super.initState();
    new Timer(const Duration(milliseconds: 800), () {
      setState(() {
        displayInfoText = true;
      });
    });
    new Timer(const Duration(milliseconds: 1100), () {
      setState(() {
        displayTransactionText = true;
      });
    });
  }

  _init() {
    if (fcmProvider != null && baseProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          baseProvider.showPositiveAlert(
              valueMap['title'], valueMap['body'], context,
              seconds: 5);
        }
      }, 1);
      if (baseProvider.myUser.account_balance != null &&
          baseProvider.myUser.account_balance > 0)
        acctBalance = baseProvider.myUser.account_balance;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (fcmProvider != null) fcmProvider.addIncomingMessageListener(null, 1);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    fcmProvider = Provider.of<FcmHandler>(context);
    _init();

    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.6],
              colors: [
                UiConstants.primaryColor.withGreen(190),
                UiConstants.primaryColor,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(
                  MediaQuery.of(context).size.width * 0.50, 18),
              bottomRight: Radius.elliptical(
                  MediaQuery.of(context).size.width * 0.50, 18),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 5,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.menu),
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.help_outline),
            onPressed: () {
              HapticFeedback.vibrate();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => GuideDialog());
            },
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Text(
                    '₹' + acctBalance.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    'saved',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            )),

        SafeArea(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      child: Opacity(
                          opacity: 0.5,
                          child: Image(
                            image: AssetImage(Assets.sebiGraphic),
                            fit: BoxFit.contain,
                          )),
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(
                      child: Opacity(
                          opacity: 0.5,
                          child: Image(
                            image: AssetImage(Assets.amfiGraphic),
                            fit: BoxFit.contain,
                          )),
                      height: 80,
                      width: 80,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  color: UiConstants.primaryColor,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => Roulette(),
                      ),
                    ),
                    child: Text(
                      "Roulette",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  color: UiConstants.primaryColor,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => KycOnboardInterface(),
                      ),
                    ),
                    child: Text(
                      "KYC Onboard Interface",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
        SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 130), child: _buildLayout())),
        // SafeArea(
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(
        //       padding: EdgeInsets.only(bottom: 55),
        //       child: _buildDepositInfoDialogs(),
        //     ),
        //   ),
        // )
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: _buildButton()
        // )
      ],
    );
  }

  Widget _buildLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFundList2(),
        SizedBox(
          height: 10,
        ),
        // _buildDividerText(),
        // SizedBox(
        //   height: 20,
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 20, right: 20),
        //   child: _buildBetaSaveButton(),
        // ),
        // //_buildDepositButtonRow(),
        // SizedBox(
        //   height: 15,
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 20, right: 20),
        //   child: _buildBetaWithdrawButton(),
        // ),
        // SizedBox(
        //   height: 60,
        // ),
      ],
    );
  }

  // Widget _buildDepositInfoDialogs() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       AnimatedContainer(
  //         duration: Duration(milliseconds: 350),
  //         padding: EdgeInsets.all(8),
  //         width: (displayInfoText) ? 200 : 50,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [
  //             new BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset.fromDirection(20, 3),
  //               blurRadius: 2.0,
  //             )
  //           ],
  //           borderRadius: BorderRadius.all(Radius.circular(20)),
  //           gradient: LinearGradient(
  //             begin: Alignment.topRight,
  //             end: Alignment.bottomLeft,
  //             stops: [0.1, 0.4],
  //             colors: [Colors.white, Colors.white],
  //           ),
  //         ),
  //         child: InkWell(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 Icons.info_outline,
  //                 color: Colors.blueGrey,
  //               ),
  //               (displayInfoText)
  //                   ? Text(
  //                       ' More about the fund',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(color: Colors.blueGrey),
  //                     )
  //                   : Container()
  //             ],
  //           ),
  //           onTap: () async {
  //             HapticFeedback.vibrate();
  //             const url =
  //                 "https://www.icicipruamc.com/mutual-fund/debt-funds/icici-prudential-liquid-fund";
  //             if (await canLaunch(url)) {
  //               await launch(url);
  //             } else {
  //               baseProvider.showNegativeAlert(
  //                   'Unable to launch', 'Please try again later', context);
  //             }
  //           },
  //         ),
  //       ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       AnimatedContainer(
  //         duration: Duration(milliseconds: 350),
  //         padding: EdgeInsets.all(8),
  //         width: (displayTransactionText) ? 200 : 50,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [
  //             new BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset.fromDirection(20, 3),
  //               blurRadius: 2.0,
  //             )
  //           ],
  //           borderRadius: BorderRadius.all(Radius.circular(20)),
  //           gradient: LinearGradient(
  //             begin: Alignment.topRight,
  //             end: Alignment.bottomLeft,
  //             stops: [0.1, 0.4],
  //             colors: [Colors.white, Colors.white],
  //           ),
  //         ),
  //         child: InkWell(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 Icons.swap_vertical_circle,
  //                 color: Colors.blueGrey,
  //               ),
  //               (displayTransactionText)
  //                   ? Text(
  //                       ' How transactions work',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(color: Colors.blueGrey),
  //                     )
  //                   : Container()
  //             ],
  //           ),
  //           onTap: () {
  //             HapticFeedback.vibrate();
  //             showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) => TransactionDialog());
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDepositButtonRow() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 10, right: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: _buildBetaSaveButton(),
  //         ),
  //         SizedBox(
  //           width: 5,
  //         ),
  //         Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             borderRadius: new BorderRadius.circular(10.0),
  //             border: Border.all(width: 5, color: UiConstants.primaryColor),
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Icon(
  //               Icons.priority_high,
  //               color: UiConstants.primaryColor,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDividerText() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              indent: 20,
              endIndent: 5,
              color: Colors.blueGrey[200],
            ),
          ),
          Expanded(
            child: Text(
              'Other methods',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey[300]),
            ),
          ),
          Expanded(
            child: Divider(
              indent: 5,
              endIndent: 20,
              color: Colors.blueGrey[200],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBetaSaveButton() {
  //   return Container(
  //     width: double.infinity,
  //     height: 50.0,
  //     decoration: BoxDecoration(
  //       gradient: new LinearGradient(colors: [
  //         UiConstants.primaryColor,
  //         UiConstants.primaryColor.withBlue(190),
  //       ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
  //       borderRadius: new BorderRadius.circular(10.0),
  //       // boxShadow: [
  //       //   new BoxShadow(
  //       //     color: Colors.black12,
  //       //     offset: Offset.fromDirection(20, 7),
  //       //     blurRadius: 3.0,
  //       //   )
  //       // ],
  //     ),
  //     child: new Material(
  //       child: MaterialButton(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'DEPOSIT ',
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .button
  //                   .copyWith(color: Colors.white),
  //             ),
  //             // Text(
  //             //   'BETA',
  //             //   style: Theme.of(context).textTheme.button.copyWith(
  //             //         color: Colors.white,
  //             //         fontStyle: FontStyle.italic,
  //             //         fontSize: 10,
  //             //       ),
  //             // ),
  //           ],
  //         ),
  //         onPressed: () async {
  //           HapticFeedback.vibrate();
  //           Navigator.of(context).pushNamed('/deposit');
  //         },
  //         highlightColor: Colors.orange.withOpacity(0.5),
  //         splashColor: Colors.orange.withOpacity(0.5),
  //       ),
  //       color: Colors.transparent,
  //       borderRadius: new BorderRadius.circular(20.0),
  //     ),
  //   );
  // }

  // Widget _buildBetaWithdrawButton() {
  //   return Container(
  //     width: double.infinity,
  //     height: 50.0,
  //     decoration: BoxDecoration(
  //       gradient: new LinearGradient(colors: [
  //         Colors.blueGrey,
  //         Colors.blueGrey[600],
  //       ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
  //       borderRadius: new BorderRadius.circular(10.0),
  //       // boxShadow: [
  //       //   new BoxShadow(
  //       //     color: Colors.black12,
  //       //     offset: Offset.fromDirection(20, 7),
  //       //     blurRadius: 3.0,
  //       //   )
  //       // ],
  //     ),
  //     child: new Material(
  //       child: MaterialButton(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'WITHDRAW ',
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .button
  //                   .copyWith(color: Colors.white),
  //             ),
  //             // Text(
  //             //   'BETA',
  //             //   style: Theme.of(context).textTheme.button.copyWith(
  //             //         color: Colors.white,
  //             //         fontStyle: FontStyle.italic,
  //             //         fontSize: 10,
  //             //       ),
  //             // ),
  //           ],
  //         ),
  //         onPressed: () async {
  //           HapticFeedback.vibrate();
  //           showDialog(
  //               context: context,
  //               builder: (BuildContext context) => WithdrawDialog(
  //                     balance: baseProvider.myUser.account_balance,
  //                     withdrawAction: (String wAmount, String recUpiAddress) {
  //                       Navigator.of(context).pop();
  //                       baseProvider.showPositiveAlert(
  //                           'Withdrawal Request Added',
  //                           'Your withdrawal amount shall be credited shortly',
  //                           context);
  //                       dbProvider
  //                           .addFundWithdrawal(
  //                               baseProvider.myUser.uid, wAmount, recUpiAddress)
  //                           .then((value) {});
  //                     },
  //                   ));
  //         },
  //         highlightColor: Colors.orange.withOpacity(0.5),
  //         splashColor: Colors.orange.withOpacity(0.5),
  //       ),
  //       color: Colors.transparent,
  //       borderRadius: new BorderRadius.circular(20.0),
  //     ),
  //   );
  // }

  _buildFundList2() {
    return Padding(
        padding: EdgeInsets.all(40.0),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MFDetailsPage(),
            ),
          ),
          child: Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: UiConstants.primaryColor.withGreen(160),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Opacity(
                        opacity: 0.6,
                        child: Image(
                          image: AssetImage(Assets.iciciGraphic),
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: 500,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              UiConstants.primaryColor.withGreen(160),
                              UiConstants.primaryColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "SAVE NOW",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // Center(
                //   child: Padding(
                //       padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
                //       child: ScrollingText(
                //         text: 'Direct deposits are coming soon!  ',
                //         textStyle: TextStyle(
                //             fontSize: 36,
                //             fontStyle: FontStyle.italic,
                //             fontWeight: FontWeight.w300,
                //             color: Colors.blueGrey[900]),
                //       )),
                // ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Padding(
                //     padding: EdgeInsets.only(top: 10),
                //     child: InkWell(
                //       child: Text('More about the fund',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 15,
                //           color: Colors.blueGrey[200],
                //           decoration: TextDecoration.underline,
                //         ),
                //       ),
                //       onTap: () async{
                //         const url = "https://www.icicipruamc.com/mutual-fund/debt-funds/icici-prudential-liquid-fund";
                //         if (await canLaunch(url)) {
                //           await launch(url);
                //         }
                //         else {
                //           baseProvider.showNegativeAlert('Unable to launch', 'Please try again later', context);
                //         }
                //       },
                //     ),
                //   ),
                // )
              ])),
        ));
  }

  _buildFundList() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.blueGrey[400],
            boxShadow: [
              new BoxShadow(
                color: Colors.black26,
                offset: Offset.fromDirection(20, 7),
                blurRadius: 5.0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.4],
              colors: [Colors.white70, Colors.white],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      'ICICI Prudential Liquid Mutual Fund is a'
                      ' popular fund that has consistently given an annual return of 6-7%.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: UiConstants.accentColor),
                    ),
                  ),
                  SizedBox(
                    child: Opacity(
                        opacity: 0.2,
                        child: Image(
                          image: AssetImage(Assets.iciciGraphic),
                          fit: BoxFit.contain,
                        )),
                    height: 180,
                    width: 500,
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: UiConstants.accentColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'ICICI Prudential Liquid Mutual Fund is a'
                                ' popular fund that has consistently given an annual return of 6-7%. '),
                        TextSpan(
                            text: 'Read more about it here.',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    "https://www.icicipruamc.com/mutual-fund/debt-funds/icici-prudential-liquid-fund";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  baseProvider.showNegativeAlert(
                                      'Unable to launch',
                                      'Please try again later',
                                      context);
                                }
                              }),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Opacity(
                      opacity: 0.2,
                      child: Image(
                        image: AssetImage(Assets.iciciGraphic),
                        fit: BoxFit.contain,
                      )),
                  height: 180,
                  width: 500,
                ),
              ),

              // Center(
              //  child: Text(
              //    'Coming Soon!',
              //    style: TextStyle(
              //      fontSize: 36,
              //      fontStyle: FontStyle.italic,
              //      fontWeight: FontWeight.w800,
              //      color: Colors.blueGrey[700]
              //    ),
              //  )
              // ),
              Padding(
                  padding: EdgeInsets.only(bottom: 60, left: 10, right: 10),
                  child: ScrollingText(
                    text: 'Direct deposits are coming soon!  ',
                    textStyle: TextStyle(
                        fontSize: 36,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.blueGrey[900]),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Text(''),
                // Row(
                //   children: [
                //
                //     Padding(
                //       padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                //       child: Text('ICICI Prudential Liquid Mutual Fund is a '
                //           ' popular fund that has consistently given an annual return in the range of 6.6%.',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       child: Text('More about the fund',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 15,
                //           color: Colors.blueGrey,
                //           decoration: TextDecoration.underline,
                //         ),
                //       ),
                //       onTap: () async{
                //         const url = "https://www.icicipruamc.com/mutual-fund/debt-funds/icici-prudential-liquid-fund";
                //         if (await canLaunch(url)) {
                //           await launch(url);
                //         }
                //         else {
                //           baseProvider.showNegativeAlert('Unable to launch', 'Please try again later', context);
                //         }
                //       },
                //     )
                //   ],
                // ),
              ),
            ],
          ),
        ));
  }
}
