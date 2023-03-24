import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/ui/elements/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/ui/pages/finance/autosave/amount_chips.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/segmate_chip.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoPaySetupOrUpdateView extends StatelessWidget {
  AutoPaySetupOrUpdateView({
    super.key,
    required this.model,
  });
  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Stack(
      children: [
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //     height: SizeConfig.navBarHeight * 2,
        //     width: SizeConfig.screenWidth,
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [Colors.transparent, UiConstants.kBackgroundColor],
        //       ),
        //     ),
        //   ),
        // ),
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
                Text(
                    model.selectedAssetOption == 0
                        ? "Flo & Gold Combo Autosave"
                        : model.selectedAssetOption == 1
                            ? "Fello Flo Autosave"
                            : "Digital Gold Autosave",
                    style: TextStyles.rajdhaniSB.title3),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding10,
                      horizontal: SizeConfig.padding16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                        model.selectedAssetOption == 0
                            ? "Select a frequency and a combo"
                            : "Choose an amount & frequency for your Autosave",
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2),
                  ),
                ),
                SizedBox(height: SizeConfig.padding24),
                AutosaveFrequencyBar(model: model),
                if (model.selectedAssetOption == 1)
                  CenterTextField(
                    model: model,
                    readOnly: model.readOnly,
                    amountFieldController: model.floAmountFieldController!,
                    onChanged: (val) {
                      model.totalInvestingAmount = int.tryParse(
                          model.floAmountFieldController?.text ?? '0')!;
                    },
                  ),
                if (model.selectedAssetOption == 2)
                  CenterTextField(
                    model: model,
                    readOnly: model.readOnly,
                    amountFieldController: model.goldAmountFieldController!,
                    onChanged: (val) {
                      model.totalInvestingAmount = int.tryParse(
                          model.goldAmountFieldController?.text ?? '0')!;
                    },
                  ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding16),
                  child: AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: model.selectedAssetOption == 0
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16),
                            child: HeightAdaptivePageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: model.comboController,
                              children: [
                                AutosaveComboGrid(
                                    model: model, frequency: FREQUENCY.daily),
                                AutosaveComboGrid(
                                    model: model, frequency: FREQUENCY.weekly),
                                AutosaveComboGrid(
                                    model: model, frequency: FREQUENCY.monthly),
                              ],
                            ),
                          )
                        : Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.padding70,
                            child: PageView(
                              controller: model.chipsController,
                              children: [
                                AutosaveSuggestionChipsRow(
                                    model: model, frequency: FREQUENCY.daily),
                                AutosaveSuggestionChipsRow(
                                    model: model, frequency: FREQUENCY.weekly),
                                AutosaveSuggestionChipsRow(
                                    model: model, frequency: FREQUENCY.monthly),
                              ],
                            ),
                          ),
                  ),
                ),
                if (model.selectedAssetOption == 0)
                  AutosaveSummary(model: model),
                SizedBox(height: SizeConfig.padding90)
              ],
            ),
          ),
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () {
            FocusScope.of(context).unfocus();
          },
        ),
        if (model.totalInvestingAmount != 0)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: ReactivePositiveAppButton(
                btnText:
                    "SETUP AUTOSAVE FOR ₹${model.totalInvestingAmount}/${model.selectedFrequency.name}",
                onPressed: () async {
                  Haptic.vibrate();
                  await model.updateSubscription();
                },
                width: SizeConfig.screenWidth! * 0.8,
              ),
            ),
          )
      ],
    );
  }
}

class AutosaveSummary extends StatelessWidget {
  const AutosaveSummary({
    super.key,
    this.showTopDivider = true,
    required this.model,
  });

  final AutosaveProcessViewModel model;
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider)
          Divider(
            height: SizeConfig.padding12,
            color: Colors.white24,
          ),
        Text("Autosave Summary", style: TextStyles.rajdhaniSB.title3),
        SizedBox(height: SizeConfig.padding16),
        if (model.goldAmountFieldController!.text.isNotEmpty &&
            int.tryParse(model.goldAmountFieldController!.text) != 0)
          ListTile(
            leading: Image.asset(
              Assets.digitalGoldBar,
              width: SizeConfig.padding44,
            ),
            title: Text(
              "Digital Gold",
              style: TextStyles.sourceSans.body1,
            ),
            trailing: Text(
              "₹" + model.goldAmountFieldController!.text,
              style: TextStyles.sourceSansB.body1,
            ),
          ),
        if (model.floAmountFieldController!.text.isNotEmpty &&
            int.tryParse(model.floAmountFieldController!.text) != 0)
          ListTile(
            leading: Image.asset(
              Assets.felloFlo,
              width: SizeConfig.padding44,
            ),
            title: Text(
              "Fello Flo",
              style: TextStyles.sourceSans.body1,
            ),
            trailing: Text(
              "₹" + model.floAmountFieldController!.text,
              style: TextStyles.sourceSansB.body1,
            ),
          ),
        Divider(
          color: Colors.white24,
        ),
        ListTile(
          // leading: SvgPicture.asset(
          //   Assets.floGold,
          //   width: SizeConfig.padding44,
          // ),
          title: Text(
            "Total Amount",
            style: TextStyles.sourceSans.body1,
          ),
          trailing: Text(
            "₹" +
                model.totalInvestingAmount.toString() +
                "/${model.selectedFrequency.name}",
            style: TextStyles.sourceSansB.body1,
          ),
        ),
      ],
    );
  }
}

class AutosaveFrequencyBar extends StatelessWidget {
  const AutosaveFrequencyBar({
    super.key,
    required this.model,
  });

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kBackgroundColor3,
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        border: Border.all(
          color: UiConstants.kBorderColor.withOpacity(0.22),
          width: SizeConfig.border1,
        ),
      ),
      width: SizeConfig.screenWidth! * 0.7248,
      height: SizeConfig.screenWidth! * 0.0987,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate,
            left: model.selectedFrequency == FREQUENCY.daily
                ? 0
                : model.selectedFrequency == FREQUENCY.weekly
                    ? SizeConfig.screenWidth! * 0.24
                    : SizeConfig.screenWidth! * 0.48,
            child: AnimatedContainer(
              width: SizeConfig.screenWidth! * 0.24,
              height: SizeConfig.screenWidth! * 0.094,
              decoration: BoxDecoration(
                color: UiConstants.kAutopayAmountActiveTabColor,
                borderRadius: model.selectedFrequency == FREQUENCY.daily
                    ? BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness5),
                        bottomLeft: Radius.circular(SizeConfig.roundness5),
                      )
                    : model.selectedFrequency == FREQUENCY.weekly
                        ? BorderRadius.zero
                        : BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness5),
                            bottomRight: Radius.circular(SizeConfig.roundness5),
                          ),
              ),
              duration: Duration(milliseconds: 500),
            ),
          ),
          Row(
            children: [
              SegmentChips(
                frequency: FREQUENCY.daily,
                model: model,
              ),
              SegmentChips(
                frequency: FREQUENCY.weekly,
                model: model,
              ),
              SegmentChips(
                frequency: FREQUENCY.monthly,
                model: model,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AutosaveComboGrid extends StatelessWidget {
  const AutosaveComboGrid({
    super.key,
    required this.frequency,
    required this.model,
  });

  final AutosaveProcessViewModel model;
  final FREQUENCY frequency;

  @override
  Widget build(BuildContext context) {
    List<SubComboModel> combo = model.getCombos(frequency);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: combo.length + 1,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: SizeConfig.padding24,
        mainAxisSpacing: SizeConfig.padding10,
        mainAxisExtent: SizeConfig.screenWidth! * 0.42,
      ),
      itemBuilder: (ctx, i) {
        return i == combo.length
            ? (model.customComboModel != null
                ? GestureDetector(
                    onTap: () =>
                        model.openCustomInputModalSheet(model, isNew: false),
                    child: ComboCard(
                      combo: model.customComboModel!,
                      isCustomCreated: true,
                    ))
                : CustomComboCard(
                    model: model,
                  ))
            : GestureDetector(
                onTap: () => model.onComboTapped(i),
                child: ComboCard(
                  combo: combo[i],
                ),
              );
      },
    );
  }
}

class ComboCard extends StatelessWidget {
  const ComboCard({
    super.key,
    this.isCustomCreated = false,
    required this.combo,
  });

  final SubComboModel combo;
  final bool isCustomCreated;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        combo.popular
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        SizeConfig.roundness5,
                      ),
                      topRight: Radius.circular(SizeConfig.roundness5)),
                  color: Color(0xffF7C780),
                ),
                height: SizeConfig.padding16,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                child: Text(
                  "POPULAR",
                  style: TextStyles.body4,
                ),
              )
            : SizedBox(
                height: SizeConfig.padding16,
              ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.darkPrimaryColor.withOpacity(0.3),
                    Color(0xffF7C780).withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                    width: 1,
                    color: combo.isSelected
                        ? UiConstants.primaryColor
                        : Colors.grey),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                color: UiConstants.kBackgroundColor2),
            padding: EdgeInsets.only(top: SizeConfig.padding10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    combo.icon.isNotEmpty
                        ? combo.icon
                        : "https://d37gtxigg82zaw.cloudfront.net/game-icons/knife-hit-icon.svg",
                    height: SizeConfig.padding20,
                  ),
                  Text(
                    "  " + combo.title,
                    style: TextStyles.sourceSansM.body2,
                  ),
                ],
              ),
              Divider(
                color: Colors.white.withOpacity(0.2),
                thickness: 0.5,
                height: SizeConfig.padding12,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "₹${combo.LENDBOXP2P}",
                            style: TextStyles.sourceSansB.body1,
                          ),
                          Text(
                            "Flo",
                            style: TextStyles.body3
                                .colour(UiConstants.kTextColor3),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "+",
                      style: TextStyles.rajdhaniB.title2
                          .colour(UiConstants.kTextColor),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${combo.AUGGOLD99}",
                          style: TextStyles.sourceSansB.body1,
                        ),
                        Text(
                          "Gold",
                          style:
                              TextStyles.body3.colour(UiConstants.kTextColor3),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              Container(
                height: SizeConfig.padding40,
                decoration: BoxDecoration(
                    color: UiConstants.kBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          SizeConfig.roundness8,
                        ),
                        bottomRight: Radius.circular(SizeConfig.roundness8))),
                alignment: Alignment.center,
                child: Text(
                  combo.isSelected
                      ? "SELECTED"
                      : isCustomCreated
                          ? "UPDATE"
                          : "SELECT",
                  style: TextStyles.body3.colour(combo.isSelected
                      ? UiConstants.primaryColor
                      : Colors.white),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}

class CustomComboCard extends StatelessWidget {
  const CustomComboCard({super.key, required this.model});

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.openCustomInputModalSheet(model),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding16),
          Container(
            height: SizeConfig.screenWidth! * 0.38,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UiConstants.darkPrimaryColor.withOpacity(0.3),
                    Color(0xffF7C780).withOpacity(0.3),
                  ],
                ),
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                color: UiConstants.kBackgroundColor2),
            padding: EdgeInsets.only(top: SizeConfig.padding10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create your own",
                      style: TextStyles.sourceSansM.body2,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 0.5,
                  height: SizeConfig.padding12,
                ),
                Expanded(
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: SizeConfig.padding64,
                  ),
                ),
                Container(
                  height: SizeConfig.padding40,
                  decoration: BoxDecoration(
                      color: UiConstants.kBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            SizeConfig.roundness8,
                          ),
                          bottomRight: Radius.circular(SizeConfig.roundness8))),
                  alignment: Alignment.center,
                  child: Text(
                    "CREATE",
                    style: TextStyles.body3.colour(Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AutosaveSuggestionChipsRow extends StatelessWidget {
  const AutosaveSuggestionChipsRow({
    super.key,
    required this.model,
    required this.frequency,
  });

  final AutosaveProcessViewModel model;
  final FREQUENCY frequency;

  @override
  Widget build(BuildContext context) {
    List<AmountChipsModel> chipsData = model.getChips(frequency);
    print(chipsData.map((e) => e.toString()).toList());
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          model.getChipsLength(),
          (index) => AmountChips(
            isSelected: ((model.selectedAssetOption == 1 &&
                    int.tryParse(model.floAmountFieldController!.text) ==
                        chipsData[index].value) ||
                (model.selectedAssetOption == 2 &&
                    int.tryParse(model.goldAmountFieldController!.text) ==
                        chipsData[index].value)),
            amount: chipsData[index].value,
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onChipTapped(chipsData[index].value!, index);
            },
            isBestSeller: chipsData[index].best,
          ),
        ));
  }
}

// class AutosaveSingleAssetDetails extends StatelessWidget {
//   const AutosaveSingleAssetDetails({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.asset,
//   });
//   final String title, subtitle, asset;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//           top: SizeConfig.padding12, bottom: SizeConfig.padding24),
//       width: SizeConfig.screenWidth,
//       child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: TextStyles.sourceSansB.body1,
//             ),
//             Text(subtitle,
//                 style: TextStyles.sourceSans.body3.colour(Colors.grey)),
//           ],
//         ),
//       ]),
//     );
//   }
// }

class AutosaveAmountInputTile extends StatelessWidget {
  const AutosaveAmountInputTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.autoFocus = false,
    required this.asset,
    required this.controller,
    required this.onValueChanged,
    required this.validator,
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
        Spacer(),
        Container(
          width: SizeConfig.screenWidth! * 0.4,
          child: AppTextField(
            textEditingController: controller,
            isEnabled: true,
            keyboardType: TextInputType.number,
            prefixText: "₹ ",
            maxLength: 4,
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

class CenterTextField extends StatefulWidget {
  const CenterTextField({
    super.key,
    required this.amountFieldController,
    required this.onChanged,
    required this.readOnly,
    required this.model,
  });

  final TextEditingController amountFieldController;
  final Function onChanged;
  final bool readOnly;
  final AutosaveProcessViewModel model;

  @override
  State<CenterTextField> createState() => _CenterTextFieldState();
}

class _CenterTextFieldState extends State<CenterTextField> {
  double? _fieldWidth;
  bool readOnly = true;

  double? get fieldWidth => this._fieldWidth;

  set fieldWidth(double? value) {
    // setState(() {
    this._fieldWidth = value;
    // });
  }

  enableField() {
    if (readOnly)
      setState(() {
        readOnly = false;
      });
  }

  @override
  initState() {
    super.initState();
    _fieldWidth = ((SizeConfig.screenWidth! * 0.07) *
        widget.amountFieldController.text.length.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        enableField();
        FocusScope.of(context).requestFocus();
      },
      child: Container(
        width: SizeConfig.screenWidth! * 0.784,
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
        decoration: BoxDecoration(
          color: UiConstants.kTextFieldColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color: UiConstants.kTextColor.withOpacity(0.1),
            width: SizeConfig.border1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹",
              style:
                  TextStyles.rajdhaniB.size(SizeConfig.screenWidth! * 0.1067),
            ),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                onTap: enableField,
                showCursor: true,
                autofocus: true,
                controller: widget.amountFieldController,
                keyboardType: TextInputType.number,
                readOnly: readOnly,
                style:
                    TextStyles.rajdhaniB.size(SizeConfig.screenWidth! * 0.1067),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  // isCollapse: true,
                  isDense: true,
                ),
                onChanged: (val) {
                  widget.onChanged(val);
                  fieldWidth = ((SizeConfig.screenWidth! * 0.08) *
                      widget.amountFieldController.text.length.toDouble());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoPayBenefits extends StatelessWidget {
  AutoPayBenefits({super.key});
  final S locale = locator<S>();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              Assets.sprout,
              width: SizeConfig.iconSize5,
              height: SizeConfig.iconSize5,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              locale.interestOnGold,
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              Assets.ticketOutlined,
              width: SizeConfig.padding24,
              height: SizeConfig.padding24,
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Text(
              locale.oneScratchCard,
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              Assets.tokenOutlined,
              width: SizeConfig.padding24,
              height: SizeConfig.padding24,
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Text(
              locale.fiftyFelloTokens,
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
