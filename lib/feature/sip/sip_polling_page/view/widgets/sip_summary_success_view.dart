import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constants/asset_type.dart';

class SipSummaryView extends StatelessWidget {
  const SipSummaryView({
    required this.data,
    required this.assetType,
    super.key,
  });

  final SubscriptionStatusData data;
  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Icon(Icons.close),
            onTap: () => AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceAll,
              page: RootPageConfig,
            ),
          ),
          SizedBox(
            width: SizeConfig.pageHorizontalMargins,
          )
        ],
      ),
      body: switch (data.status) {
        AutosaveState.ACTIVE => SipSummaSuccessView(
            data: data,
            assetType: assetType,
          ),
        _ => const FullScreenLoader()
      },
    );
  }
}

class SipSummaSuccessView extends StatelessWidget {
  const SipSummaSuccessView({
    required this.data,
    required this.assetType,
    super.key,
  });

  final SubscriptionStatusData data;
  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.padding22,
            ),
            Transform.scale(
              scale: 1.3,
              child: Lottie.network(
                assetType.successLottie,
                fit: BoxFit.cover,
                height: SizeConfig.padding200,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding44,
            ),
            Text(
              'Your SIP Summary',
              style: TextStyles.rajdhaniB.title2,
            ),
            SizedBox(
              height: SizeConfig.padding6,
            ),
            Text(
              'Your ${data.frequency.duration} SIP in ${data.AUGGOLD99 > 0 ? "Digital Gold" : "Fello P2P"}',
              style: TextStyles.sourceSans.body2.setOpacity(.7),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            _SipSummary(data),
            const Spacer(),
            SecondaryButton(
              label: 'CHECK YOUR REWARDS',
              onPressed: () async {
                await context.read<SipCubit>().getData();
                while (AppState.delegate!.pages.last.name !=
                    SipIntroPageConfig.path) {
                  await AppState.backButtonDispatcher!.didPopRoute();
                }
              },
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SipSummary extends StatelessWidget {
  const _SipSummary(this.data);
  final SubscriptionStatusData data;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(data.createdOn));
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff273339),
            ),
            borderRadius: BorderRadius.circular(
              SizeConfig.roundness12,
            ),
          ),
          padding: EdgeInsets.all(
            SizeConfig.padding12,
          ),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Text(
                'SIP amount',
                style: TextStyles.sourceSans.body2.colour(
                  UiConstants.textGray60,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding8,
              ),
              Text(
                '₹ ${data.amount}',
                style: TextStyles.sourceSansSB.title4,
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Text(
                'Started on $formattedDate',
                style: TextStyles.sourceSans.body3.colour(
                  UiConstants.grey1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        if (data.gts.isNotEmpty || data.tt > 0)
          Row(
            children: [
              if (data.gts.isNotEmpty)
                Expanded(
                  child: _WinningsChip(
                    type: _RewardType.sc,
                    title: 'Scratch Card',
                    quantity: data.gts.length,
                  ),
                ),
              if (data.tt > 0) ...[
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Expanded(
                  child: _WinningsChip(
                    type: _RewardType.tt,
                    title: 'Tickets',
                    quantity: data.tt,
                  ),
                ),
              ]
            ],
          )
      ],
    );
  }
}

enum _RewardType {
  sc(asset: Assets.scratchCard), // golden ticket | scratch card.
  tt(asset: Assets.tambolaTicket); // tambola ticket.

  const _RewardType({
    required this.asset,
  });

  final String asset;
}

class _WinningsChip extends StatelessWidget {
  const _WinningsChip({
    required this.type,
    required this.title,
    required this.quantity,
  });

  final _RewardType type;
  final String title;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.padding12),
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9).withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: UiConstants.grey2.withOpacity(.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.textGray70,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.padding20,
                child: AppImage(type.asset),
              ),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                quantity.toString(),
                style: TextStyles.sourceSansSB.body2,
              )
            ],
          )
        ],
      ),
    );
  }
}
