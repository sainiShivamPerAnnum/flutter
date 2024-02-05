import 'package:felloapp/base_util.dart';
import 'dart:math' as math;
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/edit_sip_bottomsheet.dart';
import 'package:felloapp/feature/sip/shared/sip.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SipIntro extends StatefulWidget {
  const SipIntro({super.key});

  @override
  State<SipIntro> createState() => _SipIntroState();
}

class _SipIntroState extends State<SipIntro> {
  bool _seeAll = false;

  void seeAllClicked() {
    setState(() {
      _seeAll = true;
    });
  }

  @override
  void dispose() {
    _seeAll = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AutosaveCubit>();
    var subs = model.state.activeSubscription?.subs;
    var substate = model.state.autosaveState;
    final locale = locator<S>();
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
                    child: AppPositiveBtn(
                        btnText: 'START SIP',
                        onPressed: () {
                          model.pageController.animateToPage(1,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        }),
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
                  ...List.generate(
                      _seeAll
                          ? activeSubsLength
                          : activeSubsLength > 3
                              ? 3
                              : activeSubsLength, (i) {
                    return Column(children: [
                      AssetSipContainer(
                        index: i,
                        state: substate![i],
                        allowEdit: !(subs![i].lENDBOXP2P != 0.0 &&
                            subs[i].aUGGOLD99 != 0.0),
                        assetUrl: (subs[i].lENDBOXP2P != 0.0 &&
                                subs[i].aUGGOLD99 != 0.0)
                            ? Assets.goldAndflo
                            : subs[i].lENDBOXP2P != 0
                                ? Assets.floWithoutShadow
                                : Assets.goldWithoutShadow,
                        nextDueDate: subs[i].nextDue!,
                        sipAmount: (subs[i].amount ?? 0).toInt(),
                        sipName:
                            subs[i].lENDBOXP2P != 0 && subs[i].aUGGOLD99 != 0
                                ? "Digital Gold & P2P SIP"
                                : subs[i].lENDBOXP2P != 0
                                    ? "Fello P2P SIP"
                                    : "Digital Gold SIP",
                        startDate: subs[i].createdOn!,
                        sipInterval: subs[i].frequency!,
                        pausedSip: substate[i] == AutosaveState.PAUSED,
                        model: model,
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                    ]);
                  }),
                  activeSubsLength > 3
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _seeAll = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.btnSeeAll,
                                style: TextStyles.sourceSansSB.body2
                                    .colour(Colors.white),
                              ),
                              SizedBox(
                                width: SizeConfig.padding8,
                              ),
                              Transform.rotate(
                                  angle: math.pi / 2,
                                  child: const AppImage(
                                    Assets.chevRonRightArrow,
                                    color: UiConstants.primaryColor,
                                  ))
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          BlocBuilder<AutosaveCubit, AutosaveCubitState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                child: SipCalculator(
                  model: state,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class AssetSipContainer extends StatelessWidget {
  AssetSipContainer(
      {required this.assetUrl,
      required this.nextDueDate,
      required this.startDate,
      required this.sipInterval,
      required this.sipAmount,
      required this.sipName,
      this.pausedSip,
      required this.index,
      required this.state,
      required this.model,
      required this.allowEdit,
      super.key});
  final String assetUrl;
  final String nextDueDate;
  final String startDate;
  final String sipInterval;
  final String sipName;
  final int sipAmount;
  bool? pausedSip;
  final int index;
  final AutosaveState state;
  final AutosaveCubit model;
  final bool allowEdit;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(startDate));
    return GestureDetector(
      onTap: pausedSip != null && pausedSip!
          ? () async {
              await BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  isBarrierDismissible: true,
                  enableDrag: true,
                  content: EditSipBottomSheet(
                    state: state,
                    index: index,
                    model: model,
                    allowEdit: allowEdit,
                  ));
            }
          : null,
      child: Container(
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
                    onTap: () async {
                      await BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          isBarrierDismissible: true,
                          enableDrag: true,
                          content: EditSipBottomSheet(
                            state: state,
                            index: index,
                            model: model,
                            allowEdit: allowEdit,
                          ));
                    },
                    child: pausedSip != null && pausedSip!
                        ? Text(
                            'Paused SIP',
                            style: TextStyles.sourceSans.body3.colour(
                                UiConstants.kWinnerPlayerPrimaryColor
                                    .withOpacity(.8)),
                          )
                        : Text(
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
                pausedSip != null && pausedSip!
                    ? Text(
                        'Click on card to Resume SIP',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTabBorderColor),
                      )
                    : Text(
                        nextDueDate,
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTextColor.withOpacity(0.8)),
                      ),
                Text(
                    BaseUtil.formatIndianRupees(
                        double.parse(sipAmount.toString())),
                    style: TextStyles.sourceSansSB.body1)
              ],
            ),
          ],
        ),
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
            border: Border.all(
                color: UiConstants.customBorderShadow.withOpacity(.1),
                width: 1),
            boxShadow: const [
              BoxShadow(
                color: UiConstants.kBackgroundColor,
                blurRadius: 20.0,
                offset: Offset(0, 14),
              ),
            ],
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
                  tabs: context
                          .read<AutosaveCubit>()
                          .sipScreenData
                          ?.calculatorScreen
                          ?.calculatorData
                          ?.options ??
                      ['DAILY', 'WEEKLY', 'MONTHLY'],
                  labelBuilder: (label) => label,
                  onTap: (_, i) {
                    context.read<AutosaveCubit>().tabIndex = i;
                    context.read<AutosaveCubit>().getDefaultValue(i);
                  },
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
                  minValue: 1,
                  maxValue: 30,
                  isPercentage: true,
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
                    "Your Money in ${widget.model.timePeriod} Years-",
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.kTextColor),
                  ),
                  Text(
                    BaseUtil.formatIndianRupees(double.parse(
                        context.read<AutosaveCubit>().getReturn())),
                    style: TextStyles.sourceSansSB.title5
                        .colour(UiConstants.kTabBorderColor),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding18,
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding28,
        ),
      ],
    );
  }
}
