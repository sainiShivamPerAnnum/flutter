import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/autosave_services.dart';
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
                      child: Container(
                        height: SizeConfig.screenWidth * 0.34,
                        width: SizeConfig.screenWidth,
                        color: UiConstants.kBackgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding24,
                              vertical: SizeConfig.padding10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          model.activeSubscription != null &&
                                                  model.activeSubscription
                                                          .status ==
                                                      Constants
                                                          .SUBSCRIPTION_ACTIVE
                                              ? Assets.autoSaveOngoing
                                              : model.activeSubscription !=
                                                          null &&
                                                      model.activeSubscription
                                                              .status ==
                                                          Constants
                                                              .SUBSCRIPTION_INACTIVE
                                                  ? Assets.autoSavePaused
                                                  : Assets.autoSaveDefault,
                                          height: SizeConfig.padding80,
                                          width: SizeConfig.padding80,
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding10,
                                        ),
                                        Container(
                                          width: SizeConfig.screenWidth * 0.4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    subscriptionModel
                                                        .getActiveTitle(model
                                                            .activeSubscription),
                                                    style: TextStyles
                                                        .rajdhaniSB.body1
                                                        .colour(UiConstants
                                                            .kTextColor),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  model.activeSubscription !=
                                                              null &&
                                                          model.activeSubscription
                                                                  .status ==
                                                              Constants
                                                                  .SUBSCRIPTION_ACTIVE
                                                      ? Text(
                                                          subscriptionModel
                                                              .getActivityStatus(
                                                                  model
                                                                      .activeSubscription),
                                                          style: TextStyles
                                                              .rajdhani.body3
                                                              .colour(UiConstants
                                                                  .kTextColor),
                                                          textAlign:
                                                              TextAlign.left,
                                                        )
                                                      : model.activeSubscription !=
                                                                  null &&
                                                              model.activeSubscription
                                                                      .status ==
                                                                  Constants
                                                                      .SUBSCRIPTION_INACTIVE
                                                          ? Text(
                                                              subscriptionModel
                                                                  .getActivityStatus(
                                                                      model
                                                                          .activeSubscription),
                                                              style: TextStyles
                                                                  .rajdhani
                                                                  .body4
                                                                  .colour(UiConstants
                                                                      .kTextColor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )
                                                          : SizedBox(),
                                                ],
                                              ),
                                              model.activeSubscription !=
                                                          null &&
                                                      model.activeSubscription
                                                              .status ==
                                                          Constants
                                                              .SUBSCRIPTION_ACTIVE
                                                  ? Container()
                                                  : Text(
                                                      subscriptionModel
                                                          .getactiveSubtitle(model
                                                              .activeSubscription),
                                                      style:
                                                          TextStyles.sourceSans,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    model.activeSubscription != null &&
                                            model.activeSubscription.status ==
                                                Constants.SUBSCRIPTION_ACTIVE
                                        ? Row(
                                            children: [
                                              Container(
                                                height: SizeConfig.padding26,
                                                width: SizeConfig.padding26,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig
                                                                .padding44),
                                                    color: UiConstants
                                                        .kSecondaryBackgroundColor),
                                                child: Center(
                                                  child: Image.asset(
                                                    Assets.upiSvg,
                                                    height: SizeConfig.padding4,
                                                    width: SizeConfig.padding4,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: SizeConfig.padding6,
                                              ),
                                              Text(
                                                model.activeSubscription.vpa,
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(UiConstants
                                                        .kTextColor2),
                                              ),
                                            ],
                                          )
                                        : model.activeSubscription != null &&
                                                model.activeSubscription
                                                        .status ==
                                                    Constants
                                                        .SUBSCRIPTION_INACTIVE
                                            ? Row(
                                                children: [
                                                  Container(
                                                    height:
                                                        SizeConfig.padding26,
                                                    width: SizeConfig.padding26,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                SizeConfig
                                                                    .padding44),
                                                        color: UiConstants
                                                            .kSecondaryBackgroundColor),
                                                    child: Center(
                                                      child: Image.asset(
                                                        Assets.upiSvg,
                                                        height: SizeConfig
                                                            .padding12,
                                                        width: SizeConfig
                                                            .padding12,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.padding6,
                                                  ),
                                                  Text(
                                                    model
                                                        .activeSubscription.vpa,
                                                    style: TextStyles
                                                        .sourceSans.body4
                                                        .colour(UiConstants
                                                            .kTextColor2),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                  ],
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: isResumingInProgress || isLoading
                                            ? Container(
                                                height: SizeConfig.body2,
                                                child: SpinKitThreeBounce(
                                                  color: Colors.white,
                                                  size: SizeConfig.padding12,
                                                ),
                                              )
                                            : model.activeSubscription !=
                                                        null &&
                                                    model.activeSubscription
                                                            .status ==
                                                        Constants
                                                            .SUBSCRIPTION_ACTIVE
                                                ? SvgPicture.asset(
                                                    Assets.chevRonRightArrow,
                                                    width: SizeConfig.padding34,
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        subscriptionModel
                                                            .getActiveButtonText(
                                                                model
                                                                    .activeSubscription),
                                                        style: TextStyles.body2
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            SizeConfig.padding6,
                                                      ),
                                                      SvgPicture.asset(Assets
                                                          .chevRonRightArrow),
                                                    ],
                                                  ),
                                      ),
                                      Spacer(),
                                      model.activeSubscription != null &&
                                              model.activeSubscription.status ==
                                                  Constants.SUBSCRIPTION_ACTIVE
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Invested',
                                                  style: TextStyles
                                                      .sourceSans.body3
                                                      .colour(UiConstants
                                                          .kTextColor2),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                                        style: TextStyles
                                                            .sourceSans.body1),
                                                    Text(
                                                      subscriptionModel.getFreq(
                                                          model
                                                              .activeSubscription
                                                              .autoFrequency),
                                                      style: TextStyles
                                                          .sourceSans.body1,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : model.activeSubscription != null &&
                                                  model.activeSubscription
                                                          .status ==
                                                      Constants
                                                          .SUBSCRIPTION_INACTIVE
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Invested',
                                                      style: TextStyles
                                                          .sourceSans.body3
                                                          .colour(UiConstants
                                                              .kTextColor2),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                            "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                                            style: TextStyles
                                                                .sourceSans
                                                                .body1),
                                                        Text(
                                                          subscriptionModel
                                                              .getFreq(model
                                                                  .activeSubscription
                                                                  .autoFrequency),
                                                          style: TextStyles
                                                              .sourceSans.body1,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : SizedBox()
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )
                  : SizedBox(),
            ));
  }
}
