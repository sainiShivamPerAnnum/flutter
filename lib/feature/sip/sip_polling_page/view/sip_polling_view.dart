import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/feature/sip/sip_polling_page/bloc/sip_polling_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/asset_type.dart';
import 'widgets/widgets.dart';

class SipPollingPage extends StatelessWidget {
  const SipPollingPage({
    this.subscriptionKey,
    this.assetType = AssetType.aug,
    super.key,
    this.data,
  }) : assert(
          subscriptionKey != null || data != null,
          'Subscription key or data must be provided both can\'t be null',
        );

  final String? subscriptionKey;
  final SubscriptionStatusData? data;
  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    final event = data != null
        ? CreatedSubscription(data!)
        : StartPolling(subscriptionKey!);

    return BlocProvider(
      create: (context) => SipPollingBloc(
        locator(),
        locator(),
      )..add(event),
      child: _SipStatusView(assetType),
    );
  }
}

class _SipStatusView extends StatelessWidget {
  const _SipStatusView(this.assetType);
  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SipPollingBloc, SipPollingState>(
      listener: (context, state) {
        if (state case CompletedPollingWithSuccessOrPending(:final response)) {
          if (response.status.isPaused || response.status.isCancelled) {
            BaseUtil.showNegativeAlert(
              'Unable to check subscription status',
              'Please try again later',
            );

            AppState.backButtonDispatcher!.didPopRoute();
          }
        }

        if (state case CompletedPollingWithFailure(:final message)) {
          BaseUtil.showNegativeAlert(message, null);
          AppState.backButtonDispatcher!.didPopRoute();
        }
      },
      builder: (context, state) {
        return switch (state) {
          InitialPollingState() ||
          Polling() =>
            SipPolling(assetType: assetType),
          CompletedPollingWithSuccessOrPending(:final response) =>
            SipSummaryView(
              data: response,
              assetType: assetType,
            ),
          CompletedPollingWithFailure() => const SipStatusCheckFailurePage(),
        };
      },
    );
  }
}

class SipStatusCheckFailurePage extends StatelessWidget {
  const SipStatusCheckFailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
