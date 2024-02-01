import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/ui/pages/sip/edit_sip_bottomsheet.dart';
import 'package:felloapp/ui/pages/sip/sip.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SipIntro extends StatelessWidget {
  const SipIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AutosaveCubit>();
    var subs = model.state.activeSubscription?.subs;
    var activeSubsLength = model.state.activeSubscription?.length ?? 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Column(
                children: [
                  Container(
                    height: SizeConfig.padding436,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [UiConstants.teal5, UiConstants.kTextColor4],
                      ),
                    ),
                  ),
                  Container(
                    height: SizeConfig.padding68,
                    decoration: const BoxDecoration(
                        color: UiConstants.kSipBackgroundColor),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 53,
                          left: 40,
                          child: SizedBox(
                            width: SizeConfig.padding200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Save Weekly / Monthly  automatically & ',
                                  style: TextStyles.sourceSansSB.body1
                                      .colour(UiConstants.kTextColor),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding6,
                                ),
                                Text(
                                  'Grow money on autopilot',
                                  style: TextStyles.sourceSans.body3.colour(
                                      UiConstants.kWinnerPlayerPrimaryColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: AppImage(
                            Assets.sipIntroImage,
                            height: SizeConfig.padding300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding40),
                    child:
                        AppPositiveBtn(btnText: 'START SIP', onPressed: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding6,
                    ),
                    child: Text(
                      '8000+ users have started SIP',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTabBorderColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (activeSubsLength != 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding24),
                    child: Text(
                      'Your Existing SIP',
                      style: TextStyles.rajdhaniSB.title5
                          .colour(UiConstants.kTextColor),
                    ),
                  ),
                  for (var i = 0; i < activeSubsLength; i++) ...[
                    AssetSipContainer(
                      assetUrl: subs![i].lENDBOXP2P != 0
                          ? Assets.floWithoutShadow
                          : Assets.goldWithoutShadow,
                      nextDueDate: subs[i].nextDue!,
                      sipAmount: (subs[i].amount ?? 0).toInt(),
                      sipName: subs[i].lENDBOXP2P != 0
                          ? "Fello P2P SIP"
                          : "Digital Gold SIP",
                      startDate: subs[i].createdOn!,
                      sipInterval: subs[i].frequency!,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ],
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  BlocBuilder<AutosaveCubit, AutosaveCubitState>(
                    builder: (context, state) {
                      return SipCalculator(
                        model: state,
                      );
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AssetSipContainer extends StatelessWidget {
  const AssetSipContainer(
      {required this.assetUrl,
      required this.nextDueDate,
      required this.startDate,
      required this.sipInterval,
      required this.sipAmount,
      required this.sipName,
      super.key});
  final String assetUrl;
  final String nextDueDate;
  final String startDate;
  final String sipInterval;
  final String sipName;
  final int sipAmount;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(startDate));
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
                  AppImage(
                    assetUrl,
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
                        sipName,
                        style: TextStyles.rajdhaniSB.body2
                            .colour(UiConstants.kTextColor),
                      ),
                      Text(
                        "${sipInterval} SIP started on ${formattedDate}",
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTextColor.withOpacity(0.8)),
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
                  child: Text(
                    'Edit SIP',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTabBorderColor),
                  ))
            ],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nextDueDate,
                style: TextStyles.sourceSans.body4
                    .colour(UiConstants.kTextColor.withOpacity(0.8)),
              ),
              Text("₹${sipAmount}", style: TextStyles.sourceSansSB.body1)
            ],
          ),
        ],
      ),
    );
  }
}

class SipCalculator extends StatefulWidget {
  const SipCalculator({required this.model, super.key});
  final AutosaveCubitState model;

  @override
  State<SipCalculator> createState() => _SipCalculatorState();
}

class _SipCalculatorState extends State<SipCalculator>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
                child: TabSlider<String>(
                  controller: tabController,
                  tabs: const ['DAILY', 'WEEKLY', 'MONTHLY'],
                  labelBuilder: (label) => label,
                  onTap: (_, i) {},
                ),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                requiresQuickButtons: false,
                changeFunction: context.read<AutosaveCubit>().changeSIPAmount,
                requiresSlider: true,
                label: "SIP Amount -",
                prefixText: "₹",
                maxValue: widget.model.maxSipValue.toDouble(),
                minValue: widget.model.minSipValue.toDouble(),
                value: widget.model.sipAmount.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                requiresQuickButtons: false,
                changeFunction: context.read<AutosaveCubit>().changeTimePeriod,
                requiresSlider: true,
                label: "Time Period",
                suffixText: "Year",
                maxValue: widget.model.maxTimePeriod.toDouble(),
                minValue: widget.model.minTimePeriod.toDouble(),
                value: widget.model.timePeriod.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                  requiresQuickButtons: false,
                  requiresSlider: true,
                  textAlign: TextAlign.center,
                  label: "Return Percentage",
                  changeFunction:
                      context.read<AutosaveCubit>().changeRateOfInterest,
                  value: widget.model.returnPercentage.toDouble()),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Money in ${widget.model.timePeriod} Years",
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
                      "₹${context.read<AutosaveCubit>().getReturn()}",
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
