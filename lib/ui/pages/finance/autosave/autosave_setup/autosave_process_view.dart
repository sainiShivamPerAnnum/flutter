import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_slides/autosave_setup_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_slides/autosave_upi_app-select_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/autosave_summary.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
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
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import './autosave_process_slides/autosave_asset_choice_view.dart';
import './autosave_process_slides/autosave_steps_view.dart';

class AutosaveProcessView extends StatefulWidget {
  const AutosaveProcessView({Key? key, this.investmentType}) : super(key: key);

  final InvestmentType? investmentType;

  @override
  State<AutosaveProcessView> createState() => _AutosaveProcessViewState();
}

class _AutosaveProcessViewState extends State<AutosaveProcessView> {
  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Selector<SubService, AutosaveState>(
      selector: (_, subService) => subService.autosaveState,
      builder: (context, autosaveState, child) =>
          BaseView<AutosaveProcessViewModel>(
        onModelReady: (model) => model.init(widget.investmentType),
        onModelDispose: (model) => model.dump(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            appBar: AppBar(
              backgroundColor: UiConstants.kBackgroundColor,
              elevation: 0.0,
              title: model.currentPage <= 3
                  ? Text(
                      "Step ${model.currentPage + 1} of 4",
                      style: TextStyles.sourceSansL.body3,
                    )
                  : Container(),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: UiConstants.kTextColor,
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  (autosaveState == AutosaveState.INIT ||
                          autosaveState == AutosaveState.ACTIVE ||
                          model.pageController!.page == 0 ||
                          model.pageController!.page == 3)
                      ? AppState.backButtonDispatcher!.didPopRoute()
                      : model.pageController!.animateToPage(
                          model.pageController!.page!.toInt() - 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate);
                  model.trackAutosaveBackPress();
                },
              ),
              actions: const [
                Row(
                  children: [FaqPill(type: FaqsType.autosave)],
                )
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: model.state == ViewState.Busy
                ? const Center(
                    child: FullScreenLoader(),
                  )
                : Stack(
                    children: [
                      const NewSquareBackground(),
                      SafeArea(
                        child: autosaveState == AutosaveState.INIT
                            ? const AutosavePendingView()
                            : autosaveState == AutosaveState.IDLE
                                ? AutosaveSetupView(model: model)
                                : autosaveState == AutosaveState.ACTIVE
                                    ? AutosaveSuccessView(model: model)
                                    : const SizedBox(),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class AutosaveSetupView extends StatelessWidget {
  final AutosaveProcessViewModel model;

  const AutosaveSetupView({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: model.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AutosaveStepsView(model: model),
        AutosaveAssetChoiceView(model: model),
        AutoPaySetupOrUpdateView(model: model),
        UpiAppSelectView(model: model),
      ],
    );
  }
}

class AutosaveSuccessView extends StatelessWidget {
  final AutosaveProcessViewModel model;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                  child: AutosaveSummary(
                    model: model,
                    showTopDivider: false,
                  ),
                )
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
    S locale = locator<S>();
    return Container(
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
