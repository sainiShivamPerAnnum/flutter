import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/rewards/bloc/rewards_history_bloc.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RewardsTransactionsView extends StatelessWidget {
  const RewardsTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardsHistoryBloc(
        locator(),
      )..add(
          const GetData(),
        ),
      child: const RewardsTransactions(),
    );
  }
}

class RewardsTransactions extends StatelessWidget {
  String formatDateTime(DateTime dateTime) {
    DateTime istTime =
        dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    final DateFormat formatter = DateFormat("d MMM yy h:mm a");
    return formatter.format(istTime);
  }

  const RewardsTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: FAppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleWidget: Text(
          'View Transactions',
          style: TextStyles.rajdhaniSB.body1,
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        showAvatar: false,
        showCoinBar: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fello reward balance',
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  PropertyChangeConsumer<UserService, UserServiceProperties>(
                    properties: const [UserServiceProperties.myUserFund],
                    builder: (context, m, property) {
                      return Text(
                        "${m?.userFundWallet?.unclaimedBalance.toInt() ?? '-'} coins",
                        style: TextStyles.rajdhaniB.body2.colour(
                          UiConstants.yellow2,
                        ),
                      );
                    },
                  ),
                ],
              ),
              BlocBuilder<RewardsHistoryBloc, RewardsHistoryState>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingHistoryData() => const FullScreenLoader(),
                    HistoryLoadError() => const NewErrorPage(),
                    RewardsHistory() => state.history.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: SizeConfig.padding200,
                                ),
                                AppImage(
                                  Assets.noRewardsTxn,
                                  height: SizeConfig.padding35,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding20,
                                ),
                                Text(
                                  "No transations yet",
                                  style: TextStyles.sourceSansSB.body0,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding8,
                                ),
                                Text(
                                  "After your first transaction you will be\nable to view it here",
                                  style: TextStyles.sourceSans.body3,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: SizeConfig.padding36,
                              ),
                              Text(
                                'Transaction History',
                                style: TextStyles.sourceSansSB.body2,
                              ),
                              SizedBox(
                                height: SizeConfig.padding10,
                              ),
                              ...state.history.map((historyItem) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: SizeConfig.padding16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Call with ${historyItem.advisorName}',
                                                style:
                                                    TextStyles.sourceSans.body3,
                                              ),
                                              Text(
                                                "Txn ID: ${historyItem.parentTxnId}",
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(
                                                  UiConstants.kTextColor
                                                      .withOpacity(.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '-${historyItem.paymentDetails.amount.toInt()} coins',
                                                style: TextStyles
                                                    .sourceSans.body3
                                                    .colour(
                                                  UiConstants.kred1,
                                                ),
                                              ),
                                              Text(
                                                formatDateTime(
                                                  historyItem.createdAt,
                                                ),
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(
                                                  UiConstants.kTextColor
                                                      .withOpacity(.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding16,
                                      ),
                                      Divider(
                                        color: UiConstants.kTextColor5
                                            .withOpacity(.3),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
