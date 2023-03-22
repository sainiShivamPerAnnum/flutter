import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_slides/autosave_setup_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

final formKey = GlobalKey<FormState>();

class AutosaveComboInputFieldsModalSheet extends StatefulWidget {
  final AutosaveProcessViewModel model;
  const AutosaveComboInputFieldsModalSheet({super.key, required this.model});

  @override
  State<AutosaveComboInputFieldsModalSheet> createState() =>
      _AutosaveComboInputFieldsModalSheetState();
}

class _AutosaveComboInputFieldsModalSheetState
    extends State<AutosaveComboInputFieldsModalSheet> {
  List getRangeSubtitle(FREQUENCY freq) {
    switch (freq) {
      case FREQUENCY.daily:
        return ["(₹25 - ₹5000)", "(₹25 - ₹5000)"];
      case FREQUENCY.weekly:
        return ["(₹50 - ₹5000)", "(₹50 - ₹5000)"];
      case FREQUENCY.monthly:
        return ["(₹100 - ₹5000)", "(₹100 - ₹5000)"];
    }
  }

  validateFloValue(String? value, FREQUENCY freq) {
    int amt = int.tryParse(value ?? '0')!;
    switch (freq) {
      case FREQUENCY.daily:
        return amt < 25
            ? "Amount too low"
            : amt > 5000
                ? "Amount too high"
                : null;

      case FREQUENCY.weekly:
        return amt < 50
            ? "Amount too low"
            : amt > 5000
                ? "Amount too high"
                : null;
      case FREQUENCY.monthly:
        return amt < 100
            ? "Amount too low"
            : amt > 5000
                ? "Amount too high"
                : null;
    }
  }

  validateGoldValue(String? value, FREQUENCY freq) {
    int amt = int.tryParse(value ?? '0')!;
    switch (freq) {
      case FREQUENCY.daily:
        return amt < 25 ? "low amount" : null;
      case FREQUENCY.weekly:
        return amt < 50 ? "low amount" : null;
      case FREQUENCY.monthly:
        return amt < 100 ? "low amount" : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
              key: formKey,
              child: Column(
                children: [
                  AutosaveAmountInputTile(
                    asset: widget.model.autosaveAssetOptionList[1].asset,
                    title: widget.model.autosaveAssetOptionList[1].title,
                    subtitle:
                        getRangeSubtitle(widget.model.selectedFrequency)[0],
                    controller: widget.model.floAmountFieldController!,
                    autoFocus: true,
                    onValueChanged: (val) {
                      if (val.isEmpty) val = '0';
                      widget.model.totalInvestingAmount =
                          int.tryParse(val ?? '0')! +
                              int.tryParse(widget
                                      .model.goldAmountFieldController?.text ??
                                  '0')!;
                      setState(() {});
                    },
                    validator: (val) {
                      return validateFloValue(
                          val, widget.model.selectedFrequency);
                    },
                  ),
                  AutosaveAmountInputTile(
                    asset: widget.model.autosaveAssetOptionList[2].asset,
                    title: widget.model.autosaveAssetOptionList[2].title,
                    subtitle:
                        getRangeSubtitle(widget.model.selectedFrequency)[1],
                    controller: widget.model.goldAmountFieldController!,
                    autoFocus: false,
                    onValueChanged: (val) {
                      if (val.isEmpty) val = '0';
                      widget.model.totalInvestingAmount =
                          int.tryParse(val ?? '0')! +
                              int.tryParse(
                                  widget.model.floAmountFieldController?.text ??
                                      '0')!;
                      setState(() {});
                    },
                    validator: (val) {
                      return validateGoldValue(
                          val, widget.model.selectedFrequency);
                    },
                  ),
                ],
              )),
          Divider(
            color: Colors.grey.withOpacity(0.4),
            height: SizeConfig.padding32,
          ),
          Row(
            children: [
              Text("Total SIP Amount", style: TextStyles.rajdhaniSB.body0),
              Spacer(),
              Text(
                "₹${widget.model.totalInvestingAmount}  ",
                style: TextStyles.sourceSans.body1,
              )
            ],
          ),
          Divider(
            color: Colors.grey.withOpacity(0.4),
            height: SizeConfig.padding32,
          ),
          if (widget.model.totalInvestingAmount > 5000)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total Investing amount should not be more than ₹5000",
                style: TextStyles.rajdhani.body3.italic.colour(Colors.red),
              ),
            ),
          AppPositiveBtn(
            btnText: "SUBMIT",
            onPressed: () {
              if (widget.model.totalInvestingAmount > 5000)
                return BaseUtil.showNegativeAlert("Entered amount is too high",
                    "Please reduce the investing amount and try again");
              if (formKey.currentState!.validate()) {
                widget.model.customComboModel = SubComboModel(
                    order: 3,
                    title: "Custom",
                    popular: false,
                    AUGGOLD99: int.tryParse(
                        widget.model.goldAmountFieldController!.text)!,
                    LENDBOXP2P: int.tryParse(
                        widget.model.floAmountFieldController!.text)!,
                    icon: "",
                    isSelected: true);
                widget.model.deselectOtherComboIfAny(notify: true);
                AppState.backButtonDispatcher!.didPopRoute();
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
        ],
      ),
    );
  }
}
