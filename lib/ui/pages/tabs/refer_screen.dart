
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReferScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ReferScreenState();

}

class _ReferScreenState extends State<ReferScreen> {
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
                padding: EdgeInsets.only(top: 140),
                child: _buildReferCanvas(context))
            )

          ],
        )
      //),
    );
  }

  Widget _buildReferCanvas(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child:Image(
        image: AssetImage(Assets.referGraphic),
        fit: BoxFit.contain,
      ),
      )
    );
  }

}