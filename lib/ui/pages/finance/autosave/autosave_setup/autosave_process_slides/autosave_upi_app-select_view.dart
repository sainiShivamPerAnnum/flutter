import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/autosave_summary.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpiAppSelectView extends StatelessWidget {
  const UpiAppSelectView({
    required this.model,
    super.key,
  });

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return model.appsList.isNotEmpty
        ? Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: AutosaveSummary(
                            showTopDivider: false, model: model)),
                    Divider(
                      height: SizeConfig.padding16,
                      color: Colors.white30,
                      indent: SizeConfig.pageHorizontalMargins,
                      endIndent: SizeConfig.pageHorizontalMargins,
                    ),
                    Text(
                      model.selectedFrequency == FREQUENCY.daily
                          ? "Autosave will be processed  everyday at 8 AM"
                          : model.selectedFrequency == FREQUENCY.weekly
                              ? "Autosave will be processed on every Sunday"
                              : "Autosave will be done on 1st of every month",
                      style: TextStyles.sourceSans.body2
                          .colour(UiConstants.kTextColor2),
                    ),
                    SizedBox(height: SizeConfig.padding40),
                    Text(
                      "Select a UPI App to setup",
                      style: TextStyles.rajdhaniSB.title4,
                    ),
                    SizedBox(height: SizeConfig.padding20),
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: model.appsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Haptic.vibrate();
                              model.selectedUpiApp = model.appsList[index];
                              model.trackAutosaveUpiAppTapped();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: UiConstants.kBackgroundColor3,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: model.selectedUpiApp != null &&
                                              model.selectedUpiApp ==
                                                  model.appsList[index]
                                          ? const Offset(1, 1)
                                          : const Offset(4, 4),
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ],
                                border: Border.all(
                                    color: model.selectedUpiApp != null &&
                                            model.selectedUpiApp ==
                                                model.appsList[index]
                                        ? UiConstants.primaryColor
                                        : Colors.white,
                                    width: model.selectedUpiApp != null &&
                                            model.selectedUpiApp ==
                                                model.appsList[index]
                                        ? 2
                                        : 0.5),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12,
                                      ),
                                      child: model.appsList[index]
                                          .iconImage(SizeConfig.padding40),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      model.appsList[index].upiApplication
                                          .appName,
                                      style: TextStyles.sourceSans
                                          .colour(Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: SizeConfig.padding20,
                        ),
                      ),
                    ),
                    if (model.selectedUpiApp != null)
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding32,
                          horizontal: SizeConfig.pageHorizontalMargins,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white54, width: 0.5),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness16),
                          ),
                          padding: EdgeInsets.all(SizeConfig.padding16),
                          child: Row(children: [
                            SvgPicture.asset(
                              Assets.securityCheck,
                              width: SizeConfig.padding54,
                            ),
                            SizedBox(width: SizeConfig.padding12),
                            Expanded(
                              child: Text(
                                "You will receive a mandate for ₹${model.monthlyMaxMinInfo.max.LENDBOXP2P} on the selected UPI App. But don’t worry, We will not deduct anymore than ₹${model.totalInvestingAmount}/${model.selectedFrequency.rename()}.",
                                style: TextStyles.body3
                                    .colour(UiConstants.kTextColor2),
                              ),
                            )
                          ]),
                        ),
                      ),
                    SizedBox(
                      height: SizeConfig.navBarHeight,
                    )
                  ],
                ),
              ),
              if (model.selectedUpiApp != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReactivePositiveAppButton(
                          btnText: locale.btnSubmit,
                          onPressed: () async {
                            Haptic.vibrate();
                            if (model.selectedUpiApp == null) {
                              return BaseUtil.showNegativeAlert(
                                  "No app selected",
                                  'Please choose a upi app to continue');
                            }
                            await model.createSubscription();
                          },
                          width: SizeConfig.screenWidth! * 0.88,
                        ),
                        SizedBox(
                          height: SizeConfig.padding32,
                        ),
                      ],
                    ),
                  ),
                )
            ],
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Text(
                "Your device does not contain any supported UPI app. please download one to continue the setup autosave",
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniM.title3.colour(
                  Colors.white,
                ),
              ),
            ),
          );
  }
}
