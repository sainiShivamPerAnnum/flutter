import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/feature/sip/sip_polling_page/bloc/sip_polling_bloc.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SipPollingPage extends StatelessWidget {
  const SipPollingPage({
    required this.subscriptionKey,
    super.key,
    this.data,
  });

  final String subscriptionKey;
  final SubscriptionStatusData? data;

  @override
  Widget build(BuildContext context) {
    final event = data != null
        ? CreatedSubscription(data!)
        : StartPolling(subscriptionKey);

    return BlocProvider(
      create: (context) => SipPollingBloc(
        locator(),
        locator(),
      )..add(event),
      child: const _SipPollingView(),
    );
  }
}

class _SipPollingView extends StatelessWidget {
  const _SipPollingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SipPollingBloc, SipPollingState>(
      listener: (context, state) => {},
      builder: (context, state) {
        return switch (state) {
          InitialPollingState() || Polling() => const SipPolling(),
          CompletedPollingWithSuccessOrPending(:final response) =>
            SipCompletedOrPending(
              data: response,
            ),
          CompletedPollingWithFailure() => const SipStatusCheckFailurePage(),
        };
      },
    );
  }
}

class SipCompletedOrPending extends StatelessWidget {
  const SipCompletedOrPending({required this.data, super.key});
  final SubscriptionStatusData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (data.status) {
        AutosaveState.ACTIVE => const SipCreationSuccessView(),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class SipCreationSuccessView extends StatelessWidget {
  const SipCreationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SipPolling extends StatelessWidget {
  const SipPolling({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SipStatusCheckFailurePage extends StatelessWidget {
  const SipStatusCheckFailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
