import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class AutosaveCard extends StatefulWidget {
  AutosaveCard({Key key}) : super(key: key);

  @override
  State<AutosaveCard> createState() => _AutosaveCardState();
}

class _AutosaveCardState extends State<AutosaveCard> {
  bool isResumingInProgress = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<SubscriptionCardViewModel>(
        builder: (context, subscriptionModel, child) =>
            PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
              builder: (context, model, property) => model.autosaveVisible
                  ? InkWell(
                      onTap: () async {
                        if (connectivityStatus == ConnectivityStatus.Offline)
                          return BaseUtil.showNoInternetAlert();
                        if (isLoading) return;
                        setState(() {
                          isLoading = true;
                        });
                        await subscriptionModel.getActiveButtonAction();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: model.activeSubscription != null &&
                              model.activeSubscription.status ==
                                  Constants.SUBSCRIPTION_ACTIVE
                          ? InitAutosaveCard()
                          : ActiveOrPausedAutosaveCard(
                              isLoading: isLoading,
                              isResumingInProgress: isResumingInProgress,
                              subscriptionModel: subscriptionModel,
                            ))
                  : SizedBox(),
            ));
  }
}

class InitAutosaveCard extends StatelessWidget {
  const InitAutosaveCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ActiveOrPausedAutosaveCard extends StatelessWidget {
  final SubscriptionCardViewModel subscriptionModel;
  final bool isLoading;
  final bool isResumingInProgress;

  const ActiveOrPausedAutosaveCard(
      {Key key,
      this.subscriptionModel,
      this.isLoading = false,
      this.isResumingInProgress = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
        builder: (context, model, property) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding24,
                  vertical: SizeConfig.padding10),
              child: Container(
                height: SizeConfig.screenWidth * 0.34,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.roundness12)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            model.activeSubscription != null &&
                                    model.activeSubscription.status ==
                                        Constants.SUBSCRIPTION_ACTIVE
                                ? Assets.autoSaveOngoing
                                : Assets.autoSavePaused,
                            height: SizeConfig.padding80,
                            width: SizeConfig.padding80,
                          ),
                          SizedBox(
                            width: SizeConfig.padding10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  subscriptionModel
                                      .getActiveTitle(model.activeSubscription),
                                  style: TextStyles.rajdhaniM.body3
                                      .colour(UiConstants.kTextColor),
                                  textAlign: TextAlign.left,
                                ),
                                model.activeSubscription != null
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: SizeConfig.padding4),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: SizeConfig.padding20,
                                              width: SizeConfig.padding20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          SizeConfig.padding44),
                                                  color: UiConstants
                                                      .kBackgroundColor),
                                              child: Center(
                                                child: Image.asset(
                                                  Assets.upiSvg,
                                                  height: SizeConfig.padding14,
                                                  width: SizeConfig.padding14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding6,
                                            ),
                                            Text(
                                              model.activeSubscription.vpa,
                                              style: TextStyles.sourceSans.body4
                                                  .colour(
                                                      UiConstants.kTextColor2),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                model.activeSubscription != null &&
                                        model.activeSubscription.status ==
                                            Constants.SUBSCRIPTION_ACTIVE
                                    ? Text(
                                        subscriptionModel.getActivityStatus(
                                            model.activeSubscription),
                                        style: TextStyles.rajdhani.body3
                                            .colour(UiConstants.kTextColor),
                                        textAlign: TextAlign.left,
                                      )
                                    : SizedBox(),
                                // model.activeSubscription != null &&
                                //         model.activeSubscription.status ==
                                //             Constants.SUBSCRIPTION_ACTIVE
                                //     ? Container()
                                //     : Text(
                                //         subscriptionModel.getactiveSubtitle(
                                //             model.activeSubscription),
                                //         style: TextStyles.sourceSans.body4,
                                //       ),
                                Spacer(),
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
                                        Text(
                                          '${model.activeSubscription.autoAmount} ${subscriptionModel.getFreq(model.activeSubscription.autoFrequency)}',
                                          style: TextStyles.sourceSansSB.body0
                                              .colour(UiConstants.kTextColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: SizeConfig.padding24,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invested',
                                          style: TextStyles.sourceSans.body4
                                              .colour(UiConstants.kTextColor2),
                                        ),
                                        Text(
                                          '\u20b9 ${model.activeSubscription.maxAmount}',
                                          style: TextStyles.sourceSansSB.body0
                                              .colour(UiConstants.kTextColor),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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
                      model.activeSubscription != null &&
                              model.activeSubscription.status ==
                                  Constants.SUBSCRIPTION_ACTIVE
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Invested',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                        style: TextStyles.sourceSans.body1),
                                    Text(
                                      subscriptionModel.getFreq(model
                                          .activeSubscription.autoFrequency),
                                      style: TextStyles.sourceSans.body1,
                                    )
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                    ]),
              ),
            ));
  }
}
