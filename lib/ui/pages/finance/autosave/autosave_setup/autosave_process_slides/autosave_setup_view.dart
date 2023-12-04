import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/autosave_frequency_bar.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/autosave_summary.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/center_text_field.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/chips_and_combos.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoPaySetupOrUpdateView extends StatelessWidget {
  const AutoPaySetupOrUpdateView({
    required this.model,
    super.key,
  });

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight! - SizeConfig.fToolBarHeight,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutosaveSetupTitle(model: model),
                if (model.selectedAssetOption != 0)
                  const AutosaveSetupSubtitle(),
                SizedBox(height: SizeConfig.padding24),
                AutosaveFrequencyBar(model: model),
                if (model.selectedAssetOption == 1)
                  CenterTextField(
                    model: model,
                    amountFieldController: model.floAmountFieldController!,
                    onChanged: model.onCenterLbTextFieldChange,
                  ),
                if (model.selectedAssetOption == 2)
                  CenterTextField(
                    model: model,
                    amountFieldController: model.goldAmountFieldController!,
                    onChanged: model.onCenterGoldTextFieldChange,
                  ),
                ChipsAndCombos(model: model),
                if (model.selectedAssetOption == 0)
                  AutosaveSummary(model: model, showTitle: false),
                SizedBox(height: SizeConfig.padding90)
              ],
            ),
          ),
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () => FocusScope.of(context).unfocus(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: SizeConfig.padding175,
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                if (model.selectedAssetOption != 0)
                  SvgPicture.network(
                    model.getGoals(),
                    width: SizeConfig.screenWidth,
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    child: ReactivePositiveAppButton(
                      btnText:
                          "SETUP FOR ₹${model.totalInvestingAmount}/${model.selectedFrequency.rename()}",
                      onPressed: model.setupCtaOnPressed,
                      width: SizeConfig.screenWidth! * 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class AutosaveSetupSubtitle extends StatelessWidget {
  const AutosaveSetupSubtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding10, horizontal: SizeConfig.padding16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text("Choose an amount & frequency for your Autosave",
            textAlign: TextAlign.center, style: TextStyles.sourceSans.body2),
      ),
    );
  }
}

class AutosaveSetupTitle extends StatelessWidget {
  const AutosaveSetupTitle({
    required this.model,
    super.key,
  });

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return Text(
        model.selectedAssetOption == 0
            ? "Select Frequency and Combo"
            : model.selectedAssetOption == 1
                ? "Fello Flo Autosave"
                : "Digital Gold Autosave",
        style: TextStyles.rajdhaniSB.title3);
  }
}
