import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/fixedDeposit/depositScreen/fd_deposit_screen.dart';
import 'package:felloapp/feature/fixedDeposit/fundsSection/bloc/fixed_deposit_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ALLfdsSection extends StatelessWidget {
  const ALLfdsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FixedDepositBloc(
        locator(),
      )..add(
          const LoadFDs(),
        ),
      child: const _AllFds(),
    );
  }
}

class _AllFds extends StatefulWidget {
  const _AllFds();

  @override
  State<_AllFds> createState() => __AllFdsState();
}

class __AllFdsState extends State<_AllFds> {
  @override
  Widget build(BuildContext context) {
    final fundsBloc = context.read<FixedDepositBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        fundsBloc.add(const LoadFDs());
      },
      child: BlocBuilder<FixedDepositBloc, FixedDepositState>(
        builder: (context, state) {
          return switch (state) {
            LoadingAllFds() => const FullScreenLoader(),
            FdLoadError() => NewErrorPage(
                onTryAgain: () {
                  fundsBloc.add(const LoadFDs());
                },
              ),
            AllFdsLoaded() => CustomScrollView(
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final finance = state.fdData[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: UiConstants.greyVarient,
                            border: Border.all(
                              color: UiConstants.grey6,
                              width: SizeConfig.padding1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.padding10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 14,
                                spreadRadius: 0,
                                offset: const Offset(0, 0),
                                color: UiConstants.kTextColor4.withOpacity(.6),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ).copyWith(bottom: SizeConfig.padding18),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding18,
                              horizontal: SizeConfig.padding10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Hero(
                                      tag: finance.id,
                                      child: ClipOval(
                                        child: AppImage(
                                          finance.icon,
                                          width: SizeConfig.padding48,
                                          height: SizeConfig.padding48,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            finance.displayName,
                                            style:
                                                TextStyles.sourceSansSB.body2,
                                          ),
                                          Text(
                                            finance.subText,
                                            style: TextStyles.sourceSans.body4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: SizeConfig.padding8,
                                    top: SizeConfig.padding12,
                                  ),
                                  child:
                                      const Divider(color: UiConstants.grey6),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      finance.investDetailsList.map((detail) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildDetailRow(
                                          detail.label,
                                          detail.value,
                                        ),
                                        if (finance.investDetailsList.last !=
                                            detail)
                                          SizedBox(
                                            height: SizeConfig.padding40,
                                            child: VerticalDivider(
                                              color: UiConstants.grey6,
                                              thickness: 0.5,
                                              width: SizeConfig.padding50,
                                            ),
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.padding8,
                                    bottom: SizeConfig.padding12,
                                  ),
                                  child:
                                      const Divider(color: UiConstants.grey6),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            const spacing = 8.0;
                                            final maxWidth =
                                                constraints.biggest.width;
                                            final containerWidth = (maxWidth -
                                                    ((2 - 1) * spacing)) /
                                                2;
                                            return Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: spacing,
                                              runSpacing: spacing,
                                              children: [
                                                for (int i = 0;
                                                    i < finance.tags.length;
                                                    i++)
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: containerWidth,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            SizeConfig.padding2,
                                                        horizontal:
                                                            SizeConfig.padding6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          int.parse(
                                                            finance
                                                                .tags[i].color
                                                                .replaceAll(
                                                              '#',
                                                              '0xFF',
                                                            ),
                                                          ),
                                                        ).withOpacity(.4),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          SizeConfig.roundness2,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        finance.tags[i].text,
                                                        style: TextStyles
                                                            .sourceSansB.body6
                                                            .colour(
                                                          Color(
                                                            int.parse(
                                                              finance.tags[i]
                                                                  .textColor
                                                                  .replaceAll(
                                                                '#',
                                                                '0xFF',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppState.delegate!.appState
                                              .currentAction = PageAction(
                                            page: FdCalulatorPageConfig,
                                            widget: FDDepositView(
                                              fdData: state.fdData[index],
                                            ),
                                            state: PageState.addWidget,
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                SizeConfig.roundness5,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.padding12,
                                              vertical: SizeConfig.padding8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Invest now',
                                                  style: TextStyles
                                                      .sourceSansM.body4
                                                      .colour(
                                                    UiConstants.kTextColor4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: state.fdData.length,
                    ),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyles.sourceSansM.body4.colour(
            UiConstants.kTextColor.withOpacity(.6),
          ),
        ),
        Text(
          value,
          style: TextStyles.sourceSansM.body3.colour(
            UiConstants.kTextColor,
          ),
        ),
      ],
    );
  }
}
