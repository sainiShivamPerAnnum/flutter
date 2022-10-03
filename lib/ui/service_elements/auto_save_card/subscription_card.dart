import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
      onModelReady: (model) async => await model.init(),
      builder: (context, subscriptionModel, child) =>
          PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
        builder: (context, model, property) => model.autosaveVisible
            ? GestureDetector(
                onTap: () async {
                  if (connectivityStatus == ConnectivityStatus.Offline)
                    return BaseUtil.showNoInternetAlert();
                  if (!subscriptionModel.isUserProfileComplete())
                    return BaseUtil.showNegativeAlert("Autosave Locked",
                        "Please complete profile to unlock autosave");
                  if (isLoading) return;
                  setState(() {
                    isLoading = true;
                  });
                  await subscriptionModel.getActiveButtonAction();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: (model.activeSubscription != null &&
                        model.activeSubscription.status ==
                            Constants.SUBSCRIPTION_ACTIVE)
                    ? ActiveOrPausedAutosaveCard(
                        isLoading: isLoading,
                        isResumingInProgress: isResumingInProgress,
                        subscriptionModel: subscriptionModel,
                      )
                    : InitAutosaveCard(
                        onTap: () {
                          subscriptionModel.getActiveButtonAction();
                        },
                      ),
              )
            : SizedBox(),
      ),
    );
  }
}

class InitAutosaveCard extends StatelessWidget {
  final Function() onTap;

  const InitAutosaveCard({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                title: 'Start a New SIP',
                subTitle:
                    'Invest safely in Gold with our Auto SIP to win tokens',
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
                            maxWidth: SizeConfig.screenWidth * 0.5,
                          ),
                          child: Text('Invest in Fello Autosave today',
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
                                child: Text('START',
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
      ),
    );
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
                  vertical: SizeConfig.padding20),
              child: Container(
                height: SizeConfig.screenWidth * 0.38,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.roundness12)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding10),
                        child: Row(
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
                                    subscriptionModel.getActiveTitle(
                                        model.activeSubscription),
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
                                                            SizeConfig
                                                                .padding44),
                                                    color: UiConstants
                                                        .kBackgroundColor),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    Assets.upiIcon,
                                                    height:
                                                        SizeConfig.padding14,
                                                    width: SizeConfig.padding14,
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
                                          ),
                                        )
                                      : SizedBox(),
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
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                          Text(
                                            '${model.activeSubscription?.autoAmount ?? 0} ${subscriptionModel.getFreq(model.activeSubscription?.autoFrequency ?? "")}',
                                            style: TextStyles.sourceSansSB.body0
                                                .colour(UiConstants.kTextColor),
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
            ));
  }
}
