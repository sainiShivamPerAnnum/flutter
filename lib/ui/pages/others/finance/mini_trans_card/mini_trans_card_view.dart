import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_history_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/transaction_details_model_sheet.dart';
import 'package:felloapp/ui/pages/others/finance/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/pages/others/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MiniTransactionCard extends StatelessWidget {
  final InvestmentType investmentType;

  const MiniTransactionCard({Key key, @required this.investmentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions(investmentType);
      },
      builder: (ctx, model, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeInOutCubic,
          child: PropertyChangeConsumer<TransactionHistoryService,
              TransactionHistoryServiceProperties>(
            properties: [
              TransactionHistoryServiceProperties.TransactionHistoryList
            ],
            builder: (ctx, m, child) {
              final txnList = m.txnList != null && m.txnList.isNotEmpty
                  ? m.txnList
                      .where((e) => e.subType == investmentType.name)
                      .toList()
                  : [];
              return Column(
                children: [
                  model.state == ViewState.Busy || m.txnList == null
                      ? SizedBox(
                          child: Row(children: [
                            TitleSubtitleContainer(title: 'Transactions'),
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
                      : (m.txnList.length == 0
                          ? SizedBox(height: SizeConfig.padding12)
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TitleSubtitleContainer(
                                          title: 'Transactions'),
                                      Spacer(),
                                      model.state == ViewState.Idle &&
                                              m.txnList != null &&
                                              m.txnList.isNotEmpty &&
                                              m.txnList.length > 3
                                          ? InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: SizeConfig.padding2,
                                                ),
                                                child: Text(
                                                  'See All',
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
                                      txnList.length < 4 ? txnList.length : 3,
                                      (i) => TransactionTile(
                                        txn: txnList[i],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  SizedBox(height: SizeConfig.padding12),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
