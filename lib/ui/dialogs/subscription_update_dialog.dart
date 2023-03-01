import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/pages/finance/autopay/segmate_chip.dart';
import 'package:felloapp/ui/pages/finance/autopay/user_autopay_details/user_autopay_details_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class EditSubscriptionDialog extends StatelessWidget {
  const EditSubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionService>(
      builder: (context, service, child) => FelloInfoDialog(
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit Autosave",
              style: TextStyles.rajdhaniB.title2.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding16),
            Container(
              width: SizeConfig.screenWidth! * 0.784,
              decoration: BoxDecoration(
                color: UiConstants.kTextFieldColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                border: Border.all(
                  color: UiConstants.kTextColor.withOpacity(0.1),
                  width: SizeConfig.border1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹",
                          style: TextStyles.rajdhaniB
                              .size(SizeConfig.screenWidth! * 0.1067),
                        ),
                        SizedBox(
                          width: ((SizeConfig.screenWidth! * 0.065) *
                              service.amountController.text.length.toDouble()),
                          child: AppTextField(
                            textEditingController: service.amountController,
                            isEnabled: true,
                            autoFocus: true,
                            validator: (val) {
                              return null;
                            },
                            onChanged: (val) {
                              service.onAmountValueChanged(val);
                            },
                            keyboardType: TextInputType.number,
                            inputDecoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              // isCollapse: true,
                              isDense: true,
                            ),
                            textAlign: TextAlign.center,
                            textStyle: TextStyles.rajdhaniB
                                .size(SizeConfig.screenWidth! * 0.1067),
                            // height: SizeConfig.screenWidth * 0.1706,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.screenWidth! * 0.0666,
                    right: SizeConfig.screenWidth! * 0.0666,
                    child: Text(
                      service.isDaily ? "DAILY" : "WEEKLY",
                      style: TextStyles.sourceSans.body4.setOpecity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                color: UiConstants.kAutopayAmountDeactiveTabColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                border: Border.all(
                  color: UiConstants.kBorderColor.withOpacity(0.22),
                  width: SizeConfig.border1,
                ),
              ),
              width: SizeConfig.screenWidth! * 0.5133,
              height: SizeConfig.screenWidth! * 0.0987,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    left: service.isDaily ? 0 : SizeConfig.screenWidth! * 0.248,
                    child: AnimatedContainer(
                      width: SizeConfig.screenWidth! * 0.26,
                      height: SizeConfig.screenWidth! * 0.094,
                      decoration: BoxDecoration(
                        color: UiConstants.kAutopayAmountActiveTabColor
                            .withOpacity(0.45),
                        borderRadius: service.isDaily
                            ? BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.roundness5),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness5),
                              )
                            : BorderRadius.only(
                                topRight:
                                    Radius.circular(SizeConfig.roundness5),
                                bottomRight:
                                    Radius.circular(SizeConfig.roundness5),
                              ),
                      ),
                      duration: Duration(milliseconds: 500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Haptic.vibrate();
                            service.isDaily = true;
                            service.onAmountValueChanged(
                                service.amountController.text);
                          },
                          child: SegmentChips(
                            isDaily: service.isDaily,
                            text: "Daily",
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Haptic.vibrate();
                            service.isDaily = false;
                            service.onAmountValueChanged(
                              service.amountController.text,
                            );
                          },
                          child: SegmentChips(
                            isDaily: service.isDaily,
                            text: "Weekly",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.pageHorizontalMargins,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10,
                  vertical: SizeConfig.padding10,
                ),
                child: ReactivePositiveAppButton(
                    btnText: "Update",
                    onPressed: () async {
                      await service.updateSubscription();
                    })),
            TextButton(
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
                Future.delayed(Duration(seconds: 1), () {
                  BaseUtil.openModalBottomSheet(
                      isBarrierDismissible: true,
                      addToScreenStack: true,
                      hapticVibrate: true,
                      content: PauseAutosaveModal(
                        model: service,
                      ));
                });
              },
              child: Text(
                "PAUSE AUTOSAVE",
                style:
                    TextStyles.rajdhaniM.body1.colour(UiConstants.kTextColor2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
