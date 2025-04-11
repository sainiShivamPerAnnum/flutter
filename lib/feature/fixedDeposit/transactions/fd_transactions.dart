import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_transaction.dart';
import 'package:felloapp/feature/fixedDeposit/depositDetails/deposit_details.dart';
import 'package:felloapp/feature/fixedDeposit/transactions/bloc/transaction_bloc.dart';
import 'package:felloapp/feature/fixedDeposit/transactions/widgets/no_transaction.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FdTransactions extends StatelessWidget {
  const FdTransactions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FdTransactionBloc(
        locator(),
      )..add(
          const LoadMyFDTransactions(),
        ),
      child: const _InvestmentDetails(),
    );
  }
}

class _InvestmentDetails extends StatelessWidget {
  const _InvestmentDetails();

  @override
  Widget build(BuildContext context) {
    final myfundsBloc = context.read<FdTransactionBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        myfundsBloc.add(const LoadMyFDTransactions());
      },
      child: BlocBuilder<FdTransactionBloc, FixedDepositTransactionState>(
        builder: (context, state) {
          return switch (state) {
            LoadingMyDeposits() => const FullScreenLoader(),
            FdMyDepositsError() => NewErrorPage(
                onTryAgain: () {
                  myfundsBloc.add(const LoadMyFDTransactions());
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FilterButton(
                            label: 'Active',
                            isSelected: state.currentFilter == 'ACTIVE',
                            onTap: () {
                              context
                                  .read<FdTransactionBloc>()
                                  .add(const SwitchFilter('ACTIVE'));
                            },
                          ),
                          SizedBox(width: 10.w),
                          FilterButton(
                            label: 'Matured',
                            isSelected: state.currentFilter == 'MATURED',
                            onTap: () {
                              context
                                  .read<FdTransactionBloc>()
                                  .add(const SwitchFilter('MATURED'));
                            },
                          ),
                        ],
                      ),
                    ),
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
                        state.currentFilter.capitalize(),
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
                        final fdData = state.filteredDeposits;
                        if (fdData.isEmpty) {
                          return NoFdTransactions(
                            message:
                                'You have no ${state.currentFilter.capitalize()} Fixed deposits',
                            onClick: () {
                              DefaultTabController.of(context).animateTo(0);
                            },
                          );
                        } else {
                          final portfolio = fdData[index];
                          return GestureDetector(
                            onTap: () {
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                page: FdDetailsPageConfig,
                                state: PageState.addWidget,
                                widget: FixedDepositDetails(
                                  fdData: portfolio,
                                ),
                              );
                            },
                            child: _buildInvestmentSection(portfolio),
                          );
                        }
                      },
                      childCount: state.filteredDeposits.isEmpty
                          ? 1
                          : state.filteredDeposits.length,
                    ),
                  ),
                ],
              )
          };
        },
      ),
    );
  }

  Widget _buildInvestmentSection(FDTransactionData data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: UiConstants.grey7,
          width: 1.h,
        ),
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.r,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 18.h),
      child: Padding(
        padding: EdgeInsets.all(18.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '#${data.jid}',
                          style: GoogleFonts.sourceSans3(
                            color: UiConstants.kTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18.sp,
                        color: UiConstants.kTextColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Deposit: ${BaseUtil.formatIndianRupees(
                      data.depositAmount ?? 0,
                    )}',
                    style: GoogleFonts.sourceSans3(
                      color: UiConstants.kTextColor.withOpacity(.75),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.tenure ?? '',
                  style: GoogleFonts.sourceSans3(
                    color: UiConstants.kTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${data.roi}% XIRR',
                  style: GoogleFonts.sourceSans3(
                    color: UiConstants.kTextColor.withOpacity(.75),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? UiConstants.kTextColor : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected
                ? UiConstants.kTextColor
                : UiConstants.kTextColor.withOpacity(.6),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.sourceSans3(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? UiConstants.greyVarient
                : UiConstants.kTextColor.withOpacity(.6),
          ),
        ),
      ),
    );
  }
}
