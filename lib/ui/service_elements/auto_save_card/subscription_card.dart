import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AutosaveCard extends StatefulWidget {
  final ValueKey locationKey;
  AutosaveCard({required this.locationKey});

  @override
  State<AutosaveCard> createState() => _AutosaveCardState();
}

class _AutosaveCardState extends State<AutosaveCard> {
  bool isResumingInProgress = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // getTrailingWidget(SubscriptionService service) {
    //   switch (service.autosaveState) {
    //     case AutosaveState.INIT:
    //       return Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(
    //             "PROCESSING  ",
    //             style: TextStyles.sourceSansL.body3
    //                 .colour(UiConstants.primaryColor),
    //           ),
    //           Container(
    //             height: SizeConfig.padding14,
    //             width: SizeConfig.padding14,
    //             child: CircularProgressIndicator(
    //               strokeWidth: 1,
    //             ),
    //           ),
    //         ],
    //       );
    //     case AutosaveState.ACTIVE:
    //       return Container(
    //         padding: EdgeInsets.all(SizeConfig.padding10),
    //         decoration: BoxDecoration(border: Border.all(color: Colors.white)),
    //         child: Text(
    //           'UPDATE',
    //           style: TextStyles.sourceSansB.body3.colour(Colors.white),
    //         ),
    //       );
    //     case AutosaveState.IDLE:
    //       return Container(
    //         padding: EdgeInsets.all(SizeConfig.padding10),
    //         decoration: BoxDecoration(border: Border.all(color: Colors.white)),
    //         child: Text(
    //           'SETUP',
    //           style: TextStyles.sourceSansB.body3.colour(Colors.white),
    //         ),
    //       );
    //     case AutosaveState.PAUSED:
    //     case AutosaveState.PAUSED_FOREVER:
    //       return Container(
    //         padding: EdgeInsets.all(SizeConfig.padding10),
    //         decoration: BoxDecoration(
    //           border: Border.all(color: UiConstants.primaryColor),
    //         ),
    //         child: Text(
    //           'RESUME',
    //           style:
    //               TextStyles.sourceSansB.body3.colour(UiConstants.primaryColor),
    //         ),
    //       );
    //     default:
    //       return SizedBox();
    //   }
    // }

    return Consumer<SubService>(
      builder: (context, service, child) => service.autosaveVisible
          ? GestureDetector(
              onTap: () async {
                if (context.read<ConnectivityService>().connectivityStatus ==
                    ConnectivityStatus.Offline)
                  return BaseUtil.showNoInternetAlert();
                log((await service.getPhonePeVersionCode()).toString());
                await service.handleTap();
              },
              child: (service.subscriptionData != null)
                  ? ActiveOrPausedAutosaveCard(
                      service: service,
                    )
                  : InitAutosaveCard(
                      service: service,
                    ),
            )
          : SizedBox(),
      //  Container(
      //   child:

      //   Card(
      //     elevation: 2,
      //     color: Colors.black,
      //     margin: EdgeInsets.symmetric(
      //       horizontal: SizeConfig.padding16,
      //       vertical: SizeConfig.padding10,
      //     ),
      //     child: Column(
      //       children: [
      //         ListTile(
      //           contentPadding: EdgeInsets.only(
      //               left: SizeConfig.padding12,
      //               right: SizeConfig.padding12,
      //               top: SizeConfig.padding14),
      //           leading: SvgPicture.asset(
      //             Assets.autoSaveDefault,
      //             width: SizeConfig.padding40,
      //           ),
      //           title: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 "Amount: " + (service.subscriptionData?.amount ?? '0'),
      //                 style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
      //               ),
      //               Text(
      //                 "  ${service.autosaveState == AutosaveState.ACTIVE ? "[ACTIVE]" : ""}",
      //                 style: TextStyles.sourceSansB.body4
      //                     .colour(UiConstants.primaryColor),
      //               )
      //             ],
      //           ),
      //           subtitle: Text(
      //             "Frequency: ${service.subscriptionData?.frequency}",
      //             style: TextStyles.rajdhani.colour(UiConstants.kTextColor2),
      //           ),
      //           trailing: Container(
      //               margin: EdgeInsets.only(right: SizeConfig.padding12),
      //               child: getTrailingWidget(service)),
      //           onTap: service.handleTap,
      //         ),
      //         // if (service.autosaveState != AutosaveState.INIT)
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             TextButton(
      //                 onPressed: () {
      //                   // SubscriptionRepo
      //                   // locator<SubscriptionRepo>()
      //                   //     .getSubscriptionTransactionHistory(
      //                   //         offset: 1, limit: 30);
      //                   AppState.delegate!.appState.currentAction = PageAction(
      //                       page: TransactionsHistoryPageConfig,
      //                       state: PageState.addPage);
      //                 },
      //                 child: Text(
      //                   "Transaction History",
      //                   style: TextStyles.body3.colour(UiConstants.kTextColor2),
      //                 )),
      //             // TextButton(
      //             //     onPressed: () async {
      //             //       final res = await service.getPhonePeVersionCode();
      //             //       BaseUtil.showPositiveAlert(
      //             //           res.toString(), "is Phonepe Version code");
      //             //     },
      //             //     child: Text(
      //             //       "Phonepe Version",
      //             //       style: TextStyles.body3.colour(UiConstants.kTextColor2),
      //             //     )),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );

    // BaseView<SubscriptionCardViewModel>(
    //   onModelReady: (model) async => await model.init(),
    //   builder: (context, subscriptionModel, child) =>
    //       PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
    //     builder: (context, model, property) =>
    // model!.autosaveVisible
    //         ? GestureDetector(
    //             onTap: () async {
    //               if (connectivityStatus == ConnectivityStatus.Offline)
    //                 return BaseUtil.showNoInternetAlert();
    //               // if (!subscriptionModel.isUserProfileComplete())
    //               //   return BaseUtil.openDialog(
    //               //       addToScreenStack: true,
    //               //       isBarrierDismissible: true,
    //               //       hapticVibrate: false,
    //               //       content: CompleteProfileDialog(
    //               //         subtitle:
    //               //             'Please complete your profile to win your first reward and to start autosaving',
    //               //       ));
    //               if (isLoading) return;
    //               setState(() {
    //                 isLoading = true;
    //               });
    //               await subscriptionModel.getActiveButtonAction();
    //               setState(() {
    //                 isLoading = false;
    //               });
    //             },
    //             child: (model.activeSubscription != null &&
    //                     model.activeSubscription!.status ==
    //                         Constants.SUBSCRIPTION_ACTIVE)
    //                 ? (widget.locationKey.value == 'save'
    //                     ? SizedBox()
    //                     : ActiveOrPausedAutosaveCard(
    //                         isLoading: isLoading,
    //                         isResumingInProgress: isResumingInProgress,
    //                         subscriptionModel: subscriptionModel,
    //                       ))
    //                 : InitAutosaveCard(
    //                     onTap: () {
    //                       subscriptionModel.getActiveButtonAction();
    //                     },
    //                   ),
    //           )
    //         : SizedBox(),
    //   ),
    // );
  }
}

class InitAutosaveCard extends StatelessWidget {
  final SubService service;
  const InitAutosaveCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      color: UiConstants.kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleSubtitleContainer(
              title: 'Start Autosaving',
              subTitle:
                  'Save in Digital Gold automatically and win added rewards',
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.padding24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: UiConstants.kSecondaryBackgroundColor,
                    child: SvgPicture.asset(
                      Assets.autoSaveDefault,
                      width: 75,
                      height: 70,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: SizeConfig.screenWidth! * 0.5,
                        ),
                        child: Text(locale.saveAutoSaveTitle,
                            style: TextStyles.sourceSans.bold.body1),
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      Row(
                        children: [
                          Shimmer(
                              gradient: new LinearGradient(
                                colors: [
                                  UiConstants.kTextColor2,
                                  Colors.white,
                                  UiConstants.kTextColor2
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              child: Text(locale.btnStart.toUpperCase(),
                                  style: TextStyles.rajdhaniSB.body3)),
                          SizedBox(
                            height: SizeConfig.padding4,
                          ),
                          SvgPicture.asset(
                            Assets.chevRonRightArrow,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Divider(color: UiConstants.kTextColor2.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class ActiveOrPausedAutosaveCard extends StatelessWidget {
  final SubService service;

  const ActiveOrPausedAutosaveCard({Key? key, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24, vertical: SizeConfig.padding20),
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth! * 0.38,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding14),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          service.subscriptionData != null &&
                                  service.subscriptionData!.status ==
                                      Constants.SUBSCRIPTION_ACTIVE
                              ? Assets.autoSaveOngoing
                              : Assets.autoSavePaused,
                          height: SizeConfig.padding80,
                          width: SizeConfig.padding80,
                        ),
                        SizedBox(
                          width: SizeConfig.padding24,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                service.subscriptionData?.status
                                        ?.toUpperCase() ??
                                    "N/A",
                                style: TextStyles.sourceSansSB.body3
                                    .colour(UiConstants.primaryColor),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: SizeConfig.padding12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Investing',
                                        style: TextStyles.sourceSans.body4
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '₹ ',
                                          style: TextStyles.sourceSansSB.body0
                                              .colour(UiConstants.kTextColor),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${service.subscriptionData?.amount ?? 0} ",
                                              style: TextStyles
                                                  .sourceSansSB.body0
                                                  .colour(
                                                      UiConstants.kTextColor),
                                            ),
                                            TextSpan(
                                              text: service.subscriptionData
                                                      ?.frequency ??
                                                  "",
                                              style: TextStyles.sourceSans.body4
                                                  .colour(
                                                      UiConstants.kTextColor2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FittedBox(
                  //   fit: BoxFit.scaleDown,
                  //   child: isResumingInProgress || isLoading
                  //       ? Container(
                  //           height: SizeConfig.body2,
                  //           child: SpinKitThreeBounce(
                  //             color: Colors.white,
                  //             size: SizeConfig.padding12,
                  //           ),
                  //         )
                  //       : model.activeSubscription != null &&
                  //               model.activeSubscription.status ==
                  //                   Constants.SUBSCRIPTION_ACTIVE
                  //           ? SvgPicture.asset(
                  //               Assets.chevRonRightArrow,
                  //               width: SizeConfig.padding34,
                  //             )
                  //           : Row(
                  //               children: [
                  //                 Text(
                  //                   subscriptionModel.getActiveButtonText(
                  //                       model.activeSubscription),
                  //                   style: TextStyles.body2
                  //                       .colour(Colors.white),
                  //                 ),
                  //                 SizedBox(
                  //                   width: SizeConfig.padding6,
                  //                 ),
                  //                 SvgPicture.asset(
                  //                     Assets.chevRonRightArrow),
                  //               ],
                  //             ),
                  // ),
                ]),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(SizeConfig.padding12),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: SizeConfig.padding24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
