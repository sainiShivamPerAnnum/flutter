import 'dart:math';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/guide_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SaveScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  int acctBalance = 0;

  _init() {
    if(fcmProvider != null && baseProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if(valueMap['title'] != null && valueMap['body'] != null){
          baseProvider.showPositiveAlert(valueMap['title'], valueMap['body'], context, seconds: 5);
        }
      },1);
      if(baseProvider.myUser.account_balance != null && baseProvider.myUser.account_balance>0)acctBalance = baseProvider.myUser.account_balance;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(fcmProvider != null) fcmProvider.addIncomingMessageListener(null,1);
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
            icon: Icon(Icons.settings),
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
                  builder: (BuildContext context) => GuideDialog()
              );
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
                    '₹'+acctBalance.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),

                  ),
                  Text(
                    'saved',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            )
        ),
        SafeArea(
            child: Padding(
            padding: EdgeInsets.only(top: 130),
            child: _buildLayout())
        ),
        SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      child: Opacity(
                          opacity: 0.2,
                          child: Image(
                            image: AssetImage(Assets.sebiGraphic),
                            fit: BoxFit.contain,
                          )
                      ),
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(
                      child: Opacity(
                          opacity: 0.2,
                          child: Image(
                            image: AssetImage(Assets.amfiGraphic),
                            fit: BoxFit.contain,
                          )
                      ),
                      height: 80,
                      width: 80,
                    )
                  ],
                ),
              ),
            )
        ),
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
        _buildFundList(),
        SizedBox(height: 15,),
        _buildBetaSaveButton()
      ],
    );
  }

  Widget _buildBetaSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width-40,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              UiConstants.primaryColor,
              UiConstants.primaryColor.withBlue(190),
            ],
            begin: Alignment(0.5, -1.0),
            end: Alignment(0.5, 1.0)
        ),
        borderRadius: new BorderRadius.circular(10.0),
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
              Text('DEPOSIT ',
                style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
              ),
              Text('BETA',
                style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.white,fontStyle: FontStyle.italic,
                  fontSize: 10,

                ),
              ),
            ],
          ),
          onPressed: () async{
            HapticFeedback.vibrate();
            Navigator.of(context).pushNamed('/deposit');
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  _buildFundList() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey[400],
              boxShadow: [new BoxShadow(
                color: Colors.black26,
                offset: Offset.fromDirection(20, 7),
                blurRadius: 5.0,
              )],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.4],
                colors: [
                  Colors.white70,
                  Colors.white
                ],
              ),
            ),
          child: Stack(
            children: [
              SizedBox(
                child: Opacity(
                  opacity: 0.2,
                  child: Image(
                    image: AssetImage(Assets.iciciGraphic),
                    fit: BoxFit.contain,
                  )
                ),
                height: 200,
                width: 500,
              ),
              Center(
               child: Text(
                 'Coming Soon!',
                 style: TextStyle(
                   fontSize: 36,
                   fontStyle: FontStyle.italic,
                   fontWeight: FontWeight.w800,
                   color: Colors.blueGrey[700]
                 ),
               )
              )
            ],
          ),
        )
    );
  }

  _buildButton() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child:Material(
          child: MaterialButton(
            color: Colors.blueAccent,
            child: Text('Get Tickets',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            minWidth: double.infinity,
            height: 50,
            onPressed: () {
              dbProvider.pushTicketRequest(baseProvider.myUser, 1);
            },
          ),
          borderRadius: new BorderRadius.circular(80.0),
        )
    );
  }
}

