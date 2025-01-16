import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/feature/p2p_home/rps/bloc/rps_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class RpsView extends StatelessWidget {
  const RpsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RpsDetailsBloc(
        locator(),
      )..add(const LoadRpsDetails()),
      child: const RpsDetails(),
    );
  }
}

class RpsDetails extends StatefulWidget {
  const RpsDetails({super.key});

  @override
  State<RpsDetails> createState() => _RpsDetailsState();
}

class _RpsDetailsState extends State<RpsDetails> {
  String rpsDisclaimer = AppConfigV2.instance.rpsDisclaimer;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BaseScaffold(
        showBackgroundGrid: false,
        backgroundColor: UiConstants.bg,
        appBar: AppBar(
          backgroundColor: UiConstants.kTambolaMidTextColor,
          surfaceTintColor: UiConstants.kTambolaMidTextColor,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: SizeConfig.padding20,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding18,
                  ),
                  Column(
                    children: [
                      Text(
                        'Repayment schedule',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.padding35,
                  ),
                  Text(
                    'Get to know the timeline of your repayments.',
                    style: TextStyles.sourceSans.body3,
                  ),
                ],
              ),
            ],
          ),
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          bottom: TabBar(
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: UiConstants.grey4,
            indicatorWeight: 1.5,
            indicatorColor: UiConstants.kTextColor,
            labelColor: UiConstants.kTextColor,
            isScrollable: false,
            unselectedLabelColor: UiConstants.kTextColor.withOpacity(.6),
            labelStyle: TextStyles.sourceSansSB.body3,
            unselectedLabelStyle: TextStyles.sourceSansSB.body3,
            onTap: (value) {
              setState(() {});
            },
            tabs: const [
              Tab(text: "Fixed Plan RPS"),
              Tab(text: "Flexi Plan RPS"),
            ],
          ),
        ),
        body: BlocBuilder<RpsDetailsBloc, RPSState>(
          builder: (context, state) {
            if (state is LoadingRPSDetails) {
              return const Center(
                child: FullScreenLoader(),
              );
            } else if (state is RPSDataState) {
              final fixedRpsDetails = state.fixedData?.rps ?? [];
              final flexiRpsDetails = state.flexiData?.rps ?? [];
              return BaseScaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16)
                            .copyWith(
                      top: SizeConfig.padding32,
                    ),
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness16),
                            ),
                            color: UiConstants.bg,
                          ),
                          child: Builder(
                            builder: (context) {
                              final isFixedTab =
                                  DefaultTabController.of(context).index == 0;
                              final rpsData = isFixedTab
                                  ? fixedRpsDetails
                                  : flexiRpsDetails;
                              return Table(
                                border: TableBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.roundness16),
                                  ),
                                  top: const BorderSide(
                                    color: UiConstants.grey6,
                                    width: .6,
                                    style: BorderStyle.solid,
                                  ),
                                  bottom: const BorderSide(
                                    color: UiConstants.grey6,
                                    width: .6,
                                    style: BorderStyle.solid,
                                  ),
                                  left: const BorderSide(
                                    color: UiConstants.grey6,
                                    width: .6,
                                    style: BorderStyle.solid,
                                  ),
                                  right: const BorderSide(
                                    color: UiConstants.grey6,
                                    width: .6,
                                    style: BorderStyle.solid,
                                  ),
                                  horizontalInside: const BorderSide(
                                    color: UiConstants.grey6,
                                    width: .6,
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
                                              SizeConfig.padding8),
                                          child: Text(
                                            "Month",
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Expected Principal",
                                                style:
                                                    TextStyles.sourceSans.body4,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.padding6,
                                              ),
                                              SuperTooltip(
                                                hideTooltipOnTap: true,
                                                backgroundColor:
                                                    UiConstants.kTextColor4,
                                                popupDirection:
                                                    TooltipDirection.up,
                                                content: Padding(
                                                  padding: EdgeInsets.all(
                                                      SizeConfig.padding8),
                                                  child: const Text(
                                                    'Accrued Interest will be paid along with principal amount',
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: UiConstants
                                                          .kTextColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: SizeConfig.padding14,
                                                  color: UiConstants.greyBg,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.padding8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Paid",
                                                style:
                                                    TextStyles.sourceSans.body4,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.padding6,
                                              ),
                                              SuperTooltip(
                                                hideTooltipOnTap: true,
                                                backgroundColor:
                                                    UiConstants.kTextColor4,
                                                popupDirection:
                                                    TooltipDirection.up,
                                                content: Padding(
                                                  padding: EdgeInsets.all(
                                                    SizeConfig.padding8,
                                                  ),
                                                  child: const Text(
                                                    'Principal + Accrued interest',
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: UiConstants
                                                          .kTextColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: SizeConfig.padding14,
                                                  color: UiConstants.greyBg,
                                                ),
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
                                              style:
                                                  TextStyles.sourceSans.body4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox.shrink(),
                                      ],
                                    ),
                                  ...rpsData.map(
                                    (rps) => TableRow(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              SizeConfig.padding8,
                                            ),
                                            child: Text(
                                              rps.timeline,
                                              style:
                                                  TextStyles.sourceSans.body4,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              SizeConfig.padding8,
                                            ),
                                            child: Text(
                                              BaseUtil.formatIndianRupees(
                                                rps.scheduledAmount,
                                              ),
                                              style:
                                                  TextStyles.sourceSans.body4,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              SizeConfig.padding8,
                                            ),
                                            child: Text(
                                              BaseUtil.formatIndianRupees(
                                                rps.paidAmount,
                                              ),
                                              style:
                                                  TextStyles.sourceSans.body4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                      ],
                    ),
                  ),
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
        ),
      ),
    );
  }
}
