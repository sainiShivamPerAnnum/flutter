import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/fixedDeposit/depositDetails/deposit_details.dart';
import 'package:felloapp/feature/fixedDeposit/myDeposits/bloc/my_deposit_bloc.dart';
import 'package:felloapp/feature/fixedDeposit/myDeposits/widgets/summary_card.dart';
import 'package:felloapp/feature/fixedDeposit/transactions/widgets/no_transaction.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../navigator/app_state.dart';

class MyDepositsSection extends StatelessWidget {
  const MyDepositsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyFixedDepositBloc(
        locator(),
      )..add(
          const LoadMyFDs(),
        ),
      child: const _InvestmentDetails(),
    );
  }
}

class _InvestmentDetails extends StatelessWidget {
  const _InvestmentDetails();

  @override
  Widget build(BuildContext context) {
    final myfundsBloc = context.read<MyFixedDepositBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        myfundsBloc.add(const LoadMyFDs());
      },
      child: BlocBuilder<MyFixedDepositBloc, MyFixedDepositState>(
        builder: (context, state) {
          return switch (state) {
            LoadingMyDeposits() => const FullScreenLoader(),
            FdMyDepositsError() => NewErrorPage(
                onTryAgain: () {
                  myfundsBloc.add(const LoadMyFDs());
                },
              ),
            NoFixedDepositsState() => Container(
                margin: EdgeInsets.only(top: 70.h),
                height: 90.h,
                width: 1.sh,
                child: NoFdTransactions(
                  message: 'You have not invested in any plan',
                  onClick: () {
                    DefaultTabController.of(context).animateTo(0);
                  },
                ),
              ),
            FdDepositsLoaded() => CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: SizeConfig.padding20,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SummaryCard(summary: state.fdData.summary),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 34.h,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Fixed Deposits',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: UiConstants.kTextColor,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 18.h,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final fdData = state.fdData;
                        final portfolio = fdData.portfolio[index];
                        return GestureDetector(
                          onTap: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              page: FdDetailsPageConfig,
                              state: PageState.addWidget,
                              widget: FixedDepositDetails(
                                fdData: fdData,
                              ),
                            );
                          },
                          child:
                              _buildInvestmentSection(portfolio.issuer ?? "", {
                            'current': portfolio.currentAmount,
                            'avgXirr': portfolio.roi,
                            'invested': portfolio.investedAmount,
                            'tenure': portfolio.tenure,
                          }),
                        );
                      },
                      childCount: state.fdData.portfolio.length,
                    ),
                  ),
                ],
              )
          };
        },
      ),
    );
  }

  Widget _buildInvestmentSection(String title, Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: UiConstants.greyVarient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff292B2F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: UiConstants.kTextColor,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 18.sp,
                  color: UiConstants.kTextColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor.withOpacity(.5),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          BaseUtil.formatIndianRupees(data['current'] ?? 0),
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Avg. XIRR',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor.withOpacity(.5),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '${data['avgXirr']}%',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.teal3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Divider(
                  color: UiConstants.kTextColor.withOpacity(0.08),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invested',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor.withOpacity(.5),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          BaseUtil.formatIndianRupees(data['invested'] ?? 0),
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tenure',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor.withOpacity(.5),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '${data['tenure']}',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: UiConstants.kTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
