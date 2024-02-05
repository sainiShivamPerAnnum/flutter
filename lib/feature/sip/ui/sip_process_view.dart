import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_select_assset.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SipProcessView extends StatelessWidget {
  const SipProcessView({super.key, this.investmentType});

  final InvestmentType? investmentType;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AutosaveCubit()),
        BlocProvider(create: (_) => SipAssetSelectCubit()),
      ],
      child: SipProcessUi(
        investmentType: investmentType,
      ),
    );
  }
}

class SipProcessUi extends StatefulWidget {
  const SipProcessUi({Key? key, this.investmentType}) : super(key: key);

  final InvestmentType? investmentType;

  @override
  State<SipProcessUi> createState() => _SipProcessUiState();
}

class _SipProcessUiState extends State<SipProcessUi> {
  Future<void> _onPressedBack(AutosaveCubit model) async {
    FocusScope.of(context).unfocus();
    if (model.pageController.page == 0 || model.pageController.page == 3) {
      await AppState.backButtonDispatcher!.didPopRoute();
    } else {
      await model.pageController.animateToPage(
        model.pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
      return;
    }
  }

  @override
  void initState() {
    context.read<AutosaveCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutosaveCubit, AutosaveCubitState>(
        builder: (context, state) {
      final model = context.watch<AutosaveCubit>();
      return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _onPressedBack(model),
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          ),
          backgroundColor: model.state.currentPage == 0
              ? UiConstants.kTextColor4
              : UiConstants.bg,
          title: const Text('SIP with Fello'),
          titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
          centerTitle: true,
          elevation: .5,
        ),
        resizeToAvoidBottomInset: false,
        body: model.state.isFetchingDetails
            ? const Center(
                child: FullScreenLoader(),
              )
            : Stack(
                children: [
                  const NewSquareBackground(),
                  state.isFetchingDetails
                      ? const Center(
                          child: FullScreenLoader(),
                        )
                      : AutosaveSetupView(
                          model: model,
                        ),
                ],
              ),
      );
    });
  }
}

class AutosaveSetupView extends StatelessWidget {
  final AutosaveCubit model;

  const AutosaveSetupView({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: model.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: model.pageChange,
      children: [
        const SipIntro(),
        const SelectSipScreen(),
        SipAmountView(
          mandateAvailable: model.state.activeSubscription?.isActive ?? false,
        ),
        // UpiAppSelectView(model: model),
      ],
    );
  }
}

class AutosaveSuccessView extends StatelessWidget {
  final AutosaveCubit model;

  const AutosaveSuccessView({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return SizedBox(
      height: SizeConfig.screenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Expanded(
            child: Image.asset(
              Assets.completeCheck,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            locale.congrats,
            style: TextStyles.rajdhaniSB.title1,
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            locale.autoSaveSetUpSuccess,
            style: TextStyles.sourceSans.body2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
            ),
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF57A6B0).withOpacity(0.22),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              border: Border.all(
                color: UiConstants.kTextColor.withOpacity(0.1),
                width: SizeConfig.border1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                //   child: AutosaveSummary(
                //     model: model,
                //     showTopDivider: false,
                //   ),
                // )
              ],
            ),
          ),
          const Spacer(),
          Container(
            color: UiConstants.kBackgroundColor,
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: AppPositiveBtn(
              btnText: locale.obDone,
              width: SizeConfig.screenWidth! -
                  SizeConfig.pageHorizontalMargins * 2,
              onPressed: () {
                locator<UserService>().getUserFundWalletData();
                AppState.backButtonDispatcher!.didPopRoute();
                BaseUtil.showFelloRatingSheet();
              },
            ),
          )
        ],
      ),
    );
  }
}

class AutosavePendingView extends StatelessWidget {
  const AutosavePendingView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.screenWidth! * 0.12,
          ),
          Text(
            locale.setUpAutoSave,
            style: TextStyles.sourceSans.body3.setOpacity(0.5),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            "Processing Autosave",
            style: TextStyles.rajdhaniSB.title4,
          ),
          SizedBox(
            height: SizeConfig.screenWidth! * 0.1,
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Text(
              locale.txnApprovePaymentReq,
              style: TextStyles.sourceSans.body1,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: Center(
            child: LottieBuilder.asset(
              "assets/lotties/loader.json",
              width: SizeConfig.screenWidth! * 0.5,
            ),
          )),
          Text(
            "We'll notify you once your autosave is confirmed",
            style: TextStyles.sourceSansL.body4.colour(Colors.amber),
          ),
          SizedBox(
            height: SizeConfig.pageHorizontalMargins,
          ),
        ],
      ),
    );
  }
}
