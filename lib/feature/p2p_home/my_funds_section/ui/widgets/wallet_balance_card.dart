import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/rps/bloc/rps_bloc.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.fundBloc,
    super.key,
  });
  final MyFundsBloc fundBloc;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    String rpsDisclaimer = AppConfigV2.instance.rpsDisclaimer;
    return BlocBuilder<RpsDetailsBloc, RPSState>(
      builder: (context, state) {
        if (state is LoadingRPSDetails) {
          return const Center(
            child: FullScreenLoader(),
          );
        } else if (state is RPSDataState) {
          final fixedRpsDetails = state.fixedData?.rps ?? [];
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 22.h,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: UiConstants.grey6,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                      bottom: BorderSide(
                        color: UiConstants.grey6,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                      left: BorderSide(
                        color: UiConstants.grey6,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                      right: BorderSide(
                        color: UiConstants.grey6,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      final rpsData = fixedRpsDetails;
                      return Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: UiConstants.grey6,
                            width: .6.w,
                            style: BorderStyle.solid,
                          ),
                        ),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(65, 65, 65, 69),
                            ),
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.padding8,
                                  ),
                                  child: Text(
                                    "Date",
                                    style: TextStyles.sourceSans.body4,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Txn. Type",
                                        style: TextStyles.sourceSans.body4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.padding8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Amount",
                                        style: TextStyles.sourceSans.body4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (rpsData.isEmpty)
                            TableRow(
                              children: [
                                const SizedBox.shrink(),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      SizeConfig.padding8,
                                    ),
                                    child: Text(
                                      'No data found',
                                      style: TextStyles.sourceSans.body4,
                                    ),
                                  ),
                                ),
                                const SizedBox.shrink(),
                              ],
                            ),
                          ...rpsData.where((e) => e.paidAmount != 0).map(
                                (rps) => TableRow(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.padding8,
                                        ),
                                        child: Text(
                                          rps.timeline,
                                          style: TextStyles.sourceSans.body4,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.padding8,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: SizeConfig.padding2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding4,
                                            vertical: SizeConfig.padding4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: UiConstants.teal4
                                                .withOpacity(.3),
                                            borderRadius: BorderRadius.circular(
                                              18.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              Text(
                                                'Repayment',
                                                style: TextStyles
                                                    .sourceSansM.body6
                                                    .colour(
                                                  UiConstants.teal3,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                            ],
                                          ),
                                          // SuperTooltip(
                                          //   hideTooltipOnTap: true,
                                          //   backgroundColor:
                                          //       UiConstants.kTextColor4,
                                          //   popupDirection:
                                          //       TooltipDirection.up,
                                          //   content: Padding(
                                          //     padding: EdgeInsets.all(
                                          //       SizeConfig.padding8,
                                          //     ),
                                          //     child: const Text(
                                          //       'Accrued Interest will be paid along with principal amount',
                                          //       softWrap: true,
                                          //       style: TextStyle(
                                          //         color: UiConstants
                                          //             .kTextColor,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   child: Row(
                                          //     mainAxisSize:
                                          //         MainAxisSize.min,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .center,
                                          //     children: [
                                          //       SizedBox(
                                          //         width: 4.w,
                                          //       ),
                                          //       Text(
                                          //         'Repayment',
                                          //         style: TextStyles
                                          //             .sourceSansM.body6
                                          //             .colour(
                                          //           UiConstants.teal3,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         width: 4.w,
                                          //       ),
                                          //       Icon(
                                          //         Icons.info_outline,
                                          //         size: SizeConfig
                                          //             .padding10,
                                          //         color:
                                          //             UiConstants.teal3,
                                          //       ),
                                          //       SizedBox(
                                          //         width: 4.w,
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.padding8,
                                        ),
                                        child: Text(
                                          rps.paidAmount == 0
                                              ? 'NA'
                                              : formatter.format(
                                                  rps.paidAmount,
                                                ),
                                          style: TextStyles.sourceSans.body4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          TableRow(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.padding8,
                                  ),
                                  child: Text(
                                    'Total',
                                    style: TextStyles.sourceSansSB.body3,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.padding8,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: SizeConfig.padding2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding4,
                                      vertical: SizeConfig.padding4,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.padding8,
                                  ),
                                  child: Text(
                                    formatter.format(
                                      state.fixedData?.totalPayout ?? 0,
                                    ),
                                    style: TextStyles.sourceSansSB.body3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Text(
                  'Disclaimer:\n\n$rpsDisclaimer',
                  style: TextStyles.sourceSansM.body4.colour(
                    UiConstants.kTextColor6,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
              ],
            ),
          );
        } else {
          return NewErrorPage(
            onTryAgain: () {
              BlocProvider.of<RpsDetailsBloc>(
                context,
                listen: false,
              ).add(const LoadRpsDetails());
            },
          );
        }
      },
    );
  }
}
