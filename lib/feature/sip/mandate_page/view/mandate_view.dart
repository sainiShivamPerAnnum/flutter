import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/feature/sip/mandate_page/bloc/mandate_bloc.dart';
import 'package:felloapp/feature/sip/sip_polling_page/constants/asset_type.dart';
import 'package:felloapp/feature/sip/sip_polling_page/view/sip_polling_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upi_pay/upi_pay.dart';

class SipMandateView extends StatelessWidget {
  const SipMandateView({
    required this.assetType,
    this.amount = 1000,
    this.frequency = 'DAILY',
    super.key,
  });

  final num amount;
  final String frequency;
  final SIPAssetTypes assetType;

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
  final SIPAssetTypes assetType;

  const _SipMandatePage({
    required this.amount,
    required this.frequency,
    required this.assetType,
  });

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
      backgroundColor: UiConstants.bg,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async =>
              await AppState.backButtonDispatcher!.didPopRoute(),
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
        backgroundColor: UiConstants.bg,
        title: Text(locale.siptitle),
        titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<MandateBloc, MandateState>(
        listener: (context, state) {
          if (state is ListedPSPApps && state.transactionStatus is Created) {
            final data = state.transactionStatus as Created;
            final key = data.subsPrimaryKey;
            AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addWidget,
              page: SipPollingPageConfig,
              widget: SipPollingPage(
                subscriptionKey: key,
                data: data.subscriptionData,
                assetType: assetType.isAugGold ? AssetType.aug : AssetType.flo,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            MandateInitialState() ||
            ListingPSPApps() =>
              const FullScreenLoader(),
            ListedPSPApps(:final pspApps) => MandateStepView(
                amount: amount,
                frequency: frequency,
                assetType: assetType,
                pspApps: pspApps,
                state: state)
          };
        },
      ),
    );
  }
}

class MandateStepView extends StatelessWidget {
  MandateStepView({
    super.key,
    required this.pspApps,
    required this.amount,
    required this.frequency,
    required this.assetType,
    required this.state,
  });
  final List<ApplicationMeta> pspApps;
  final num amount;
  final String frequency;
  final SIPAssetTypes assetType;
  final locale = locator<S>();
  final ListedPSPApps state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.padding22,
            ),
            Text(
              locale.setUpMandate,
              style: TextStyles.rajdhaniSB.title5,
            ),
            SizedBox(
              height: SizeConfig.padding3,
            ),
            Text(
              locale.jstAClickAway,
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
                if (state case ListedPSPApps(:final isTransactionInProgress)
                    when !isTransactionInProgress) {
                  final event = CreateSubscription.fromAssetType(
                    assetType,
                    freq: frequency,
                    meta: meta,
                    assetType: assetType.name,
                    value: amount.toInt(),
                  );
                  context.read<MandateBloc>().add(event);
                }
              },
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            AllowUPIMandateSection(),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                locale.enterUPIpin,
                style: TextStyles.rajdhaniSB.body1,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            switch (state.transactionStatus) {
              Creating() => const LinearProgressIndicator(
                  color: UiConstants.primaryColor,
                  backgroundColor: UiConstants.kDarkBackgroundColor,
                ),
              _ => const SizedBox.shrink(),
            },
            SizedBox(
              height: SizeConfig.padding40,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectUPIApplicationSection extends StatelessWidget {
  SelectUPIApplicationSection({
    required this.onSelectApplication,
    super.key,
    this.upiApps = const [],
  });

  final List<ApplicationMeta> upiApps;
  final locale = locator<S>();
  final ValueChanged<ApplicationMeta> onSelectApplication;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          locale.mandateStep1,
          style: TextStyles.rajdhaniSB.body1,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        if (upiApps.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(
              locale.noUpiAppFound,
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
  AllowUPIMandateSection({super.key});
  final locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          locale.step2Mandate,
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
                      locale.newMandate,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor2),
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Row(
                      children: [
                        AppImage(
                          Assets.mandate_intro,
                          height: SizeConfig.padding172,
                          width: SizeConfig.padding192,
                        ),
                      ],
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
