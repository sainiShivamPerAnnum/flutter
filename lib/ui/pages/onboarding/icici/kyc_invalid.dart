import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KYCInvalid extends StatelessWidget {
  BaseUtil baseProvider;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: BaseUtil.getAppBar(context, null),
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
              child: Text(
                'UNAVAILABLE',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              onPressed: () async {
                Haptic.vibrate();
                baseProvider.showNegativeAlert(
                    'Unavailable',
                    'The in-house KYC verification engine will be made available soon',
                    context);
                // Navigator.of(context).pop();
                // Navigator.of(context).pushNamed('/verifykyc');
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
                      height: _height / 2.5,
                      width: _width,
                    ),
                    SizedBox(
                      height: 20,
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
                            height: 5,
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
                              ActionChip(
                                label: Text("What is KYC?"),
                                backgroundColor: UiConstants.chipColor,
                                onPressed: () {
                                  Haptic.vibrate();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MoreInfoDialog(
                                            text: Assets.infoWhatKYC,
                                            title: 'What is KYC?',
                                          ));
                                },
                              ),
                              ActionChip(
                                label: Text("Why is it required?"),
                                backgroundColor: UiConstants.chipColor,
                                onPressed: () {
                                  Haptic.vibrate();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MoreInfoDialog(
                                            text: Assets.infoWhyKYC,
                                            title: 'Why is it required?',
                                          ));
                                },
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
            )));
  }
}
