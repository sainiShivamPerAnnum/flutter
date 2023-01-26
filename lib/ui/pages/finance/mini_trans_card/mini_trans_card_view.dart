import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class MiniTransactionCard extends StatelessWidget {
  final InvestmentType investmentType;

  const MiniTransactionCard({Key? key, required this.investmentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions(investmentType);
      },
      builder: (ctx, model, child) {
        return AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeInOutCubic,
            child: Column(
              children: [
                model.state == ViewState.Busy || model.transactions == null
                    ? SizedBox(
                        child: Row(children: [
                          TitleSubtitleContainer(
                              title: locale.txns, leadingPadding: false),
                          Spacer(),
                          Container(
                            width: SizeConfig.avatarRadius,
                            height: SizeConfig.avatarRadius,
                            child: CircularProgressIndicator(
                              strokeWidth: 0.5,
                              color: UiConstants.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.pageHorizontalMargins * 1.5,
                          )
                        ]),
                      )
                    : (model.transactions!.length == 0
                        ? SizedBox(height: SizeConfig.padding12)
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding10,
                                vertical: SizeConfig.padding10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TitleSubtitleContainer(
                                        title: locale.txns,
                                        leadingPadding: false),
                                    Spacer(),
                                    model.state == ViewState.Idle &&
                                            model.transactions != null &&
                                            model.transactions!.isNotEmpty &&
                                            model.transactions!.length > 3
                                        ? InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: SizeConfig.padding2,
                                              ),
                                              child: Text(
                                                locale.btnSeeAll,
                                                style: TextStyles
                                                    .rajdhaniSB.body2
                                                    .colour(UiConstants
                                                        .primaryColor),
                                              ),
                                            ),
                                            onTap: () =>
                                                model.viewAllTransaction(
                                                    investmentType),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      width: SizeConfig.pageHorizontalMargins,
                                    )
                                  ],
                                ),
                                SizedBox(height: SizeConfig.padding8),
                                Column(
                                  children: List.generate(
                                    model.transactions!.length < 4
                                        ? model.transactions!.length
                                        : 3,
                                    (i) => TransactionTile(
                                      txn: model.transactions![i],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                SizedBox(height: SizeConfig.padding12),
              ],
            ));
      },
    );
  }
}
