import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class KYCInvalid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseUtil.getAppBar(),
      bottomSheet: Container(
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
            child: Text('CONTINUE',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/verifykyc');
            },
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
          ),
          color: Colors.transparent,
          borderRadius: new BorderRadius.circular(20.0),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
          width: _width,
          height: _height,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.kycUnavailableAsset,
                    fit: BoxFit.contain,
                    height: _height/2.5,
                    width: _width,
                  ),
                  SizedBox(
                    height:20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your KYC verification is required",
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height:5,
                        ),
                        Text(
                          "Let\'s register your KYC, it\'s quite easy!",
                          style: TextStyle(
                            fontSize: 22,
                            color: UiConstants.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Wrap(
                          spacing: 20,
                          children: [
                            Chip(
                              label: Text("What is KYC?"),
                              backgroundColor: UiConstants.chipColor,
                            ),
                            Chip(
                              label: Text("Why do I need to do it?"),
                              backgroundColor: UiConstants.chipColor,
                            ),
                            Chip(
                              label: Text("I\'m not very sure yet"),
                              backgroundColor: UiConstants.chipColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              // Positioned(
              //     bottom: _height * 0.02,
              //     child:
              // )
            ],
          )
      )
    );
  }
}
