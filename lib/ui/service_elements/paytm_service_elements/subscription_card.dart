import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class AutoPayCard extends StatefulWidget {
  AutoPayCard({Key key}) : super(key: key);

  @override
  State<AutoPayCard> createState() => _AutoPayCardState();
}

class _AutoPayCardState extends State<AutoPayCard> {
  final _paytmService = locator<PaytmService>();
  bool isResumingInProgress = false;
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
        properties: [PaytmServiceProperties.ActiveSubscription],
        builder: (context, model, property) => Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                // color: Color(0xfff3c5c5),
                color: UiConstants.autopayColor,

                //color: Colors.white,
                borderRadius: BorderRadius.circular(SizeConfig.roundness24),
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.06,
                    child: Image.asset(
                      Assets.whiteRays,
                      fit: BoxFit.cover,
                      width: SizeConfig.screenWidth -
                          SizeConfig.pageHorizontalMargins * 2,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: SizeConfig.padding16,
                    child: Image.asset(
                      "assets/images/autopay.png",
                      width: SizeConfig.screenWidth / 2.4,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: SizeConfig.pageHorizontalMargins),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: SizeConfig.pageHorizontalMargins * 2),
                            FittedBox(
                              child: Text(
                                getActiveTitle(model.activeSubscription),
                                style:
                                    TextStyles.body2.light.colour(Colors.white),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding2),
                            Text(
                              getactiveSubtitle(model.activeSubscription),
                              style:
                                  TextStyles.title3.bold.colour(Colors.white),
                            ),
                            SizedBox(height: SizeConfig.padding16),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // BaseUtil.openModalBottomSheet(
                                      //   addToScreenStack: true,
                                      //   backgroundColor: Colors.white,
                                      //   borderRadius: BorderRadius.only(
                                      //     topLeft:
                                      //         Radius.circular(SizeConfig.roundness32),
                                      //     topRight:
                                      //         Radius.circular(SizeConfig.roundness32),
                                      //   ),
                                      //   content: CustomSubscriptionModal(),
                                      //   hapticVibrate: true,
                                      //   isBarrierDismissable: false,
                                      //   isScrollControlled: true,
                                      // );
                                      // AppState.delegate.appState.currentAction =
                                      //     PageAction(
                                      //         page: model.activeSubscription !=
                                      //                 null
                                      //             ? UserAutoPayDetailsViewPageConfig
                                      //             : AutoPayProcessViewPageConfig,
                                      //         state: PageState.addPage);
                                      getActiveButtonAction(
                                          model.activeSubscription);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.padding8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xff8f97b3),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: getShadow(
                                                    model.activeSubscription)
                                                .withOpacity(0.2),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: isResumingInProgress
                                          ? Container(
                                              height: SizeConfig.body2,
                                              child: SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: SizeConfig.padding12,
                                              ),
                                            )
                                          : Text(
                                              getActiveButtonText(
                                                  model.activeSubscription),
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.padding8),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      AppState.delegate.appState.currentAction =
                                          PageAction(
                                              state: PageState.addPage,
                                              page:
                                                  AutoPayDetailsViewPageConfig);
                                    },
                                    child: model.activeSubscription != null
                                        ? SizedBox()
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: SizeConfig.padding8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                width: 0.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Text(
                                              "Details",
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: SizeConfig.pageHorizontalMargins * 2)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      )
                    ],
                  ),
                ],
              ),
            ));
  }

  String getActiveTitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Savings made easy for you with";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "Your UPI Autopay";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "Your Subscription is Active for";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        return "Your Subscription is Paused for";
      }
      return "Your Subscription";
    }
  }

  String getactiveSubtitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "UPI Autopay";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "is in process";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "${subscription.autoAmount}/day";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        return "${subscription.autoAmount}/day";
      }
      return "0.0/day";
    }
  }

  String getActiveButtonText(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Set up";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "Check";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "More..";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        return "Resume";
      }
      return "Details";
    }
  }

  getActiveButtonAction(ActiveSubscriptionModel subscription) async {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutoPayProcessViewPageConfig, state: PageState.addPage);
      // _paytmService.initiateSubscription();
    } else if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutoPayProcessViewPageConfig, state: PageState.addPage);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _paytmService.jumpToSubPage(1);
      });
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        {
          AppState.delegate.appState.currentAction = PageAction(
              page: UserAutoPayDetailsViewPageConfig, state: PageState.addPage);
        }
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0) {
          AppState.delegate.appState.currentAction = PageAction(
              page: AutoPayProcessViewPageConfig, state: PageState.addPage);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _paytmService.jumpToSubPage(2);
          });
        } else {
          setState(() {
            isResumingInProgress = true;
          });
          bool response = await _paytmService.resumeSubscription();
          if (response) {
            BaseUtil.showPositiveAlert("Subscription resumed",
                "Now you are back to your savings journey");
          } else
            BaseUtil.showNegativeAlert(
                "Failed to resume Subscription", "Please try again");
          setState(() {
            isResumingInProgress = false;
          });
        }
      }
    }
  }

  Color getShadow(ActiveSubscriptionModel subscription) {
    if (subscription == null) {
      return UiConstants.primaryColor;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return UiConstants.primaryColor;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        return Colors.amber;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INIT ||
          subscription.status == Constants.SUBSCRIPTION_CANCELLED) {
        return UiConstants.primaryColor;
      }
      if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
        return Colors.blue;
      }
      return UiConstants.scaffoldColor;
    }
  }
}
