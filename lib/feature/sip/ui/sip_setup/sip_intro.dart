import 'dart:math' as math;
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/calculator_details.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_handler.dart';
import 'package:felloapp/feature/sip/shared/edit_sip_bottomsheet.dart';
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

class SipIntroView extends StatelessWidget {
  const SipIntroView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AutosaveCubit(),
      child: const SipIntro(),
    );
  }
}

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
  void initState() {
    final model = context.read<AutosaveCubit>();
    model.init();
    super.initState();
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
    final locale = locator<S>();
    var activeSubsLength = model.state.activeSubscription?.length ?? 0;
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
      body: SingleChildScrollView(
        child: model.state.isFetchingDetails
            ? const Stack(
                children: [
                  NewSquareBackground(),
                  Positioned.fill(
                    child: Center(
                      child: FullScreenLoader(),
                    ),
                  ),
                ],
              )
            : Column(
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
                                          style: TextStyles.sourceSansSB.body1
                                              .colour(UiConstants.kTextColor),
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
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                    page: SipAssetSelectPageConfig,
                                    widget: const SipAssetSelectView(),
                                    state: PageState.addWidget,
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
                  if (activeSubsLength != 0)
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
                          ...List.generate(
                              _seeAll
                                  ? activeSubsLength
                                  : activeSubsLength > 3
                                      ? 3
                                      : activeSubsLength, (i) {
                            return Column(children: [
                              AssetSipContainer(
                                index: i,
                                assetType: subs![i].assetType,
                                state: subs[i].status,
                                allowEdit:
                                    subs[i].assetType != SIPAssetTypes.BOTH,
                                assetUrl: (subs[i].lENDBOXP2P != 0.0 &&
                                        subs[i].aUGGOLD99 != 0.0)
                                    ? Assets.goldAndflo
                                    : subs[i].lENDBOXP2P != 0
                                        ? Assets.floWithoutShadow
                                        : Assets.goldWithoutShadow,
                                nextDueDate: subs[i].nextDue,
                                sipAmount: subs[i].amount.toInt(),
                                sipName: subs[i].lENDBOXP2P != 0 &&
                                        subs[i].aUGGOLD99 != 0
                                    ? locale.bothassetSip
                                    : subs[i].lENDBOXP2P != 0
                                        ? locale.floSip
                                        : locale.goldSip,
                                startDate: subs[i].createdOn,
                                sipInterval: subs[i].frequency,
                                pausedSip: subs[i].status.isPaused,
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                    child: SipCalculator(
                      state: model.state,
                    ),
                  ),
                ],
              ),
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
      required this.model,
      required this.allowEdit,
      required this.assetType,
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
  final AutosaveCubit model;
  final bool allowEdit;
  final SIPAssetTypes assetType;
  final locale = locator<S>();

  int calculateMaturityValue(
      double principal, double interest, int numberOfInvestments) {
    double compoundInterest =
        ((pow(1 + interest, numberOfInvestments) - 1) / interest) *
            (1 + interest);
    double M = principal * compoundInterest;
    return M.round();
  }

  String getReturn() {
    int numberOfPeriods = SipDataHolder.instance.data.amountSelectionScreen
            ?.data?[sipInterval]?.numberOfPeriodsPerYear ??
        1;

    double? interest = SipDataHolder.instance.data.selectAssetScreen?.options
        ?.where((element) => element.type == assetType)
        .first
        .interest!
        .toDouble();
    double interestRate = (interest! * .001) / numberOfPeriods;
    int numberOfYear = 5;

    int numberOfInvestments = numberOfYear * numberOfPeriods;
    final maturityValue = calculateMaturityValue(
        sipAmount.toDouble(), interestRate, numberOfInvestments);
    final totalInterest = maturityValue - sipAmount;
    return BaseUtil.formatRupees(double.parse(totalInterest.toString()));
  }

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
                    assetType: assetType,
                    state: state,
                    index: index,
                    model: model,
                    allowEdit: allowEdit,
                    amount: sipAmount,
                    frequency: sipInterval,
                    sipReturns: getReturn(),
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
                          "$sipInterval SIP started on $formattedDate",
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
                            model: model,
                            allowEdit: allowEdit,
                            amount: sipAmount,
                            frequency: sipInterval,
                            sipReturns: getReturn(),
                          ));
                    },
                    child: pausedSip != null && pausedSip!
                        ? Text(
                            locale.pauseSip,
                            style: TextStyles.sourceSans.body3.colour(
                                UiConstants.kWinnerPlayerPrimaryColor
                                    .withOpacity(.8)),
                          )
                        : Text(
                            locale.editSip,
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
                        locale.clickToresumeSip,
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
  const SipCalculator({required this.state, super.key});
  final AutosaveCubitState state;

  @override
  State<SipCalculator> createState() => _SipCalculatorState();
}

class _SipCalculatorState extends State<SipCalculator>
    with TickerProviderStateMixin {
  int? sipAmount;
  int? timePeriod;
  num? returnPercentage;
  int? maxSipValue;
  int? minSipValue;
  int? maxTimePeriod;
  int? minTimePeriod;
  int? numberOfPeriodsPerYear;
  final locale = locator<S>();
  void getDefaultValue(int tabIndex) {
    Map<String, CalculatorDetails>? data =
        widget.state.sipScreenData?.calculatorScreen?.calculatorData?.data;
    dynamic sipOptions =
        widget.state.sipScreenData?.calculatorScreen?.calculatorData?.options;
    sipAmount = data?['${sipOptions[tabIndex]}']?.sipAmount?.defaultValue ?? 0;
    maxSipValue = data?['${sipOptions[tabIndex]}']?.sipAmount?.max ?? 0;
    minSipValue = data?['${sipOptions[tabIndex]}']?.sipAmount?.min ?? 0;
    timePeriod =
        data?['${sipOptions[tabIndex]}']?.timePeriod?.defaultValue ?? 0;
    maxTimePeriod = data?['${sipOptions[tabIndex]}']?.timePeriod?.max ?? 0;
    minTimePeriod = data?['${sipOptions[tabIndex]}']?.timePeriod?.min ?? 0;
    returnPercentage = double.parse(
        data?['${sipOptions[tabIndex]}']?.interest?['default'].toString() ??
            '0');
    numberOfPeriodsPerYear =
        data?['${sipOptions[tabIndex]}']?.numberOfPeriodsPerYear ?? 12;
  }

  TabController? tabController;

  @override
  void initState() {
    dynamic sipOptions =
        widget.state.sipScreenData?.calculatorScreen?.calculatorData?.options;
    tabController = TabController(length: sipOptions.length, vsync: this);
    getDefaultValue(tabController!.index);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  int calculateMaturityValue(
      double principal, double interest, int numberOfInvestments) {
    double compoundInterest =
        ((pow(1 + interest, numberOfInvestments) - 1) / interest) *
            (1 + interest);
    double M = principal * compoundInterest;
    return M.round();
  }

  String getReturn() {
    double principalAmount = sipAmount!.toDouble();
    int numberOfPeriods = numberOfPeriodsPerYear!;
    double interest = returnPercentage!.toDouble();
    double interestRate = (interest * .001) / numberOfPeriods;
    int numberOfYear = timePeriod!;

    int numberOfInvestments = numberOfYear * numberOfPeriods;
    final maturityValue = calculateMaturityValue(
        principalAmount, interestRate, numberOfInvestments);
    return maturityValue.toString();
  }

  void changeTimePeriod(int value) {
    setState(() {
      if (value > maxTimePeriod!) {
        timePeriod = maxTimePeriod;
      } else if (value < minTimePeriod!) {
        timePeriod = minTimePeriod;
      } else {
        timePeriod = value;
      }
    });
  }

  void changeSIPAmount(int value) {
    setState(() {
      if (value > maxSipValue!) {
        sipAmount = maxSipValue;
      } else if (value < minSipValue!) {
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
                  tabs: widget.state.sipScreenData?.calculatorScreen
                          ?.calculatorData?.options ??
                      ['DAILY', 'WEEKLY', 'MONTHLY'],
                  labelBuilder: (label) => label,
                  onTap: (_, i) {
                    setState(() {
                      getDefaultValue(i);
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
                maxValue: maxSipValue!.toDouble(),
                minValue: minSipValue!.toDouble(),
                value: sipAmount!.toDouble(),
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              CalculatorField(
                requiresQuickButtons: false,
                changeFunction: changeTimePeriod,
                requiresSlider: true,
                label: locale.timePeriod,
                suffixText: "Year",
                maxValue: maxTimePeriod!.toDouble(),
                minValue: minTimePeriod!.toDouble(),
                value: timePeriod!.toDouble(),
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
                  value: returnPercentage!.toDouble()),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.yourMoneySip(timePeriod!),
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.kTextColor),
                  ),
                  Text(
                    BaseUtil.formatIndianRupees(double.parse(getReturn())),
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
