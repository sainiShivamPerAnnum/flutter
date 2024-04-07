import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlexiTransactionsSection extends StatefulWidget {
  const FlexiTransactionsSection({
    required this.model,
    required this.fundType,
    super.key,
  });

  final FloPremiumDetailsViewModel model;
  final FundType fundType;

  @override
  State<FlexiTransactionsSection> createState() =>
      _FlexiTransactionsSectionState();
}

class _FlexiTransactionsSectionState extends State<FlexiTransactionsSection> {
  bool _seeAll = false;

  @override
  void dispose() {
    _seeAll = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.padding16,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xFF013B3F),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFF326164),
          ),
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
            ),
            child: FloBalanceBriefRow(
              tier: widget.fundType.name,
              mini: true,
              endAlign: true,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16,
            ),
            child: FloPremiumTransactionsList(
              model: widget.model,
              seeAll: _seeAll,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          if (widget.model.transactionsList.length > 2)
            GestureDetector(
              onTap: () => setState(() => _seeAll = !_seeAll),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(SizeConfig.roundness16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _seeAll
                          ? 'View less Investments'
                          : 'View more Investments',
                      style: TextStyles.sourceSansSB.body2.colour(
                        Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding4,
                    ),
                    Icon(
                      _seeAll
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                      size: SizeConfig.padding28,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class FloPremiumTransactionsList extends StatefulWidget {
  final FloPremiumDetailsViewModel model;
  final bool seeAll;

  const FloPremiumTransactionsList({
    required this.model,
    required this.seeAll,
    super.key,
  });

  @override
  State<FloPremiumTransactionsList> createState() =>
      _FloPremiumTransactionsListState();
}

class _FloPremiumTransactionsListState
    extends State<FloPremiumTransactionsList> {
  late LendboxMaturityService _lendboxMaturityService;
  bool showChangeCTA =
      AppConfig.getValue(AppConfigKey.canChangePostMaturityPreference);

  void trackTransactionCardTap(
    double currentAmount,
    double investedAmount,
    String maturityDate,
  ) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.depositCardInFloSlabTapped,
      properties: {
        "asset name": "${widget.model.config.interest}% Flo",
        "new user": locator<UserService>().userSegments.contains(
              Constants.NEW_USER,
            ),
        "invested amount": investedAmount,
        "current amount": currentAmount,
        "maturity date": maturityDate
      },
    );
  }

  void trackDecideButtonTap(
    double currentAmount,
    double investedAmount,
    String maturityDate,
  ) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.decideOnDepositCardTapped,
      properties: {
        "asset name": "${widget.model.config.interest}% Flo",
        "new user": locator<UserService>().userSegments.contains(
              Constants.NEW_USER,
            ),
        "invested amount": investedAmount,
        "current amount": currentAmount,
        "maturity date": maturityDate
      },
    );
  }

  int getLength() {
    final length = widget.model.transactionsList.length;
    return length > 2 && !widget.seeAll ? 2 : length;
  }

  @override
  void initState() {
    super.initState();
    _lendboxMaturityService = locator<LendboxMaturityService>();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LendboxMaturityService, List<Deposit>?>(
      selector: (context, data) => data.filteredDeposits,
      builder: (context, filteredDeposits, child) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: getLength(),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              String formattedInvestmentDate =
                  DateFormat('dd MMM, yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                  widget.model.transactionsList[i].timestamp!
                      .millisecondsSinceEpoch,
                ),
              );

              String formattedMaturityDate = DateFormat('dd MMM, yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                  widget.model.transactionsList[i].lbMap.maturityAt!
                      .millisecondsSinceEpoch,
                ),
              );

              double currentValue = BaseUtil.digitPrecision(
                widget.model.transactionsList[i].amount +
                    (widget.model.transactionsList[i].lbMap.gainAmount ?? 0),
                2,
              );

              double principleValue = BaseUtil.digitPrecision(
                widget.model.transactionsList[i].amount,
                2,
              );

              double gain = BaseUtil.digitPrecision(
                widget.model.transactionsList[i].lbMap.gainAmount ?? 0,
                2,
                false,
              );

              bool hasUserDecided =
                  widget.model.transactionsList[i].lbMap.maturityPref != "NA";
              String userMaturityPref = BaseUtil.getMaturityPref(
                widget.model.transactionsList[i].lbMap.maturityPref ?? "NA",
                widget.key == const ValueKey('10floTxns'),
              );
              bool showNeedHelp =
                  widget.model.transactionsList[i].lbMap.hasDecidedPref ??
                      false;

              log("qwerty => ${widget.model.transactionsList[i].lbMap.hasDecidedPref}");

              bool showConfirm = (filteredDeposits?.isNotEmpty ?? false) &&
                  filteredDeposits!.any(
                    (element) =>
                        element.txnId ==
                            widget.model.transactionsList[i].docKey &&
                        (element.hasConfirmed ?? true) == false,
                  );

              log("filteredDeposits => ${filteredDeposits?.length}");

              Deposit? depositData = filteredDeposits?.firstWhere(
                (element) =>
                    element.txnId == widget.model.transactionsList[i].docKey,
                orElse: Deposit.new,
              );

              log("depositData => ${depositData?.decisionMade}");

              log("showNeedHelp: $showNeedHelp || showConfirm: $showConfirm");
              return (widget.model.transactionsList[i].lbMap.fundType ?? "")
                      .isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Haptic.vibrate();
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: TransactionDetailsPageConfig,
                          widget: TransactionDetailsPage(
                            txn: widget.model.transactionsList[i],
                          ),
                        );
                        trackTransactionCardTap(
                          currentValue,
                          currentValue - gain,
                          formattedMaturityDate,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                        ),
                        margin: EdgeInsets.only(
                          //     horizontal: SizeConfig.pageHorizontalMargins,
                          bottom: SizeConfig.padding16,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.padding12,
                                bottom: SizeConfig.padding12,
                                left: SizeConfig.padding12,
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
                                              UiConstants.kTextFieldTextColor,
                                            ),
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
                                              UiConstants.kTextFieldTextColor,
                                            ),
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
                                    trail: principleValue,
                                    percent: (gain / principleValue) * 100,
                                    leftAlign: true,
                                    tier: widget.model.config.fundType.name,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding8,
                                horizontal: SizeConfig.padding16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(SizeConfig.roundness16),
                                  bottomRight: Radius.circular(
                                    SizeConfig.roundness16,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      userMaturityPref,
                                      style: TextStyles.sourceSans.body3,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding10),
                                  if (showChangeCTA)
                                    MaterialButton(
                                      elevation:
                                          (showNeedHelp || showConfirm) ? 0 : 2,
                                      onPressed: () {
                                        Haptic.vibrate();

                                        log('showNeedHelp: $showNeedHelp');

                                        if (showNeedHelp) {
                                          AppState.delegate!.appState
                                              .currentAction = PageAction(
                                            state: PageState.addPage,
                                            page: FreshDeskHelpPageConfig,
                                          );
                                        } else if (showConfirm &&
                                            depositData != null &&
                                            depositData != Deposit()) {
                                          BaseUtil.openModalBottomSheet(
                                            addToScreenStack: true,
                                            enableDrag: false,
                                            hapticVibrate: true,
                                            isBarrierDismissible: false,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            content: ReInvestmentSheet(
                                              decision: _lendboxMaturityService
                                                  .setDecision(
                                                depositData.decisionMade ?? "3",
                                              ),
                                              depositData: depositData,
                                            ),
                                          );
                                        } else {
                                          BaseUtil.openModalBottomSheet(
                                            isBarrierDismissible: false,
                                            addToScreenStack: true,
                                            hapticVibrate: true,
                                            isScrollControlled: true,
                                            content: MaturityPrefModalSheet(
                                              amount: "${currentValue - gain}",
                                              txnId: widget.model
                                                  .transactionsList[i].docKey!,
                                              assetType: widget
                                                  .model.config.fundType.name,
                                            ),
                                          ).then(
                                            (value) =>
                                                widget.model.getTransactions(),
                                          );
                                        }

                                        trackDecideButtonTap(
                                          currentValue,
                                          currentValue - gain,
                                          formattedMaturityDate,
                                        );
                                      },
                                      color: (showNeedHelp || showConfirm)
                                          ? Colors.black.withOpacity(0.25)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness5,
                                        ),
                                      ),
                                      child: Text(
                                        showNeedHelp
                                            ? "NEED HELP ?"
                                            : showConfirm
                                                ? "CONFIRM"
                                                : hasUserDecided
                                                    ? "CHANGE"
                                                    : "CHOOSE",
                                        style:
                                            TextStyles.rajdhaniB.body2.colour(
                                          (showNeedHelp || showConfirm)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        );
      },
    );
  }
}
