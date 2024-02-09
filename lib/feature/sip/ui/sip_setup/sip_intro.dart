import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/calculator_data.dart';
import 'package:felloapp/core/model/sip_model/calculator_details.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/edit_sip_bottomsheet.dart';
import 'package:felloapp/feature/sip/shared/interestCalculator.dart';
import 'package:felloapp/feature/sip/shared/sip.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_select_assset.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SipIntroView extends StatefulWidget {
  const SipIntroView({super.key});

  @override
  State<SipIntroView> createState() => _SipIntroViewState();
}

class _SipIntroViewState extends State<SipIntroView> {
  @override
  void initState() {
    context.read<SipCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async =>
              await AppState.backButtonDispatcher!.didPopRoute(),
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
        backgroundColor: UiConstants.kTextColor4,
        title: Text(locale.siptitle),
        titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<SipCubit, SipState>(
        listener: (context, state) {},
        builder: (context, state) {
          final model = context.read<SipCubit>();
          return SingleChildScrollView(
            child: switch (state) {
              ErrorSipState() => Stack(
                  children: [
                    const NewSquareBackground(),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          locale.errorLoadingSip,
                          style: TextStyles.rajdhaniSB.body0
                              .colour(UiConstants.kTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              LoadingSipData() => const Stack(
                  children: [
                    NewSquareBackground(),
                    Positioned.fill(
                      child: Center(
                        child: FullScreenLoader(),
                      ),
                    ),
                  ],
                ),
              LoadedSipData(:final showAllSip) => () {
                  int length = showAllSip
                      ? state.activeSubscription.length
                      : state.activeSubscription.length > 3
                          ? 3
                          : state.activeSubscription.length;

                  return Column(
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
                                    colors: [
                                      UiConstants.teal5,
                                      UiConstants.kTextColor4
                                    ],
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              locale.sipIntroTitle,
                                              style: TextStyles
                                                  .sourceSansSB.body1
                                                  .colour(
                                                      UiConstants.kTextColor),
                                            ),
                                            SizedBox(
                                              height: SizeConfig.padding6,
                                            ),
                                            Text(
                                              locale.sipIntroSubTitle,
                                              style: TextStyles.sourceSans.body3
                                                  .colour(UiConstants
                                                      .kWinnerPlayerPrimaryColor),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding40),
                                child: AppPositiveBtn(
                                    btnText: locale.startSip,
                                    onPressed: () {
                                      AppState.delegate!.appState
                                          .currentAction = PageAction(
                                        page: SipAssetSelectPageConfig,
                                        widget: SipAssetSelectView(
                                          isMandateAvailable:
                                              state.activeSubscription.isActive,
                                        ),
                                        state: PageState.addWidget,
                                      );
                                      context
                                          .read<SipCubit>()
                                          .onSetUpSipEventCapture(
                                            noOfSips: length,
                                            totalSipAmount: state
                                                .activeSubscription
                                                .totalSipInvestedAmount,
                                          );
                                    }),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding6,
                                ),
                                child: Text(
                                  locale.sipCustomers,
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTabBorderColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (state.activeSubscription.length != 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding24),
                                child: Text(
                                  locale.existingSip,
                                  style: TextStyles.rajdhaniSB.title5
                                      .colour(UiConstants.kTextColor),
                                ),
                              ),
                              for (int i = 0; i < length; i++) ...[
                                Column(children: [
                                  AssetSipContainer(
                                    model: model,
                                    index: i,
                                    assetType: state
                                        .activeSubscription.subs[i].assetType,
                                    state:
                                        state.activeSubscription.subs[i].status,
                                    allowEdit: !state.activeSubscription.subs[i]
                                        .assetType.isCombined,
                                    assetUrl: state.activeSubscription.subs[i]
                                            .assetType.isCombined
                                        ? Assets.goldAndflo
                                        : state.activeSubscription.subs[i]
                                                .assetType.isLendBox
                                            ? Assets.floWithoutShadow
                                            : Assets.goldWithoutShadow,
                                    nextDueDate: state
                                        .activeSubscription.subs[i].nextDue,
                                    sipAmount: state
                                        .activeSubscription.subs[i].amount
                                        .toInt(),
                                    sipName: state.activeSubscription.subs[i]
                                            .assetType.isCombined
                                        ? locale.bothassetSip
                                        : state.activeSubscription.subs[i]
                                                .assetType.isLendBox
                                            ? locale.floSip
                                            : locale.goldSip,
                                    startDate: state.activeSubscription.subs[i]
                                        .formattedStartDate,
                                    sipInterval: state
                                        .activeSubscription.subs[i].frequency,
                                    pausedSip: state.activeSubscription.subs[i]
                                        .status.isPaused,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                ]),
                              ],
                              state.activeSubscription.length > 3 &&
                                      !state.showAllSip
                                  ? TextButton(
                                      onPressed: () {
                                        model.updateSeeAll(true);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20),
                        child: SipCalculator(
                          state: state
                              .sipScreenData.calculatorScreen.calculatorData,
                        ),
                      ),
                    ],
                  );
                }(),
              _ => const SizedBox.shrink(),
            },
          );
        },
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
      required this.index,
      required this.state,
      required this.allowEdit,
      required this.assetType,
      required this.model,
      this.pausedSip,
      super.key});
  final String assetUrl;
  final String nextDueDate;
  final String startDate;
  final String sipInterval;
  final String sipName;
  final int sipAmount;
  final bool? pausedSip;
  final int index;
  final AutosaveState state;
  final bool allowEdit;
  final SIPAssetTypes assetType;
  final SipCubit model;
  final locale = locator<S>();

  void openBottomSheetOnSipPaused(BuildContext context) async {
    context.read<SipCubit>().onExistingSipCardTapEventCapture(
        assertName: sipName,
        sipAmount: sipAmount,
        sipStartingDate: startDate,
        sipNextDueDate: nextDueDate,
        actionType: actionType);
    await BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        isBarrierDismissible: true,
        enableDrag: true,
        content: EditSipBottomSheet(
          assetType: assetType,
          state: state,
          index: index,
          allowEdit: allowEdit,
          amount: sipAmount,
          model: model,
          frequency: sipInterval,
          sipReturns: SipCalculation.getReturn(
              formAmount: sipAmount,
              currentasset: assetType,
              interestOnly: true,
              frequency: sipInterval),
        ));
  }

  bool get isSipPaused => pausedSip != null && (pausedSip ?? false);
  String get sipTextIfPause => isSipPaused ? locale.pauseSip : locale.editSip;
  String get actionType {
    List<String> sipActionTypeList = sipTextIfPause.split(' ');
    if (sipActionTypeList.length > 0) {
      return sipActionTypeList[0];
    }

    return '';
  }

  Color get sipTextColorIfPause => isSipPaused
      ? UiConstants.kWinnerPlayerPrimaryColor.withOpacity(.8)
      : UiConstants.kTabBorderColor;
  String get clickToResumeTextValue =>
      isSipPaused ? locale.clickToresumeSip : nextDueDate;
  Color get clickToResumeTextColor => isSipPaused
      ? UiConstants.kTabBorderColor
      : UiConstants.kTextColor.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSipPaused
          ? () {
              openBottomSheetOnSipPaused(context);
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
                          "$sipInterval SIP started on $startDate",
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
                            assetType: assetType,
                            state: state,
                            index: index,
                            allowEdit: allowEdit,
                            amount: sipAmount,
                            model: model,
                            frequency: sipInterval,
                            sipReturns: SipCalculation.getReturn(
                                formAmount: sipAmount,
                                currentasset: assetType,
                                interestOnly: true,
                                frequency: sipInterval),
                          ));
                    },
                    child: Text(
                      sipTextIfPause,
                      style: TextStyles.sourceSans.body3
                          .colour(sipTextColorIfPause),
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
                  clickToResumeTextValue,
                  style: TextStyles.sourceSans.body4
                      .colour(clickToResumeTextColor),
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
  const SipCalculator({required this.state, super.key});
  final CalculatorData state;

  @override
  State<SipCalculator> createState() => _SipCalculatorState();
}

class _SipCalculatorState extends State<SipCalculator>
    with TickerProviderStateMixin {
  int sipAmount = 0;
  int timePeriod = 0;
  num returnPercentage = 0;
  int maxSipValue = 1;
  int minSipValue = 0;
  int maxTimePeriod = 1;
  int minTimePeriod = 0;
  int numberOfPeriodsPerYear = 1;
  final locale = locator<S>();
  void getDefaultValue(int tabIndex) {
    Map<String, CalculatorDetails> data = widget.state.data;
    List<String> sipOptions = widget.state.options;
    sipAmount = data[sipOptions[tabIndex]]!.sipAmount.defaultValue;
    maxSipValue = data[sipOptions[tabIndex]]!.sipAmount.max;
    minSipValue = data[sipOptions[tabIndex]]!.sipAmount.min;
    timePeriod = data[sipOptions[tabIndex]]!.timePeriod.defaultValue;
    maxTimePeriod = data[sipOptions[tabIndex]]!.timePeriod.max;
    minTimePeriod = data[sipOptions[tabIndex]]!.timePeriod.min;
    returnPercentage = double.parse(
        data[sipOptions[tabIndex]]!.interest['default'].toString());
    numberOfPeriodsPerYear = data[sipOptions[tabIndex]]!.numberOfPeriodsPerYear;
  }

  late final TabController tabController;
  late final List<String> sipOptions;

  @override
  void initState() {
    sipOptions = widget.state.options;
    tabController = TabController(length: sipOptions.length, vsync: this);
    getDefaultValue(tabController.index);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeTimePeriod(int value) {
    setState(() {
      if (value > maxTimePeriod) {
        timePeriod = maxTimePeriod;
      } else if (value < minTimePeriod) {
        timePeriod = minTimePeriod;
      } else {
        timePeriod = value;
      }
    });
  }

  void changeSIPAmount(int value) {
    setState(() {
      if (value > maxSipValue) {
        sipAmount = maxSipValue;
      } else if (value < minSipValue) {
        sipAmount = minSipValue;
      } else {
        sipAmount = value;
      }
    });
  }

  void changeRateOfInterest(int value) {
    setState(() {
      if (value > 30) {
        returnPercentage = 30;
      } else if (value < 0) {
        returnPercentage = 0;
      } else {
        returnPercentage = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.SipCalculator,
                style: TextStyles.rajdhaniSB.title5.colour(Colors.white)),
            Text(locale.returnsCalculator,
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
                  tabs: widget.state.options,
                  labelBuilder: (label) => label,
                  onTap: (currentTab, i) {
                    context.read<SipCubit>().onCalculatorFrequencyChanged(
                          previousFrequency: "",
                          // widget.state.options[tabController.previousIndex],
                          newFrequency: currentTab,
                        );

                    setState(() {
                      getDefaultValue(
                        i,
                      );
                    });
                  },
                ),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                requiresQuickButtons: false,
                changeFunction: changeSIPAmount,
                requiresSlider: true,
                label: locale.sipAmount,
                prefixText: "₹",
                maxValue: maxSipValue.toDouble(),
                minValue: minSipValue.toDouble(),
                value: sipAmount.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                requiresQuickButtons: false,
                changeFunction: changeTimePeriod,
                requiresSlider: true,
                label: locale.timePeriod,
                suffixText: locale.sipYear,
                maxValue: maxTimePeriod.toDouble(),
                minValue: minTimePeriod.toDouble(),
                value: timePeriod.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                  requiresQuickButtons: false,
                  requiresSlider: true,
                  textAlign: TextAlign.center,
                  label: locale.rpSip,
                  minValue: 1,
                  maxValue: 30,
                  isPercentage: true,
                  changeFunction: changeRateOfInterest,
                  value: returnPercentage.toDouble()),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.yourMoneySip(timePeriod),
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.kTextColor),
                  ),
                  Text(
                    '₹${SipCalculation.getReturn(formAmount: sipAmount, interestSelection: returnPercentage, numberOfYears: timePeriod, currentTab: tabController.index, interestOnly: false)}',
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
