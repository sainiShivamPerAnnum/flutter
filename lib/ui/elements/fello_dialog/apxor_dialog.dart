import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class ApxorDialog extends StatelessWidget {
  Map<String, dynamic> dialogContent;
  ApxorDialog({required this.dialogContent, super.key});

  @override
  Widget build(BuildContext context) {
    bool assetView = (dialogContent["title"] ?? '').isEmpty &&
        (dialogContent["subtitle"] ?? '').isEmpty;
    return assetView
        ? Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            ),
            backgroundColor: Colors.black,
            child: GestureDetector(
              onTap: () {
                AppState.backButtonDispatcher!.didPopRoute();
                AppState.delegate!
                    .parseRoute(Uri.parse(dialogContent["ctaAction"]));
              },
              child: Container(
                  // margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  height: SizeConfig.screenWidth,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16)),
                  child: Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenWidth,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                          image: DecorationImage(
                            image: NetworkImage(dialogContent["asset"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -SizeConfig.padding12,
                        right: -SizeConfig.padding12,
                        child: Padding(
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () =>
                                  AppState.backButtonDispatcher!.didPopRoute(),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          )
        : FelloInfoDialog(
            nPng: dialogContent["asset"],
            title: dialogContent["title"],
            subtitle: dialogContent["subtitle"],
            action: AppPositiveBtn(
                btnText: dialogContent["ctaText"],
                onPressed: () {
                  AppState.backButtonDispatcher!.didPopRoute();
                  AppState.delegate!
                      .parseRoute(Uri.parse(dialogContent["ctaAction"]));
                }),
          );
  }
}
