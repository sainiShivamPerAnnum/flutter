import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/bloc/referral_cubit.dart';
import 'package:felloapp/feature/referrals/ui/how_it_works_widget.dart';
import 'package:felloapp/feature/referrals/ui/invite_contact_widget.dart';
import 'package:felloapp/feature/referrals/ui/referral_list.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralHome extends StatefulWidget {
  const ReferralHome({super.key});

  @override
  State<ReferralHome> createState() => _ReferralHomeState();
}

class _ReferralHomeState extends State<ReferralHome> {
  final ScrollController _controller = ScrollController();
  final userService = locator<UserService>();
  final referralService = locator<ReferralService>();

  String get subTitle => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['hero']['subtitle'];

  String get referralShareText =>
      'Hey I am gifting you ₹${AppConfig.getValue(AppConfigKey.referralBonus)} and ${AppConfig.getValue(AppConfigKey.referralBonus)} gaming tokens. Lets start saving and playing together! Share this code: *${referralService.refCode}* with your friends.\n';

  @override
  void initState() {
    super.initState();
    if (userService.referralFromNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInstantScratchCard();
      });
    }
  }

  void _showInstantScratchCard() {
    final scratchCardService = locator<ScratchCardService>();

    scratchCardService.fetchAndVerifyScratchCardByID().then((value) {
      if (value) {
        scratchCardService.showInstantScratchCardView(
            source: GTSOURCE.referral);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) {
        return BlocProvider<ReferralCubit>(
          create: (context) => ReferralCubit(model),
          child: Scaffold(
            extendBody: true,
            backgroundColor: const Color(0xff181818),
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Builder(
                  builder: (context) {
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        statusBarColor: UiConstants.kReferralHeaderColor,
                      ),
                      child: SafeArea(
                        child: DefaultTabController(
                          length: 2,
                          child: NestedScrollView(
                            controller: _controller,
                            physics: const ClampingScrollPhysics(),
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
                                buildHeaderSliver(model),
                                buildBodySliver(model),
                              ];
                            },
                            body: ReferralTabView(
                              controller: _controller,
                              model: model,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CustomKeyboardSubmitButton(
                  onSubmit: () {
                    //hide keyboard
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
            bottomNavigationBar: buildBottomNav(model),
          ),
        );
      },
    );
  }

  SliverToBoxAdapter buildHeaderSliver(ReferralDetailsViewModel model) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kReferralHeaderColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.roundness12),
                    bottomRight: Radius.circular(SizeConfig.roundness12),
                  ),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lotties/referral_lottie.json',
                      // height: SizeConfig.padding140,
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.fitWidth,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Win ',
                            style: TextStyles.rajdhaniB.title1
                                .colour(Colors.white),
                          ),
                          TextSpan(
                            text: '₹${model.referralAmount}',
                            style: TextStyles.rajdhaniB.title1
                                .colour(const Color(0xFFFFD979)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Transform.translate(
                      offset: Offset(0, -SizeConfig.padding10),
                      child: Text(
                        'per Referral',
                        style: TextStyles.rajdhaniB.title1.colour(Colors.white),
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.padding6,
                          height: SizeConfig.padding6,
                          // margin: EdgeInsets.only(
                          //     top: SizeConfig.padding8),
                          decoration: const ShapeDecoration(
                            color: Color(0xFF61E3C4),
                            shape: OvalBorder(),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding4,
                        ),
                        Text(
                          subTitle,
                          style: TextStyles.body3.colour(Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.padding8),
                  child: FaqPill(
                    type: FaqsType.referrals,
                    addEvent: () {
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.referralSectionHelpTapped,
                        properties: {
                          'Earned So far': model.totalReferralWon,
                          "contact access given": model.hasPermission,
                          "Current referral count":
                              AnalyticsProperties.getTotalReferralCount(),
                        },
                      );
                    },
                  ),
                ),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.referralSectionBackTapped,
                    properties: {
                      'Earned So far': model.totalReferralWon,
                      "contact access given": model.hasPermission,
                      "Current referral count":
                          AnalyticsProperties.getTotalReferralCount(),
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.padding8),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  SliverToBoxAdapter buildBodySliver(ReferralDetailsViewModel model) {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xff181818),
        child: Column(
          children: [
            if ((model.totalReferralWon ?? 0) > 1)
              Stack(
                children: [
                  Container(
                      height: SizeConfig.padding46,
                      padding: EdgeInsets.fromLTRB(
                          SizeConfig.padding38,
                          SizeConfig.padding14,
                          SizeConfig.padding20,
                          SizeConfig.padding10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF39393C),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(SizeConfig.roundness16),
                          bottomRight: Radius.circular(SizeConfig.roundness16),
                        ),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'You’ve earned ',
                                style: TextStyles.rajdhaniSB.body2
                                    .colour(Colors.white)),
                            TextSpan(
                                text: '₹${model.totalReferralWon}',
                                style: TextStyles.rajdhaniB.body2
                                    .colour(const Color(0xFFFFD979))),
                            TextSpan(
                                text: ' so far!',
                                style: TextStyles.rajdhaniSB.body2
                                    .colour(Colors.white)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )),
                  Positioned(
                    left: SizeConfig.padding24,
                    top: SizeConfig.padding24,
                    child: CustomPaint(
                      size: Size(SizeConfig.padding8,
                          (SizeConfig.padding8 * 1.125).toDouble()),
                      painter: ReferralStarCustomPainter(),
                    ),
                  ),
                  Positioned(
                    left: SizeConfig.padding32,
                    top: SizeConfig.padding18,
                    child: CustomPaint(
                      size: Size(SizeConfig.padding8,
                          (SizeConfig.padding8 * 1.125).toDouble()),
                      painter: ReferralStarCustomPainter(),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            HowItWorksWidget(
              isBoxOpen: !((model.totalReferralWon ?? 0) > 1),
              onStateChanged: () {
                // _controller.animateTo(
                //     _controller.position.maxScrollExtent,
                //     duration: const Duration(milliseconds: 500),
                //     curve: Curves.ease);
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

  Container buildBottomNav(ReferralDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.only(
          right: SizeConfig.pageHorizontalMargins,
          left: SizeConfig.pageHorizontalMargins,
          bottom: SizeConfig.padding16,
          top: SizeConfig.padding8),
      decoration: BoxDecoration(
        color: const Color(0xff3C3C3C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness12),
          topRight: Radius.circular(SizeConfig.roundness12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Referral Code',
            style: TextStyles.sourceSans.body3
                .colour(Colors.white.withOpacity(0.45)),
          ),
          SizedBox(
            height: SizeConfig.padding6,
          ),
          Row(
            children: [
              Container(
                // height: SizeConfig.padding44,
                width: SizeConfig.screenWidth! * 0.55,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding12,
                    vertical: SizeConfig.padding6),
                decoration: BoxDecoration(
                  color: const Color(0xff1B1B1B),
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConfig.roundness8)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model.loadingRefCode ? '-' : model.refCode,
                      style: TextStyles.rajdhaniEB.title2
                          .colour(const Color(0xff1ADAB7))
                          .copyWith(
                            letterSpacing: 4.68,
                          ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        model.copyReferCode();
                        locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.copyReferralCodeTapped,
                          properties: {
                            'Referral code': model.refCode,
                            'Total referrals':
                                AnalyticsProperties.getTotalReferralCount()
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy,
                            color: UiConstants.kTextColor3.withOpacity(0.5),
                            size: SizeConfig.padding24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: SizeConfig.padding54,
                height: SizeConfig.padding48,
                padding: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: const Color(0xFF07D2AD),
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff12BC9D),
                      Color(0xff249680),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (model.isShareAlreadyClicked == false) {
                      referralService.shareLink();

                      locator<AnalyticsService>().track(
                        eventName:
                            AnalyticsEvents.inviteFriendsReferralSectionTapped,
                        properties: {'location': 'bottom footer'},
                      );
                    }
                  },
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                    size: SizeConfig.padding24,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  String message =
                      (referralService.shareMsg ?? referralShareText) +
                          (referralService.referralShortLink ?? "");

                  if (!await canLaunchUrl(
                    Uri.parse('https://wa.me/?text=$message'),
                  )) {
                    BaseUtil.showNegativeAlert('Whatsapp not installed',
                        'Please install whatsapp to share referral link');
                    return;
                  }

                  await launchUrl(
                    Uri.parse('https://wa.me/?text=$message'),
                    mode: LaunchMode.externalApplication,
                  );

                  locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.whatsappButtonTapped,
                    properties: {
                      'Referral code': model.refCode,
                      'Total referrals':
                          AnalyticsProperties.getTotalReferralCount()
                    },
                  );
                },
                child: Container(
                  width: SizeConfig.padding54,
                  height: SizeConfig.padding48,
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07D2AD),
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff12BC9D),
                        Color(0xff249680),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/vectors/whatsapp.svg',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _controller.dispose();
    super.dispose();
  }
}

class ReferralTabView extends StatelessWidget {
  const ReferralTabView({
    required ScrollController controller,
    required this.model,
    super.key,
  }) : _controller = controller;

  final ScrollController _controller;
  final ReferralDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff181818),
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(
                child: Text(
                  'Your Referrals',
                ),
              ),
              Tab(
                child: Text(
                  'Invite Contacts',
                ),
              ),
            ],
            onTap: (index) {
              FocusScope.of(context).requestFocus(FocusNode());
              model.switchTab(index);
            },
            labelStyle: TextStyles.sourceSansSB.body1
                .colour(UiConstants.titleTextColor),
            unselectedLabelStyle: TextStyles.sourceSans.body1
                .colour(UiConstants.titleTextColor.withOpacity(0.6)),
            labelColor: UiConstants.titleTextColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
          ),
          Expanded(
            child: BlocBuilder<ReferralCubit, ReferralState>(
              builder: (context, state) {
                return TabBarView(
                  children: [
                    ReferralList(
                      model: model,
                      scrollController: _controller,
                    ),
                    InviteContactWidget(
                      model: model,
                      scrollController: _controller,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> navigateToWhatsApp(String phoneNumber, [String? message]) async {
  var referralService = locator<ReferralService>();
  log('phoneNumber: $phoneNumber', name: 'ReferralDetailsScreen');

  String referralShareText =
      'Hey I am gifting you ₹${AppConfig.getValue(AppConfigKey.referralBonus)} and ${AppConfig.getValue(AppConfigKey.referralBonus)} gaming tokens. Lets start saving and playing together! Share this code: *${referralService.refCode}* with your friends.\n';

  final text = Uri.encodeComponent((message ?? referralShareText) +
      (referralService.referralShortLink ?? ""));
  final url = 'https://wa.me/+91$phoneNumber?text=$text';
  log('WhatsApp URL: $url', name: 'ReferralDetailsScreen');
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } on Exception catch (e) {
    log('Exception: $e', name: 'ReferralDetailsScreen');
    BaseUtil.showNegativeAlert(
        'Unable to open WhatsApp', 'Please share the referral link manually');
  }
}
