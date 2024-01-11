import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/sip/edit_sip_bottomsheet.dart';
import 'package:felloapp/ui/pages/sip/select_sip.dart';
import 'package:felloapp/ui/pages/sip/sip_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SipScreen extends StatefulWidget {
  const SipScreen({super.key});

  @override
  State<SipScreen> createState() => _SipScreenState();
}

class _SipScreenState extends State<SipScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<SipViewModel>(onModelReady: (model) {
      model.tabController = TabController(length: 3, vsync: this);
    }, builder: (context, model, child) {
      return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.padding100,
              left: SizeConfig.padding16,
              right: SizeConfig.padding16),
          child: Column(
            children: [
              // const SipList(),
              // SizedBox(
              //   height: SizeConfig.padding28,
              // ),
              SipCalculator(
                model: model,
              )
            ],
          ),
        ),
      );
    });
  }
}

class SipList extends StatelessWidget {
  const SipList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectSipScreen()));
          },
          child: Text(
            "Your Existing SIP",
            style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        AssetSipContainer(
          sipDetails: SipDetails(
              assetUrl: Assets.floWithoutShadow,
              nextDueDate: "25 Jan 2024",
              sipAmount: 5000,
              sipName: "Fello P2P SIP",
              startDate: "25 Dec 2023",
              sipInterval: 'Weekly'),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        AssetSipContainer(
          sipDetails: SipDetails(
              assetUrl: Assets.goldWithoutShadow,
              nextDueDate: "25 Jan 2024",
              sipAmount: 10000,
              sipName: "Digital Gold SIP",
              startDate: "25 Dec 2023",
              sipInterval: 'Weekly'),
        ),
      ],
    );
  }
}

class SipCalculator extends StatelessWidget {
  const SipCalculator({super.key, required this.model});
  final SipViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("SIP Calculator",
                style: TextStyles.rajdhaniSB.title5.colour(Colors.white)),
            Text("Calculate your SIP returns",
                style:
                    TextStyles.rajdhaniSB.body3.colour(UiConstants.textGray70))
          ],
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: UiConstants.kDarkBoxColor,
          ),
          padding: EdgeInsets.only(
              top: SizeConfig.padding16,
              left: SizeConfig.padding16,
              right: SizeConfig.padding16),
          child: Column(
            children: [
              Container(
                width: SizeConfig.padding300,
                height: SizeConfig.padding35,
                padding: EdgeInsets.all(SizeConfig.padding3),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.roundness16)),
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                          controller: model.tabController,
                          padding: EdgeInsets.zero,
                          labelStyle: TextStyles.sourceSansSB.body3,
                          labelColor: Colors.white,
                          unselectedLabelStyle: TextStyles.sourceSansSB.body3,
                          unselectedLabelColor: Colors.white,
                          labelPadding: EdgeInsets.zero,
                          indicator: BoxDecoration(
                            color: UiConstants.teal3,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                          ),
                          tabs: const [
                            Tab(
                              text: "DAILY",
                            ),
                            Tab(
                              text: "WEEKLY",
                            ),
                            Tab(
                              text: "MONTHLY",
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                changeFunction: model.changeSIPAmount,
                requiresSlider: true,
                label: "SIP Amount -",
                prefixText: "₹",
                maxValue: model.maxSipValue.toDouble(),
                minValue: model.minSipValue.toDouble(),
                value: model.sipAmount.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                changeFunction: model.changeTimePeriod,
                requiresSlider: true,
                label: "Time Period",
                suffixText: "Year",
                maxValue: model.maxTimePeriod.toDouble(),
                minValue: model.minTimePeriod.toDouble(),
                value: model.timePeriod.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                  requiresSlider: false,
                  label: "Return Percentage",
                  value: model.returnPercentage),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Money in ${model.timePeriod} Years",
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.textGray70),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: UiConstants.kDividerColor),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding6,
                        horizontal: SizeConfig.padding35),
                    child: Text(
                      "₹${model.getReturn()}",
                      style: TextStyles.sourceSansSB.body1.colour(Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding28,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CalculatorField extends StatelessWidget {
  const CalculatorField(
      {super.key,
      required this.requiresSlider,
      required this.label,
      this.prefixText,
      this.suffixText,
      this.changeFunction,
      this.maxValue,
      this.minValue,
      required this.value});
  final Function(int)? changeFunction;
  final bool requiresSlider;
  final String label;
  final String? prefixText;
  final String? suffixText;
  final double? maxValue;
  final double? minValue;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  TextStyles.sourceSansSB.body2.colour(UiConstants.textGray70),
            ),
            Container(
              width: SizeConfig.padding100,
              padding: EdgeInsets.only(
                  top: SizeConfig.padding8,
                  left: SizeConfig.padding12,
                  right: SizeConfig.padding12,
                  bottom: SizeConfig.padding8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
              child: TextField(
                controller: TextEditingController(
                    text: SipViewModel.formatValue(value.toDouble())),
                textDirection: prefixText != null ? TextDirection.rtl : null,
                keyboardType: TextInputType.number,
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                onSubmitted: (value) {
                  changeFunction!(int.parse(value));
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    prefixIcon: prefixText != null
                        ? Text(
                            prefixText!,
                            style: TextStyles.sourceSansSB.body2.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor),
                          )
                        : null,
                    suffixIcon: suffixText != null
                        ? Text(
                            suffixText!,
                            style: TextStyles.sourceSansSB.body2.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor),
                          )
                        : null,
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    prefixStyle:
                        TextStyles.sourceSansSB.body2.colour(Colors.white)),
              ),
            )
          ],
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        if (requiresSlider)
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 1,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: SizeConfig.roundness8,
                )),
            child: Slider(
              value: value,
              max: maxValue ?? 1,
              min: minValue ?? 0,
              onChanged: (value) {
                changeFunction!(value.toInt());
              },
              thumbColor: Colors.white,
              activeColor: UiConstants.teal3,
              inactiveColor: Colors.white,
            ),
          )
      ],
    );
  }
}

class AssetSipContainer extends StatelessWidget {
  const AssetSipContainer({super.key, required this.sipDetails});
  final SipDetails sipDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: UiConstants.kArrowButtonBackgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness8)),
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    sipDetails.assetUrl,
                    height: SizeConfig.padding40,
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sipDetails.sipName,
                        style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
                      ),
                      Text(
                        "${sipDetails.sipInterval}SIP started on ${sipDetails.startDate}",
                        style: TextStyles.sourceSans.body4,
                      )
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  BaseUtil.openModalBottomSheet(
                      isBarrierDismissible: true,
                      enableDrag: true,
                      content: const EditSipBottomSheet());
                },
                child: SvgPicture.asset(
                  Assets.normalChevronRightArrow,
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Next Due Date on ${sipDetails.nextDueDate}",
                style: TextStyles.sourceSans.body4,
              ),
              Text("₹${sipDetails.sipAmount}",
                  style: TextStyles.sourceSansSB.body1)
            ],
          ),
        ],
      ),
    );
  }
}
