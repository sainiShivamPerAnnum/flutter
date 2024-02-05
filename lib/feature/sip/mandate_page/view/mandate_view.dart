import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/sip/mandate_page/bloc/mandate_bloc.dart';
import 'package:felloapp/feature/sip/sip_polling_page/view/sip_polling_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upi_pay/upi_pay.dart';

class SipMandateView extends StatelessWidget {
  const SipMandateView({
    this.amount = 1000,
    this.frequency = 'DAILY',
    this.assetType = '',
    super.key,
  });

  final num amount;
  final String frequency;
  final String assetType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MandateBloc(
        locator(),
        locator(),
        locator(),
      )..add(const LoadPSPApps()),
      child: _SipMandatePage(
        amount: amount,
        frequency: frequency,
        assetType: assetType,
      ),
    );
  }
}

/// TODO(@Dhruvin): Change name.
class _SipMandatePage extends StatelessWidget {
  final num amount;
  final String frequency;
  final String assetType;

  const _SipMandatePage({
    required this.amount,
    required this.frequency,
    required this.assetType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MandateBloc, MandateState>(
      listener: (context, state) {
        if (state is ListedPSPApps && state.transactionStatus is Created) {
          final key = (state.transactionStatus as Created).subsPrimaryKey;
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: SipPollingPageConfig,
            widget: SipPollingPage(
              subscriptionKey: key,
            ),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          MandateInitialState() || ListingPSPApps() => const FullScreenLoader(),
          ListedPSPApps(:final pspApps) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.padding22,
                  ),
                  Text(
                    'Set up UPI Mandate:',
                    style: TextStyles.rajdhaniSB.title5,
                  ),
                  SizedBox(
                    height: SizeConfig.padding3,
                  ),
                  Text(
                    'Just a click away',
                    style: TextStyles.rajdhaniSB.body2.colour(
                      UiConstants.grey1,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  SelectUPIApplicationSection(
                    upiApps: pspApps,
                    onSelectApplication: (meta) {
                      final event = CrateSubscription.lb(
                        meta: meta,
                        value: amount,
                        freq: frequency,
                      );

                      context.read<MandateBloc>().add(event);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  const AllowUPIMandateSection(),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '3. Enter UPI pin and you are done',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: SizeConfig.padding40,
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}

class SelectUPIApplicationSection extends StatelessWidget {
  const SelectUPIApplicationSection({
    required this.onSelectApplication,
    super.key,
    this.upiApps = const [],
  });

  final List<ApplicationMeta> upiApps;
  final ValueChanged<ApplicationMeta> onSelectApplication;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '1. Select preferred UPI application',
          style: TextStyles.rajdhaniSB.body1,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        if (upiApps.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(
              'No upi apps found',
              style: TextStyles.rajdhaniSB.body1,
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: LayoutBuilder(builder: (context, constraints) {
              final width = constraints.biggest.width;
              final spacing = SizeConfig.padding12;
              const horizontalCount = 3;
              final containerWidth = (width - 2 * spacing) / horizontalCount;

              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (int i = 0; i < upiApps.length; i++)
                    SizedBox(
                      height: containerWidth,
                      width: containerWidth,
                      child: _PspAppContainer(
                        meta: upiApps[i],
                        onSelectApplication: onSelectApplication,
                      ),
                    ),
                ],
              );
            }),
          )
      ],
    );
  }
}

class _PspAppContainer extends StatelessWidget {
  const _PspAppContainer({
    required this.meta,
    required this.onSelectApplication,
  });

  final ApplicationMeta meta;
  final ValueChanged<ApplicationMeta> onSelectApplication;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectApplication(meta),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(
            SizeConfig.roundness16,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              meta.iconImage(35),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Text(
                meta.upiApplication.appName,
                style: TextStyles.sourceSansSB.body3,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllowUPIMandateSection extends StatelessWidget {
  const AllowUPIMandateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '2. Allow UPI Mandate.',
          style: TextStyles.rajdhaniSB.body1,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding16,
            horizontal: SizeConfig.padding20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeConfig.roundness12,
            ),
            border: Border.all(
              color: UiConstants.textGray50,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppImage(
                Assets.bulb,
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'You will receive a mandate for ₹5000 on the selected UPI App. But don’t worry, We will not deduct anymore than ₹1100/week.',
                      style: TextStyles.sourceSans.body4,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Placeholder(
                        fallbackHeight: 100,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
