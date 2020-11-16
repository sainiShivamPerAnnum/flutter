
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class ReferScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ReferScreenState();

}

class _ReferScreenState extends State<ReferScreen> {
  Log log = new Log('ReferScreen');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      //padding: EdgeInsets.only(top: 48.0),
        body: Stack(
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
                  //Navigator.of(context).pushNamed(Settings.id);
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
                        '2',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),

                      ),
                      Text(
                        'referrals',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                )
            ),
            SafeArea(child: Padding(
                padding: EdgeInsets.only(top: 180),
                child: _buildReferCanvas(context))
            ),
          ],
        )
      //),
    );
  }

  Widget _buildReferCanvas(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width-50,
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
                ),
                child: new Material(
                  child: MaterialButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SHARE ON WHATSAPP',
                          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage(Assets.whatsappIcon),
                            fit: BoxFit.contain,
                          ),
                          width: 15,
                        )
                      ],
                    ),
                    onPressed: () async{
                      var res = await FlutterShareMe().shareToWhatsApp(msg: 'fellop');
                      log.debug(res);
                    },
                    highlightColor: Colors.orange.withOpacity(0.5),
                    splashColor: Colors.orange.withOpacity(0.5),
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width-50,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.blueGrey,
                        Colors.blueGrey[600],
                      ],
                      begin: Alignment(0.5, -1.0),
                      end: Alignment(0.5, 1.0)
                  ),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Material(
                  child: MaterialButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SHARE',
                          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                    onPressed: () async{
                      var res = await FlutterShareMe().shareToSystem(msg: 'fellop');
                      log.debug(res);
                    },
                    highlightColor: Colors.orange.withOpacity(0.5),
                    splashColor: Colors.orange.withOpacity(0.5),
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child:Image(
                image: AssetImage(Assets.referGraphic),
                fit: BoxFit.contain,
              ),
            )
        )
      ],
    );
  }

}