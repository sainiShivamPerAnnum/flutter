import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class AutoPayCard extends StatelessWidget {
  const AutoPayCard({Key key}) : super(key: key);

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
              padding: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
              child: Stack(
                children: [
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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: SizeConfig.pageHorizontalMargins * 2),
                            FittedBox(
                              child: Text(
                                model.activeSubscription != null
                                    ? "Your Subscription is Active for"
                                    : "Savings made easy with",
                                style:
                                    TextStyles.body2.light.colour(Colors.white),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding2),
                            Text(
                              model.activeSubscription != null
                                  ? "${model.activeSubscription.autoAmount}/day"
                                  : "UPI AutoPay",
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
                                      AppState.delegate.appState.currentAction =
                                          PageAction(
                                              page: model.activeSubscription !=
                                                      null
                                                  ? UserAutoPayDetailsViewPageConfig
                                                  : AutoPayProcessViewPageConfig,
                                              state: PageState.addPage);
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
                                            color: UiConstants.primaryColor
                                                .withOpacity(0.2),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        model.activeSubscription != null
                                            ? (model.activeSubscription
                                                        .status ==
                                                    "ACTIVE"
                                                ? "Details"
                                                : "Check")
                                            : "Set Up",
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
}
