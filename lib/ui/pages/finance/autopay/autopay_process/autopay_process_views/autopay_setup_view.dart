import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/ui/pages/finance/autopay/amount_chips.dart';
import 'package:felloapp/ui/pages/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autopay/segmate_chip.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoPaySetupOrUpdateView extends StatelessWidget {
  AutoPaySetupOrUpdateView(
      {super.key,
      required this.isSetup,
      required this.onCtaTapped,
      required this.isDaily,
      // required this.onAmountValueChanged,
      required this.onChipsTapped,
      required this.onFrequencyTapped,
      required this.amountFieldController,
      required this.dailyChips,
      required this.weeklyChips});
  final bool isSetup;
  final Function onCtaTapped;
  final S locale = locator<S>();
  final bool isDaily;
  // final Function onAmountValueChanged;
  final Function onChipsTapped;
  final Function onFrequencyTapped;
  final TextEditingController amountFieldController;
  final List<AmountChipsModel> dailyChips;
  final List<AmountChipsModel> weeklyChips;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth! * 0.05,
        ),
        Text(
          isSetup ? locale.setUpAutoSave : locale.updateAutoSave,
          style: TextStyles.sourceSans.body3.setOpacity(0.5),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          isSetup ? locale.txnEnterAmount : locale.txnUpdateAmount,
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.144,
        ),
        Container(
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
                left: isDaily ? 0 : SizeConfig.screenWidth! * 0.248,
                child: AnimatedContainer(
                  width: SizeConfig.screenWidth! * 0.26,
                  height: SizeConfig.screenWidth! * 0.094,
                  decoration: BoxDecoration(
                    color: UiConstants.kAutopayAmountActiveTabColor
                        .withOpacity(0.45),
                    borderRadius: isDaily
                        ? BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness5),
                            bottomLeft: Radius.circular(SizeConfig.roundness5),
                          )
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onFrequencyTapped(FREQUENCY.daily),
                      child: SegmentChips(
                        isDaily: isDaily,
                        text: locale.daily,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onFrequencyTapped(FREQUENCY.weekly),
                      child: SegmentChips(
                        isDaily: isDaily,
                        text: locale.weekly,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.0693,
        ),
        CenterTextField(
            amountFieldController: amountFieldController,
            // onAmountValueChanged: onAmountValueChanged,
            isDaily: isDaily,
            locale: locale),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        Container(
          width: SizeConfig.screenWidth,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                isDaily ? dailyChips.length : weeklyChips.length,
                (index) => AmountChips(
                  isSelected: int.tryParse(amountFieldController.text) ==
                      (isDaily
                          ? dailyChips[index].value
                          : weeklyChips[index].value),
                  amount: isDaily
                      ? dailyChips[index].value
                      : weeklyChips[index].value,
                  onTap: () => onChipsTapped(isDaily
                      ? dailyChips[index].value
                      : weeklyChips[index].value),
                  isBestSeller: isDaily
                      ? dailyChips[index].best
                      : weeklyChips[index].best,
                ),
              )),
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.star,
              width: SizeConfig.iconSize3,
              height: SizeConfig.iconSize3,
            ),
            SizedBox(
              width: SizeConfig.padding4,
            ),
            Text(
              locale.additionalBenefits,
              style: TextStyles.sourceSans.body3.setOpacity(0.6),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        AutoPayBenefits(),
        SizedBox(
          height: SizeConfig.padding40,
        ),
        ReactivePositiveAppButton(
          btnText: isSetup ? locale.setUpText : locale.btnUpdate,
          onPressed: () async {
            Haptic.vibrate();
            // if (isSetup) {
            //   trackSIPSetUpEvent();
            // } else {
            //   trackSIPUpdateEvent();
            // }
            await onCtaTapped(isSetup);
            // model.setSubscriptionAmount(
            //   int.tryParse(
            //     model.amountFieldController == null ||
            //             model.amountFieldController?.text == null ||
            //             model.amountFieldController.text.isEmpty
            //         ? '0'
            //         : model.amountFieldController.text,
            //   )!
            //       .toDouble(),
            // );
            // model.pageController.jumpToPage(3);
          },
          width: SizeConfig.screenWidth! * 0.8,
        ),
        SizedBox(
          height: SizeConfig.pageHorizontalMargins,
        ),
      ],
    );
  }
}

class CenterTextField extends StatefulWidget {
  const CenterTextField({
    super.key,
    required this.amountFieldController,
    // required this.onAmountValueChanged,
    required this.isDaily,
    required this.locale,
  });

  final TextEditingController amountFieldController;
  // final Function onAmountValueChanged;
  final bool isDaily;
  final S locale;

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
                    width: fieldWidth,
                    child: TextField(
                      controller: widget.amountFieldController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: TextStyles.rajdhaniB
                          .size(SizeConfig.screenWidth! * 0.1067),
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
                              widget.amountFieldController.text.length
                                  .toDouble());
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
          ),
          Positioned(
            top: SizeConfig.screenWidth! * 0.0666,
            right: SizeConfig.screenWidth! * 0.0666,
            child: Text(
              widget.isDaily ? widget.locale.daily : widget.locale.weekly,
              style: TextStyles.sourceSans.body4.setOpacity(0.4),
            ),
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
