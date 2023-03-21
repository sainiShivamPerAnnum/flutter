import 'package:felloapp/core/model/amount_chips_model.dart';
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
    // required this.isSetup,
    required this.model,
    // required this.onCtaTapped,
    // required this.isDaily,
    // // required this.onAmountValueChanged,
    // required this.onChipsTapped,
    // required this.onFrequencyTapped,
    // required this.amountFieldController,
    // required this.dailyChips,
    // required this.weeklyChips,
  });
  // final bool isSetup;
  final AutosaveProcessViewModel model;
  // final Function onCtaTapped;
  // final S locale = locator<S>();
  // final bool isDaily;
  // // final Function onAmountValueChanged;
  // final Function onChipsTapped;
  // final Function onFrequencyTapped;
  // final TextEditingController amountFieldController;
  // final List<AmountChipsModel> dailyChips;
  // final List<AmountChipsModel> weeklyChips;
  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
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
                Text("Select amount & frequency",
                    style: TextStyles.rajdhaniSB.title3),
                SizedBox(height: SizeConfig.padding24),
                Container(
                  decoration: BoxDecoration(
                    color: UiConstants.kAutopayAmountDeactiveTabColor,
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
                            color: UiConstants.kAutopayAmountActiveTabColor
                                .withOpacity(0.45),
                            borderRadius: model.selectedFrequency ==
                                    FREQUENCY.daily
                                ? BorderRadius.only(
                                    topLeft:
                                        Radius.circular(SizeConfig.roundness5),
                                    bottomLeft:
                                        Radius.circular(SizeConfig.roundness5),
                                  )
                                : model.selectedFrequency == FREQUENCY.weekly
                                    ? BorderRadius.zero
                                    : BorderRadius.only(
                                        topRight: Radius.circular(
                                            SizeConfig.roundness5),
                                        bottomRight: Radius.circular(
                                            SizeConfig.roundness5),
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
                ),
                SizedBox(height: SizeConfig.padding24),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: Text("Enter an amount to SIP or choose a combo",
                      style: TextStyles.sourceSans.body2),
                ),
                if (model.selectedAssetOption == 0 ||
                    model.selectedAssetOption == 1)
                  AutosaveAmountInputTile(
                    asset: model.autosaveAssetOptionList[1].asset,
                    title: model.autosaveAssetOptionList[1].title,
                    subtitle: "10% Returns P.A",
                    controller: model.floAmountFieldController!,
                    onValueChanged: (val) {
                      model.totalInvestingAmount = int.tryParse(val ?? '0')! +
                          int.tryParse(
                              model.goldAmountFieldController?.text ?? '0')!;
                    },
                  ),
                if (model.selectedAssetOption == 0 ||
                    model.selectedAssetOption == 2)
                  AutosaveAmountInputTile(
                    asset: model.autosaveAssetOptionList[2].asset,
                    title: model.autosaveAssetOptionList[2].title,
                    subtitle: "Stable Returns",
                    controller: model.goldAmountFieldController!,
                    onValueChanged: (val) {
                      model.totalInvestingAmount = int.tryParse(val ?? '0')! +
                          int.tryParse(
                              model.floAmountFieldController?.text ?? '0')!;
                    },
                  ),
                Divider(
                  color: Colors.grey.withOpacity(0.4),
                  height: SizeConfig.padding32,
                ),
                Row(
                  children: [
                    Text("Total SIP Amount",
                        style: TextStyles.rajdhaniSB.body0),
                    Spacer(),
                    Text(
                      "₹${model.totalInvestingAmount}  ",
                      style: TextStyles.sourceSans.body1,
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.4),
                  height: SizeConfig.padding32,
                ),
                // AnimatedBuilder(animation: animation, builder: builder)

                AnimatedSwitcher(
                  // controller: model.optionsController,
                  // physics: NeverScrollableScrollPhysics(),
                  duration: Duration(seconds: 1),
                  child: model.selectedAssetOption == 0
                      ? Column(
                          children: [
                            Text("Popular SIP Combos",
                                style: TextStyles.rajdhaniSB.title3),
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: SizeConfig.padding10,
                                crossAxisSpacing: SizeConfig.padding10,
                                mainAxisExtent: SizeConfig.screenWidth! * 0.4,
                              ),
                              itemBuilder: (ctx, i) {
                                return Container(
                                  color: Colors.amber,
                                );
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text("Popular SIP options",
                                style: TextStyles.rajdhaniSB.title3),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding16),
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.padding70,
                              child: PageView(
                                controller: model.chipsController,
                                children: [
                                  AutosaveSuggestionChipsRow(
                                      model: model, frequency: FREQUENCY.daily),
                                  AutosaveSuggestionChipsRow(
                                      model: model,
                                      frequency: FREQUENCY.weekly),
                                  AutosaveSuggestionChipsRow(
                                      model: model,
                                      frequency: FREQUENCY.monthly),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: SizeConfig.padding90,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: ReactivePositiveAppButton(
              btnText: model.finalButtonCta,
              onPressed: () async {
                Haptic.vibrate();
                await model.createOrUpdateSubscription();
              },
              width: SizeConfig.screenWidth! * 0.8,
            ),
          ),
        )
      ],
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
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
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
            onTap: () => model.onChipTapped(chipsData[index].value!, index),
            isBestSeller: chipsData[index].best,
          ),
        ));
  }
}

class AutosaveAmountInputTile extends StatelessWidget {
  const AutosaveAmountInputTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.asset,
      required this.controller,
      required this.onValueChanged});
  final String title, subtitle, asset;
  final TextEditingController controller;
  final Function onValueChanged;

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
            Text(subtitle,
                style: TextStyles.sourceSans.body3.colour(Colors.grey)),
          ],
        ),
        Spacer(),
        Container(
          width: SizeConfig.screenWidth! * 0.3,
          child: AppTextField(
            textEditingController: controller,
            isEnabled: true,
            keyboardType: TextInputType.number,
            prefixText: "₹ ",
            textAlign: TextAlign.center,
            prefixTextStyle: TextStyles.rajdhaniB.body1,
            onChanged: onValueChanged,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
            ],
            validator: (value) {
              if (value != null && value.isEmpty)
                return "Field cannot be empty";
            },
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
  });

  final TextEditingController amountFieldController;

  @override
  State<CenterTextField> createState() => _CenterTextFieldState();
}

class _CenterTextFieldState extends State<CenterTextField> {
  double? _fieldWidth;

  double? get fieldWidth => this._fieldWidth;

  set fieldWidth(double? value) {
    // setState(() {
    this._fieldWidth = value;
    // });
  }

  @override
  initState() {
    super.initState();
    _fieldWidth = ((SizeConfig.screenWidth! * 0.08) *
        widget.amountFieldController.text.length.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.784,
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
            style: TextStyles.rajdhaniB.size(SizeConfig.screenWidth! * 0.1067),
          ),
          SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: widget.amountFieldController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style:
                    TextStyles.rajdhaniB.size(SizeConfig.screenWidth! * 0.1067),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  // isCollapse: true,
                  isDense: true,
                ),
                onChanged: (String? val) {
                  // widget.onAmountValueChanged(val);
                  if ((val ?? '').isEmpty)
                    fieldWidth = 10.0;
                  else
                    fieldWidth = ((SizeConfig.screenWidth! * 0.08) *
                        widget.amountFieldController.text.length.toDouble());
                  setState(() {});
                },
              )
              // AppTextField(
              //   textEditingController: widget.amountFieldController,
              //   isEnabled: true,
              //   validator: (val) => null,
              //   autoFocus: true,
              //   onChanged: (String? val) {
              //     // widget.onAmountValueChanged(val);
              //     if ((val ?? '').isEmpty)
              //       fieldWidth = 10;
              //     else
              //       fieldWidth = ((SizeConfig.screenWidth! * 0.065) *
              //           widget.amountFieldController.text.length
              //               .toDouble());
              //   },
              //   keyboardType: TextInputType.number,
              //   inputDecoration: InputDecoration(
              //     focusedBorder: InputBorder.none,
              //     border: InputBorder.none,
              //     enabledBorder: InputBorder.none,
              //     // isCollapse: true,
              //     isDense: true,
              //   ),
              //   textAlign: TextAlign.center,
              //   textStyle: TextStyles.rajdhaniB
              //       .size(SizeConfig.screenWidth! * 0.1067),
              //   // height: SizeConfig.screenWidth * 0.1706,
              // ),
              ),
        ],
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
