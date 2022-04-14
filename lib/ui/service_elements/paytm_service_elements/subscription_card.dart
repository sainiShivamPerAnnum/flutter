import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class AutoSaveCard extends StatefulWidget {
  AutoSaveCard({Key key}) : super(key: key);

  @override
  State<AutoSaveCard> createState() => _AutoSaveCardState();
}

class _AutoSaveCardState extends State<AutoSaveCard> {
  final _paytmService = locator<PaytmService>();
  bool isResumingInProgress = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
      properties: [
        PaytmServiceProperties.ActiveSubscription,
        PaytmServiceProperties.AutosaveVisibility,
        PaytmServiceProperties.NextDebitString,
      ],
      builder: (context, model, property) => model.autosaveVisible
          ? InkWell(
              onTap: () async {
                if (isLoading) return;
                setState(() {
                  isLoading = true;
                });
                // if (model.isFirstTime) {
                //   CacheManager.writeCache(
                //       key: CacheManager.CACHE_IS_SUBSCRIPTION_FIRST_TIME,
                //       value: false,
                //       type: CacheType.bool);
                //   model.isFirstTime = false;
                //   AppState.delegate.appState.currentAction = PageAction(
                //       page: AutoSaveDetailsViewPageConfig,
                //       state: PageState.addPage);
                // } else
                await getActiveButtonAction();
                setState(() {
                  isLoading = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.decelerate,
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  // color: Color(0xfff3c5c5),
                  // color: UiConstants.autosaveColor,
                  gradient: getGradient(model.activeSubscription),
                  image: DecorationImage(
                      image: AssetImage(Assets.whiteRays),
                      fit: BoxFit.cover,
                      opacity: 0.06),
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: SizeConfig.padding16,
                      child: Image.asset(
                        getImage(model.activeSubscription),
                        width: SizeConfig.screenWidth / 2.8,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: SizeConfig.pageHorizontalMargins * 1.6),
                          Container(
                            width: SizeConfig.screenWidth * 0.5,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  // fit: BoxFit.scaleDown,
                                  child: FittedBox(
                                    child: Text(
                                      getActiveTitle(model.activeSubscription),
                                      style: TextStyles.body2.light
                                          .colour(Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.padding6),
                                getIcon(model.activeSubscription)
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding2),
                          Text(
                            getactiveSubtitle(model.activeSubscription),
                            style: TextStyles.title5.bold.colour(Colors.white),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          Row(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  height: SizeConfig.padding40,
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding8,
                                      horizontal: SizeConfig.padding16),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(100),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: getShadow(model.activeSubscription)
                                    //         .withOpacity(0.2),
                                    //     offset: Offset(0, 2),
                                    //     blurRadius: 5,
                                    //     spreadRadius: 5,
                                    //   )
                                    // ],
                                  ),
                                  child: isResumingInProgress || isLoading
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
                              SizedBox(width: SizeConfig.padding8),
                              Expanded(
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          if (model.activeSubscription != null)
                            AnimatedContainer(
                              duration: Duration(seconds: 2),
                              curve: Curves.easeOutBack,
                              height: model.activeSubscription.status ==
                                      Constants.SUBSCRIPTION_ACTIVE
                                  ? SizeConfig.padding12
                                  : 0,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                model.activeSubscription.status ==
                                        Constants.SUBSCRIPTION_ACTIVE
                                    ? model.nextDebitString
                                    : "",
                                style: TextStyles.body5.colour(Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          SizedBox(
                              height: SizeConfig.pageHorizontalMargins * 1.6),
                        ],
                      ),
                    ),
                    if (!model.isFirstTime)
                      Positioned(
                        right: SizeConfig.padding4,
                        top: SizeConfig.padding4,
                        child: IconButton(
                          onPressed: () {
                            AppState.delegate.appState.currentAction =
                                PageAction(
                                    page: AutoSaveDetailsViewPageConfig,
                                    state: PageState.addPage);
                          },
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: SizeConfig.padding20,
                            color: Colors.white70,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }

  getGradient(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return new LinearGradient(
        colors: [UiConstants.autosaveColor, UiConstants.autosaveColor],
      );
    } else if (subscription.status == Constants.SUBSCRIPTION_INACTIVE &&
        subscription.autoAmount != 0.0 &&
        subscription.resumeDate.isNotEmpty) {
      return new LinearGradient(
          colors: [Color(0xffFD746C), Color(0xffFF9068)],
          begin: Alignment.topLeft,
          end: Alignment.centerRight);
    } else if (subscription.status == Constants.SUBSCRIPTION_INACTIVE &&
        subscription.autoAmount != 0.0 &&
        subscription.resumeDate.isEmpty) {
      return new LinearGradient(
        colors: [Color(0xffEACDA3), Color(0xffD6AE7B)],
      );
    }
    return new LinearGradient(
      colors: [UiConstants.autosaveColor, UiConstants.autosaveColor],
    );
  }

  String getActiveTitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Savings on autopilot with";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "Your Fello Autosave is currently";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "Your Autosave is Active";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Your Autosave setup is complete";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Savings on autopilot with";
          else
            return "Your Autosave is Paused till";
        }
      }
      return "Autosave";
    }
  }

  String getactiveSubtitle(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return "Fello Autosave";
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return "in Progress";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "₹${subscription.autoAmount.toInt()}${getFreq(subscription.autoFrequency)}";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Start saving now";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Fello Autosave";
          else
            return "${getResumeDate()}";
        }
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
      return "View";
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return "View";
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return "Set amount";
        else {
          if (subscription.resumeDate.isEmpty)
            return "Restart";
          else
            return "Resume";
        }
      }
      return "Details";
    }
  }

  getIcon(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return SizedBox();
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return Icon(
        Icons.run_circle,
        color: UiConstants.tertiarySolid,
        size: SizeConfig.iconSize1,
      );
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return Icon(
          Icons.verified_rounded,
          color: UiConstants.primaryColor,
          size: SizeConfig.iconSize1,
        );
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return Icon(
            Icons.verified_rounded,
            color: UiConstants.primaryColor,
            size: SizeConfig.iconSize1,
          );
        else {
          if (subscription.resumeDate.isEmpty)
            return SizedBox();
          else
            return SizedBox();
        }
      }
      return "Details";
    }
  }

  getActiveButtonAction() async {
    Haptic.vibrate();
    await _paytmService.getActiveSubscriptionDetails();
    if (_paytmService.activeSubscription == null ||
        (_paytmService.activeSubscription.status ==
                Constants.SUBSCRIPTION_INIT ||
            _paytmService.activeSubscription.status ==
                Constants.SUBSCRIPTION_CANCELLED)) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutoSaveDetailsViewPageConfig, state: PageState.addPage);
      // _paytmService.initiateSubscription();
    } else if (_paytmService.activeSubscription.status ==
        Constants.SUBSCRIPTION_PROCESSING) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutoSaveProcessViewPageConfig,
          widget: AutoSaveProcessView(page: 1),
          state: PageState.addWidget);
    } else {
      if (_paytmService.activeSubscription.status ==
          Constants.SUBSCRIPTION_ACTIVE) {
        AppState.delegate.appState.currentAction = PageAction(
            page: UserAutoSaveDetailsViewPageConfig, state: PageState.addPage);
      }
      if (_paytmService.activeSubscription.status ==
          Constants.SUBSCRIPTION_INACTIVE) {
        if (_paytmService.activeSubscription.autoAmount == 0.0) {
          AppState.delegate.appState.currentAction = PageAction(
              page: AutoSaveProcessViewPageConfig,
              widget: AutoSaveProcessView(page: 2),
              state: PageState.addWidget);
        } else {
          setState(() {
            isResumingInProgress = true;
          });
          bool response = await _paytmService.resumeSubscription();
          setState(() {
            isResumingInProgress = false;
          });
          if (!response) {
            BaseUtil.showNegativeAlert(
                "Unable to resume at the moment", "Please try again");
          } else {
            BaseUtil.showPositiveAlert("Autosave resumed successfully",
                "For more details check Autosave section");
          }
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

  String getResumeDate() {
    if (_paytmService.activeSubscription.resumeDate != null) {
      List<String> dateSplitList =
          _paytmService.activeSubscription.resumeDate.split('-');
      int day = int.tryParse(dateSplitList[0]);
      int month = int.tryParse(dateSplitList[1]);
      int year = int.tryParse(dateSplitList[2]);
      final resumeDate = DateTime(year, month, day);
      return DateFormat("dd MMM yyyy").format(resumeDate);
    } else {
      return "Forever";
    }
  }

  getImage(ActiveSubscriptionModel subscription) {
    if (subscription == null ||
        (subscription.status == Constants.SUBSCRIPTION_INIT ||
            subscription.status == Constants.SUBSCRIPTION_CANCELLED)) {
      return Assets.preautosave;
    }
    if (subscription.status == Constants.SUBSCRIPTION_PROCESSING) {
      return Assets.preautosave;
    } else {
      if (subscription.status == Constants.SUBSCRIPTION_ACTIVE) {
        return Assets.postautosave;
      }
      if (subscription.status == Constants.SUBSCRIPTION_INACTIVE) {
        if (subscription.autoAmount == 0.0)
          return Assets.preautosave;
        else {
          if (subscription.resumeDate.isEmpty)
            return Assets.autopause;
          else
            return Assets.autopause;
        }
      }
      return Assets.preautosave;
    }
  }

  getFreq(String freq) {
    if (freq == "DAILY") return "/day";
    if (freq == "WEEKLY") return "/week";
    return "";
  }
}
