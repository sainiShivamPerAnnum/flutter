import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final formKey = GlobalKey<FormState>();

class AutosaveComboInputFieldsModalSheet extends StatefulWidget {
  final AutosaveProcessViewModel model;
  const AutosaveComboInputFieldsModalSheet({required this.model, super.key});

  @override
  State<AutosaveComboInputFieldsModalSheet> createState() =>
      _AutosaveComboInputFieldsModalSheetState();
}

class _AutosaveComboInputFieldsModalSheetState
    extends State<AutosaveComboInputFieldsModalSheet> {
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _floController = TextEditingController();
  int totalSipAmount = 0;
  List getRangeSubtitle(FREQUENCY freq) {
    switch (freq) {
      case FREQUENCY.daily:
        return [
          "(₹${widget.model.dailyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.dailyMaxMinInfo.max.LENDBOXP2P})",
          "(₹${widget.model.dailyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.dailyMaxMinInfo.max.AUGGOLD99})",
        ];
      case FREQUENCY.weekly:
        return [
          "(₹${widget.model.weeklyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.weeklyMaxMinInfo.max.LENDBOXP2P})",
          "(₹${widget.model.weeklyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.weeklyMaxMinInfo.max.AUGGOLD99})",
        ];
      case FREQUENCY.monthly:
        return [
          "(₹${widget.model.monthlyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.monthlyMaxMinInfo.max.LENDBOXP2P})",
          "(₹${widget.model.monthlyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.monthlyMaxMinInfo.max.AUGGOLD99})",
        ];
    }
  }

  updateSipAmount() {
    int floAmt = 0;
    int goldAmt = 0;

    if (_floController.text.isNotEmpty) {
      floAmt = int.tryParse(_floController.text) ?? 0;
    }
    if (_goldController.text.isNotEmpty) {
      goldAmt = int.tryParse(_goldController.text) ?? 0;
    }
    setState(() {
      totalSipAmount = floAmt + goldAmt;
    });
  }

  validateFloValue(String? value, FREQUENCY freq) {
    if (value!.isEmpty) return "Enter valid amount";
    int amt = int.tryParse(value ?? '0')!;
    switch (freq) {
      case FREQUENCY.daily:
        return amt < widget.model.dailyMaxMinInfo.min.LENDBOXP2P
            ? "Enter valid amount"
            : amt > widget.model.dailyMaxMinInfo.max.LENDBOXP2P
                ? "Amount too high"
                : null;

      case FREQUENCY.weekly:
        return amt < widget.model.weeklyMaxMinInfo.min.LENDBOXP2P
            ? "Enter valid amount"
            : amt > widget.model.weeklyMaxMinInfo.max.LENDBOXP2P
                ? "Amount too high"
                : null;
      case FREQUENCY.monthly:
        return amt < widget.model.monthlyMaxMinInfo.min.LENDBOXP2P
            ? "Enter valid amount"
            : amt > widget.model.monthlyMaxMinInfo.max.LENDBOXP2P
                ? "Amount too high"
                : null;
    }
  }

  validateGoldValue(String? value, FREQUENCY freq) {
    if (value!.isEmpty) return "Enter valid amount";
    int amt = int.tryParse(value ?? '0')!;
    switch (freq) {
      case FREQUENCY.daily:
        return amt < widget.model.dailyMaxMinInfo.min.AUGGOLD99
            ? "Enter valid amount"
            : amt > widget.model.dailyMaxMinInfo.max.AUGGOLD99
                ? "Amount too high"
                : null;

      case FREQUENCY.weekly:
        return amt < widget.model.weeklyMaxMinInfo.min.AUGGOLD99
            ? "Enter valid amount"
            : amt > widget.model.weeklyMaxMinInfo.max.AUGGOLD99
                ? "Amount too high"
                : null;
      case FREQUENCY.monthly:
        return amt < widget.model.monthlyMaxMinInfo.min.AUGGOLD99
            ? "Enter valid amount"
            : amt > widget.model.monthlyMaxMinInfo.max.AUGGOLD99
                ? "Amount too high"
                : null;
    }
  }

  @override
  initState() {
    if (widget.model.customComboModel != null) {
      _goldController.text =
          widget.model.customComboModel!.AUGGOLD99.toString();

      _floController.text =
          widget.model.customComboModel!.LENDBOXP2P.toString();
      totalSipAmount = (int.tryParse(_floController.text) ?? 0) +
          (int.tryParse(_goldController.text) ?? 0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: SizeConfig.padding6),
          FittedBox(
            child: Text("Make your own Autosave Combo",
                style: TextStyles.sourceSansSB.title5),
          ),
          SizedBox(height: SizeConfig.padding16),
          Text("Enter an amount  for Digital Gold & Fello Flo",
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.kTextColor2,
              )),
          SizedBox(height: SizeConfig.padding14),
          Form(
              key: formKey,
              child: Column(
                children: [
                  AutosaveAmountInputTile(
                    asset: widget.model.autosaveAssetOptionList[1].asset,
                    title: widget.model.autosaveAssetOptionList[1].title,
                    subtitle:
                        getRangeSubtitle(widget.model.selectedFrequency)[0],
                    controller: _floController,
                    autoFocus: true,
                    onValueChanged: (val) {
                      if (val.isEmpty) val = '0';
                      totalSipAmount = int.tryParse(val ?? '0')! +
                          (int.tryParse(_goldController.text) ?? 0);
                      updateSipAmount();
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
                    controller: _goldController,
                    autoFocus: false,
                    onValueChanged: (val) {
                      if (val.isEmpty) val = '0';
                      totalSipAmount = int.tryParse(val ?? '0')! +
                          (int.tryParse(_floController.text) ?? 0);
                      updateSipAmount();
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
              const Spacer(),
              Text(
                "₹$totalSipAmount",
                style: TextStyles.sourceSans.body1,
              )
            ],
          ),
          Divider(
            color: Colors.grey.withOpacity(0.4),
            height: SizeConfig.padding32,
          ),
          if (totalSipAmount > widget.model.monthlyMaxMinInfo.max.LENDBOXP2P)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total Investing amount should not be more than ${widget.model.monthlyMaxMinInfo.max.LENDBOXP2P}",
                style: TextStyles.rajdhani.body3.italic.colour(Colors.red),
              ),
            ),
          AppPositiveBtn(
            btnText: "SUBMIT",
            onPressed: () {
              if (totalSipAmount >
                  widget.model.monthlyMaxMinInfo.max.LENDBOXP2P) {
                BaseUtil.showNegativeAlert("Entered amount is too high",
                    "Please reduce the investing amount and try again");
                return;
              }
              if (formKey.currentState!.validate()) {
                createCombo();
                widget.model.isComboSelected = false;
                widget.model.totalInvestingAmount = totalSipAmount;
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

  createCombo() {
    if (_goldController.text.isNotEmpty && _floController.text.isNotEmpty) {
      widget.model.goldAmountFieldController?.text = _goldController.text;
    }
    widget.model.floAmountFieldController?.text = _floController.text;

    widget.model.customComboModel = SubComboModel(
        order: 3,
        title: "Custom",
        popular: false,
        AUGGOLD99: int.tryParse(_goldController.text)!,
        LENDBOXP2P: int.tryParse(_floController.text)!,
        icon: "",
        isSelected: true);
    widget.model.trackAutosaveCustomComboSubmit();
  }
}

class AutosaveAmountInputTile extends StatelessWidget {
  const AutosaveAmountInputTile({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.controller,
    required this.onValueChanged,
    required this.validator,
    super.key,
    this.autoFocus = false,
  });
  final String title, subtitle, asset;
  final TextEditingController controller;
  final Function onValueChanged;
  final bool autoFocus;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding12,
      ),
      child: Row(children: [
        Image.asset(
          asset,
          width: SizeConfig.padding70,
          fit: BoxFit.cover,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.sourceSansB.body1,
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(subtitle,
                style: TextStyles.sourceSans.body3.colour(Colors.grey)),
          ],
        ),
        const Spacer(),
        Container(
          width: SizeConfig.screenWidth! * 0.4,
          child: AppTextField(
            textEditingController: controller,
            isEnabled: true,
            keyboardType: TextInputType.number,
            prefixText: "₹ ",
            maxLength: 5,
            prefixTextStyle: TextStyles.rajdhaniB.body1,
            onChanged: onValueChanged,
            autoFocus: autoFocus,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (val) => validator(val),
          ),
        ),
      ]),
    );
  }
}
