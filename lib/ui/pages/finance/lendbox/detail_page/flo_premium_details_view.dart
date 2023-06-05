// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/user_service/lendbox_principle_value.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FloPremiumDetailsView extends StatefulWidget {
  final bool is12;
  const FloPremiumDetailsView({super.key, required this.is12});

  @override
  State<FloPremiumDetailsView> createState() => _FloPremiumDetailsViewState();
}

class _FloPremiumDetailsViewState extends State<FloPremiumDetailsView>
    with SingleTickerProviderStateMixin {
  ScrollController? controller;

  AnimationController? _animController;
  Animation<double>? offsetAnim;
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });

    offsetAnim = CurvedAnimation(
        curve: Curves.easeInCubic,
        parent: _animController!,
        reverseCurve: Curves.decelerate);
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller?.dispose();
    _animController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FloPremiumDetailsViewModel>(
      onModelReady: (model) => model.init(widget.is12),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, _) {
        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: () async {
            // await state.refreshTransactions(widget.type);
            await model.getTransactions();
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              color: UiConstants.kBackgroundColor,
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight! * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            UiConstants.kFloContainerColor,
                            const Color(0xff297264).withOpacity(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight * 0.8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              children: [
                                Transform.translate(
                                  offset:
                                      Offset(0, -1 * offsetAnim!.value * 50),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(seconds: 2),
                                    child: model.is12
                                        ? Column(
                                            children: [
                                              FloPremiumHeader(
                                                  key: const ValueKey(
                                                      "12floHeader"),
                                                  model: model),
                                              SizedBox(
                                                  height: SizeConfig.padding32),
                                              if (model.isInvested)
                                                const FloBalanceBriefRow(
                                                  key: ValueKey("10floBalance"),
                                                  tier: Constants
                                                      .ASSET_TYPE_FLO_FIXED_6,
                                                ),
                                              if (model.isInvested)
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding16),
                                              FloPremiumTransactionsList(
                                                  key: ValueKey("12floTxns"),
                                                  model: model),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              FloPremiumHeader(
                                                  key: const ValueKey(
                                                      "10floHeader"),
                                                  model: model),
                                              SizedBox(
                                                  height: SizeConfig.padding32),
                                              if (model.isInvested)
                                                const FloBalanceBriefRow(
                                                  key: ValueKey("10floBalance"),
                                                  tier: Constants
                                                      .ASSET_TYPE_FLO_FIXED_3,
                                                ),
                                              if (model.isInvested)
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding16),
                                              FloPremiumTransactionsList(
                                                key: ValueKey("10floTxns"),
                                                model: model,
                                              ),
                                            ],
                                          ),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding16),
                                  child: Text(
                                    "100% Safe & Secure with Fello",
                                    style: TextStyles.rajdhaniSB.title4
                                        .colour(Colors.white),
                                  ),
                                ),
                                const SaveAssetsFooter(isFlo: true),
                                SizedBox(
                                    height: SizeConfig.pageHorizontalMargins),
                                CircularSlider(
                                    type: InvestmentType.LENDBOXP2P,
                                    isNewUser: false,
                                    interest: model.is12 ? 12 : 10),
                                SizedBox(
                                    height: SizeConfig.pageHorizontalMargins),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding16),
                                  child: Text(
                                    "Frequently Asked Questions",
                                    style: TextStyles.rajdhaniSB.title4
                                        .colour(Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth,
                                  child: Column(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                            brightness: Brightness.dark),
                                        child: ExpansionPanelList(
                                          animationDuration:
                                              const Duration(milliseconds: 600),
                                          expandedHeaderPadding:
                                              const EdgeInsets.all(0),
                                          dividerColor: UiConstants
                                              .kDividerColor
                                              .withOpacity(0.3),
                                          elevation: 0,
                                          children: List.generate(
                                            model.faqHeaders.length,
                                            (index) => ExpansionPanel(
                                              backgroundColor:
                                                  Colors.transparent,
                                              canTapOnHeader: true,
                                              headerBuilder: (ctx, isOpen) =>
                                                  Padding(
                                                padding: EdgeInsets.only(
                                                  top: SizeConfig.padding20,
                                                  left: SizeConfig
                                                      .pageHorizontalMargins,
                                                  bottom: SizeConfig.padding20,
                                                ),
                                                child: Text(
                                                    model.faqHeaders[index] ??
                                                        "",
                                                    style: TextStyles
                                                        .sourceSans.body2
                                                        .colour(Colors.white)),
                                              ),
                                              isExpanded:
                                                  model.detStatus[index],
                                              body: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: SizeConfig
                                                        .pageHorizontalMargins),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    model.faqResponses[index]!,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyles.body3
                                                        .colour(UiConstants
                                                            .kFAQsAnswerColor)),
                                              ),
                                            ),
                                          ),
                                          expansionCallback: (i, isOpen) {
                                            model.updateDetStatus(i, !isOpen);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: UiConstants.kSaveStableFelloCardBg,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  margin: EdgeInsets.all(
                                      SizeConfig.pageHorizontalMargins),
                                  padding: EdgeInsets.all(
                                      SizeConfig.pageHorizontalMargins),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Still not convinced?",
                                        style: TextStyles.rajdhaniSB.title5,
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Know more about the P2P Asset by talking to us",
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: SizeConfig.padding10),
                                          OutlinedButton(
                                            onPressed: () {
                                              Haptic.vibrate();
                                              AppState.delegate!.appState
                                                  .currentAction = PageAction(
                                                state: PageState.addPage,
                                                page: FreshDeskHelpPageConfig,
                                              );
                                            },
                                            style: ButtonStyle(
                                                side: MaterialStateProperty.all(
                                                    const BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                        style: BorderStyle
                                                            .solid))),
                                            child: Text(
                                              "CONTACT US",
                                              style: TextStyles.rajdhaniB.body2
                                                  .colour(Colors.white),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.navBarHeight * 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: UiConstants.kBackgroundColor.withOpacity(0.96),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenWidth! * 0.24 +
                          MediaQuery.of(context).viewPadding.bottom / 2,
                      child: Stack(
                        children: [
                          if (model.is12)
                            SvgPicture.asset(
                              Assets.btnBg,
                              fit: BoxFit.cover,
                              width: SizeConfig.screenWidth! * 1.5,
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: SizeConfig.padding6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.floAsset,
                                    height: SizeConfig.screenHeight! * 0.03,
                                    width: SizeConfig.screenHeight! * 0.03,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding4),
                                    child: Text(
                                      DynamicUiUtils.ctaText.LENDBOXP2P ?? "",
                                      style: TextStyles.sourceSans.body4.colour(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                width: SizeConfig.screenWidth!,
                                child: Row(
                                  children: [
                                    if (!model.is12)
                                      Expanded(
                                        child: SizedBox(
                                          height: SizeConfig.padding44,
                                          child: OutlinedButton(
                                              style: ButtonStyle(
                                                  side:
                                                      MaterialStateProperty.all(
                                                          const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid))),
                                              child: Text(
                                                "UPGRADE TO 12%",
                                                style: TextStyles
                                                    .rajdhaniSB.body2
                                                    .colour(Colors.white),
                                              ),
                                              onPressed: () async {
                                                Haptic.vibrate();
                                                await controller
                                                    ?.animateTo(0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        curve:
                                                            Curves.decelerate)
                                                    .then((_) {
                                                  _animController!
                                                      .forward()
                                                      .then((value) {
                                                    model
                                                        .cleanTransactionsList();
                                                    _animController!.reverse();
                                                    model.is12 = true;

                                                    model.getTransactions();
                                                  });
                                                });
                                              }),
                                        ),
                                      ),
                                    if (!model.is12)
                                      SizedBox(width: SizeConfig.padding12),
                                    Expanded(
                                      child: MaterialButton(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.roundness5),
                                          ),
                                          height: SizeConfig.padding44,
                                          child: Text(
                                            "SAVE",
                                            style: TextStyles.rajdhaniB.body2
                                                .colour(Colors.black),
                                          ),
                                          onPressed: () {
                                            BaseUtil.openFloBuySheet(
                                              floAssetType: model.is12
                                                  ? Constants
                                                      .ASSET_TYPE_FLO_FIXED_6
                                                  : Constants
                                                      .ASSET_TYPE_FLO_FIXED_3,
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: SizeConfig.padding8),
                          child: const FaqPill(
                            type: FaqsType.savings,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloPremiumHeader extends StatelessWidget {
  final FloPremiumDetailsViewModel model;
  const FloPremiumHeader({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fello Flo Premium",
                    style: TextStyles.rajdhaniSB.title4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: UiConstants.primaryColor.withOpacity(0.95),
                              blurRadius: 50,
                            )
                          ],
                        ),
                        child: Text(
                          model.is12 ? "12% Flo" : "10% Flo",
                          style: TextStyles.rajdhaniB.title0.colour(
                            model.is12
                                ? UiConstants.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
              SvgPicture.asset(
                Assets.floAsset,
                height: SizeConfig.screenHeight! * 0.1,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding10),
          Text(
            model.is12 ? model.flo12Highlights : model.flo10Highlights,
            style: TextStyles.sourceSans.body2.colour(UiConstants.primaryColor),
          ),
          SizedBox(height: SizeConfig.padding4),
          Text(
            model.is12 ? model.flo12Description : model.flo10Description,
            style: TextStyles.sourceSans.body2.colour(Colors.white54),
          ),
        ],
      ),
    );
  }
}

class FloPremiumTransactionsList extends StatelessWidget {
  FloPremiumDetailsViewModel model;
  FloPremiumTransactionsList({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.transactionsList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            String formattedInvestmentDate = DateFormat('dd MMM, yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(model
                    .transactionsList[i].timestamp!.millisecondsSinceEpoch));

            String formattedMaturityDate = DateFormat('dd MMM, yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(model.transactionsList[i]
                    .lbMap.maturityAt!.millisecondsSinceEpoch));

            double currentValue = BaseUtil.digitPrecision(
                model.transactionsList[i].amount +
                    (model.transactionsList[i].lbMap.gainAmount ?? 0));

            double gain = BaseUtil.digitPrecision(
                model.transactionsList[i].lbMap.gainAmount ?? 0, 2, false);

            bool hasUserDecided =
                model.transactionsList[i].lbMap.maturityPref != "NA";
            String userMaturityPref = BaseUtil.getMaturityPref(
                model.transactionsList[i].lbMap.maturityPref ?? "NA");

            return (model.transactionsList[i].lbMap.fundType ?? "").isNotEmpty
                ? InkWell(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.delegate!.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: TransactionDetailsPageConfig,
                        widget: TransactionDetailsPage(
                          txn: model.transactionsList[i],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness16),
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding10),
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.padding12,
                            bottom: SizeConfig.padding12,
                            left: SizeConfig.pageHorizontalMargins,
                            right: SizeConfig.padding12,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Invested on",
                                        style: TextStyles.body3.colour(
                                            UiConstants.kTextFieldTextColor),
                                      ),
                                      FloPremiumTierChip(
                                        value: formattedInvestmentDate,
                                      )
                                    ],
                                  ),
                                  SizedBox(width: SizeConfig.padding16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Matures on",
                                        style: TextStyles.body3.colour(
                                            UiConstants.kTextFieldTextColor),
                                      ),
                                      FloPremiumTierChip(
                                        value: formattedMaturityDate,
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: UiConstants.kTextFieldTextColor,
                                  )
                                ],
                              ),
                              SizedBox(height: SizeConfig.padding16),
                              FloBalanceBriefRow(
                                lead: currentValue,
                                trail: currentValue - gain,
                                percent: (gain / currentValue) * 100,
                                leftAlign: true,
                                tier: model.is12
                                    ? Constants.ASSET_TYPE_FLO_FIXED_6
                                    : Constants.ASSET_TYPE_FLO_FIXED_3,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding16,
                            horizontal: SizeConfig.padding16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness16),
                                bottomRight:
                                    Radius.circular(SizeConfig.roundness16)),
                          ),
                          alignment: Alignment.center,
                          child: hasUserDecided
                              ? Text(
                                  userMaturityPref,
                                  style: TextStyles.sourceSans.body2,
                                )
                              : Row(children: [
                                  Expanded(
                                    child: Text(
                                      userMaturityPref,
                                      style: TextStyles.sourceSans.body2,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding10),
                                  MaterialButton(
                                    onPressed: () {
                                      BaseUtil.openModalBottomSheet(
                                        isBarrierDismissible: false,
                                        addToScreenStack: true,
                                        hapticVibrate: true,
                                        isScrollControlled: true,
                                        content: MaturityPrefModalSheet(
                                          amount: "${currentValue - gain}",
                                          txnId:
                                              model.transactionsList[i].docKey!,
                                          assetType: model.is12
                                              ? Constants.ASSET_TYPE_FLO_FIXED_6
                                              : Constants
                                                  .ASSET_TYPE_FLO_FIXED_3,
                                        ),
                                      ).then(
                                          (value) => model.getTransactions());
                                    },
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness5),
                                    ),
                                    child: Text(
                                      "CHOOSE",
                                      style: TextStyles.rajdhaniB.body2
                                          .colour(Colors.black),
                                    ),
                                  )
                                ]),
                        )
                      ]),
                    ),
                  )
                : const SizedBox();
          }),
    );
  }
}

class LBoxAssetCard extends StatelessWidget {
  const LBoxAssetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        color: UiConstants.kSaveStableFelloCardBg,
      ),
      padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins / 2,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(-SizeConfig.padding12, -SizeConfig.padding40),
            child: Image.asset(
              Assets.felloFlo,
              height: SizeConfig.screenWidth! * 0.32,
              width: SizeConfig.screenWidth! * 0.32,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: SizeConfig.screenWidth! * 0.35),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.felloFloText,
                            style: TextStyles.rajdhaniB.title2),
                        Text(locale.felloFloSubTitle,
                            style: TextStyles.sourceSans.body4),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    top: SizeConfig.padding35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LendboxPrincipleValue(
                            prefix: "\u20b9",
                            style: TextStyles.rajdhaniSB.title4,
                          ),
                          SizedBox(
                            height: SizeConfig.padding2,
                          ),
                          Text(
                            locale.invested,
                            style: TextStyles.sourceSans.body3.colour(
                              UiConstants.kTextColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserFundQuantitySE(
                            style: TextStyles.rajdhaniSB.title4,
                            investmentType: InvestmentType.LENDBOXP2P,
                          ),
                          SizedBox(
                            height: SizeConfig.padding2,
                          ),
                          Row(
                            children: [
                              Text(
                                locale.currentText,
                                style: TextStyles.sourceSans.body3.colour(
                                    UiConstants.kTextColor.withOpacity(0.8)),
                              ),
                              SizedBox(width: SizeConfig.padding4),
                              LboxGrowthArrow()
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
