import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class UpiAppSelectView extends StatelessWidget {
  UpiAppSelectView({super.key, required this.model
      // required this.appList,
      // this.selectedApp,
      // required this.onAppSelect,
      // required this.onCtaPressed
      });
  final AutosaveProcessViewModel model;
  // final List<ApplicationMeta> appList;
  // final ApplicationMeta? selectedApp;
  // final Function onAppSelect;
  // final Function onCtaPressed;
  final S locale = locator<S>();
  @override
  Widget build(BuildContext context) {
    return model.appsList.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                locale.setUpAutoSave,
                style: TextStyles.sourceSans.body3.setOpacity(0.5),
              ),
              SizedBox(
                height: SizeConfig.padding10,
              ),
              Text(
                "Select a UPI App",
                style: TextStyles.rajdhaniSB.title4,
              ),
              SizedBox(
                height: SizeConfig.screenWidth! * 0.1,
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: model.appsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        model.selectedUpiApp = model.appsList[index];
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
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
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              model.appsList[index]
                                  .iconImage(SizeConfig.padding40),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                model.appsList[index].upiApplication.appName,
                                style:
                                    TextStyles.sourceSans.colour(Colors.white),
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
              Spacer(
                flex: 2,
              ),
              AppPositiveBtn(
                btnText: locale.btnSumbit,
                onPressed: () {
                  Haptic.vibrate();
                  if (model.selectedUpiApp == null)
                    return BaseUtil.showNegativeAlert("No app selected",
                        'Please choose a upi app to continue');
                  model.proceed();
                },
                width: SizeConfig.screenWidth! * 0.8,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Text(
                locale.autoPayBanksSupported,
                style: TextStyles.sourceSansL.body4,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Image.asset(
                "assets/images/autosavebanks.png",
                width: SizeConfig.screenWidth! * 0.7,
              ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
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
