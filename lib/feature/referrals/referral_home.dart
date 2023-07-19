import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/contact_model.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/bloc/referral_cubit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/debouncer.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralHome extends StatelessWidget {
  ReferralHome({super.key});

  final ScrollController _controller = ScrollController();

  TextStyle get _selectedTextStyle =>
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  TextStyle get _unselectedTextStyle => TextStyles.sourceSans.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  @override
  Widget build(BuildContext context) {
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: UiConstants.kReferralHeaderColor,
          ),
          child: Scaffold(
            // backgroundColor: const Color(0xff181818),
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: UiConstants.kReferralHeaderColor,
              leading: IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    color: const Color(0xff181818),
                    child: Column(
                      children: [
                        Container(
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            color: UiConstants.kReferralHeaderColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(SizeConfig.roundness12),
                              bottomRight:
                                  Radius.circular(SizeConfig.roundness12),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding54,
                            ),
                            child: Column(
                              children: [
                                // SizedBox(height: SizeConfig.padding12),
                                // Container(
                                //   height: SizeConfig.padding128,
                                //   decoration: const BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Color(0xff1F1F1F),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "Lottie",
                                //       style:
                                //           TextStyles.body3.colour(Colors.white),
                                //     ),
                                //   ),
                                // ),

                                Lottie.asset(
                                  'assets/lotties/referral_lottie.json',
                                  height: SizeConfig.padding140,
                                  // width: SizeConfig.padding128,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: SizeConfig.padding24),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Win ',
                                        style: TextStyles.rajdhaniB.title1
                                            .colour(Colors.white),
                                      ),
                                      TextSpan(
                                        text: '₹500',
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
                                    style: TextStyles.rajdhaniB.title1
                                        .colour(Colors.white),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.padding16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: SizeConfig.padding6,
                                      height: SizeConfig.padding6,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.padding8),
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFF61E3C4),
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        AppConfig.getValue(AppConfigKey
                                                .app_referral_message)
                                            .toString(),
                                        style: TextStyles.body3
                                            .colour(Colors.white70),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.padding28,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding24,
                        ),
                        HowItWorksWidget(
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
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.padding34,
                            // bottom: SizeConfig.padding12,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => model.switchTab(0),
                                      child: Text(
                                        'Your Referrals',
                                        style: model.tabNo == 0
                                            ? _selectedTextStyle
                                            : _unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding16,
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => model.switchTab(1),
                                      child: Text(
                                        'Invite Contacts',
                                        style: model.tabNo == 1
                                            ? _selectedTextStyle
                                            : _unselectedTextStyle, // style: TextStyles.sourceSansSB.body1,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    height: 5,
                                    width: model.tabPosWidthFactor,
                                  ),
                                  Container(
                                    color: UiConstants.kTabBorderColor,
                                    height: 5,
                                    width: SizeConfig.screenWidth! * 0.38,
                                  )
                                ],
                              ),
                              BlocProvider<ReferralCubit>(
                                create: (_) => ReferralCubit(),
                                child: HeightAdaptivePageView(
                                  controller: model.pageController,
                                  onPageChanged: (int page) {
                                    model.switchTab(page);
                                  },
                                  children: [
                                    BonusUnlockedReferals(
                                      model: model,
                                    ),
                                    InviteContactWidget(
                                      model: model,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.navBarHeight * 5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
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
                          'Your code',
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
                              width: SizeConfig.screenWidth! * 0.728,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding12,
                                  vertical: SizeConfig.padding6),
                              decoration: BoxDecoration(
                                color: const Color(0xff1B1B1B),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.roundness8)),
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
                                    },
                                    child: Row(
                                      children: [
                                        Text('COPY',
                                            style: TextStyles.sourceSans.body3
                                                .colour(UiConstants.kTextColor3
                                                    .withOpacity(0.3))),
                                        SizedBox(
                                          width: SizeConfig.padding6,
                                        ),
                                        Icon(
                                          Icons.copy,
                                          color: UiConstants.kTextColor3
                                              .withOpacity(0.5),
                                          size: SizeConfig.padding24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding10,
                            ),
                            Container(
                              // height: SizeConfig.padding44,
                              padding: EdgeInsets.all(SizeConfig.padding14),
                              decoration: const BoxDecoration(
                                color: Color(0xff1B1B1B),
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (model.isShareAlreadyClicked == false) {
                                    locator<ReferralService>().shareLink();
                                  }
                                },
                                child: Icon(
                                  Icons.share_outlined,
                                  color: UiConstants.kTabBorderColor,
                                  size: SizeConfig.padding24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding18,
                        ),
                        Row(
                          children: [
                            AppPositiveBtn(
                              btnText: 'INVITE FRIENDS',
                              width: SizeConfig.screenWidth! * 0.692,
                              height: SizeConfig.padding56,
                              onPressed: () {
                                if (model.isShareAlreadyClicked == false) {
                                  locator<ReferralService>().shareLink();
                                }
                              },
                            ),
                            SizedBox(width: SizeConfig.padding12),
                            Container(
                              width: SizeConfig.padding60,
                              height: SizeConfig.padding56,
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // bottomNavigationBar:
          ),
        );
      },
    );
  }
}

class HowItWorksWidget extends StatefulWidget {
  const HowItWorksWidget({super.key, required this.onStateChanged});

  final Function onStateChanged;

  @override
  State<HowItWorksWidget> createState() => _HowItWorksWidgetState();
}

class _HowItWorksWidgetState extends State<HowItWorksWidget> {
  bool isBoxOpen = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
        vertical: SizeConfig.padding4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.01, 1.00),
          end: Alignment(0.01, -1),
          colors: [Color(0xFF3A393C), Color(0xFF232326)],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              //Chaning the state of the box on click

              setState(() {
                isBoxOpen = !isBoxOpen;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                widget.onStateChanged();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.padding44),
                  child: Text(
                    'How it works',
                    style: TextStyles.rajdhaniSB.body1,
                  ),
                ),
                const Spacer(),
                Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (isBoxOpen)
            SizedBox(
              height: SizeConfig.padding20,
            ),
          isBoxOpen
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeIn,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 50; i++)
                            Container(
                              width: SizeConfig.padding6,
                              height: 1,
                              decoration: BoxDecoration(
                                color: i % 2 == 0
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(0, -SizeConfig.padding20),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/winScreen-referalAsset.svg',
                                    width: SizeConfig.padding32,
                                    height: SizeConfig.padding44,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding88,
                                    child: Text(
                                      'Ask friend to signup with your referral code',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.padding36,
                                    height: SizeConfig.padding38,
                                    child: SvgPicture.asset(
                                      'assets/svg/avatar.svg',
                                      width: SizeConfig.padding32,
                                      height: SizeConfig.padding44,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding8,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding88,
                                    child: Text(
                                      'Friend saves ₹100 on Fello & you get ₹50',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/gold_icon.svg',
                                    width: SizeConfig.padding32,
                                    height: SizeConfig.padding44,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding88,
                                    child: Text(
                                      'Friend invests in 12% and you get ₹450 more!',
                                      textAlign: TextAlign.center,
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class InviteContactWidget extends StatefulWidget {
  const InviteContactWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ReferralDetailsViewModel model;

  @override
  State<InviteContactWidget> createState() => _InviteContactWidgetState();
}

class _InviteContactWidgetState extends State<InviteContactWidget>
    with AutomaticKeepAliveClientMixin<InviteContactWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().checkPermission();
  }

  void showPermissionBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
        decoration: BoxDecoration(
          color: const Color(0xff39393C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.padding18,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.247,
              height: SizeConfig.padding4,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(SizeConfig.padding4),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Text(
              'Allow access to your contacts for a seamless referral',
              style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SizeConfig.padding14,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.55,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding4,
                  vertical: SizeConfig.padding4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security,
                    color: const Color(0xff959596),
                    size: SizeConfig.padding14,
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                  Text(
                    'Your data is safe with Fello',
                    style: TextStyles.sourceSans.body3
                        .colour(Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.padding36,
                      height: SizeConfig.padding38,
                      child: SvgPicture.asset(
                        'assets/svg/avatar.svg',
                        // width: SizeConfig.padding32,
                        height: SizeConfig.padding48,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding8,
                    ),
                    SizedBox(
                      width: SizeConfig.padding88,
                      child: Text(
                        '1234 Users',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/winScreen-referalAsset.svg',
                      width: SizeConfig.padding32,
                      height: SizeConfig.padding48,
                    ),
                    SizedBox(
                      width: SizeConfig.padding88,
                      child: Text(
                        '590 Referrals',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/play_gift.svg',
                      width: SizeConfig.padding32,
                      height: SizeConfig.padding44,
                    ),
                    SizedBox(
                      // width: SizeConfig.padding88,
                      child: Text(
                        '₹47569 rewards',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.padding38,
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/people.svg',
                      height: SizeConfig.padding16,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      'Fello is even more fun with friends!',
                      style: TextStyles.sourceSans.body3.colour(
                        Colors.white.withOpacity(0.64),
                      ),
                    )
                  ],
                ),
                Positioned(
                  left: 35,
                  top: 5,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding8,
                        (SizeConfig.padding8 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
                Positioned(
                  left: 41,
                  top: 0,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding6,
                        (SizeConfig.padding6 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
                Positioned(
                  left: 60,
                  top: 3,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding8,
                        (SizeConfig.padding8 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            AppPositiveBtn(
              btnText: 'ALLOW ACCESS TO CONTACTS',
              onPressed: () async {
                await context.read<ReferralCubit>().requestPermission();
              },
            ),
            SizedBox(
              height: SizeConfig.padding4,
            ),
            TextButton(
              onPressed: () {
                if (widget.model.isShareAlreadyClicked == false) {
                  locator<ReferralService>().shareLink();
                }
              },
              child: Text(
                'INVITE MANUALLY',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniSB.body0.colour(
                  const Color(0xFF00F2C7),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding22,
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      builder: (context, state) {
        if (state is NoPermissionState) {
          return Column(
            children: [
              SizedBox(height: SizeConfig.padding20),
              SvgPicture.asset(
                'assets/svg/magnifying_glass.svg',
                height: SizeConfig.padding148,
              ),
              Text(
                'You haven’t added your contacts yet',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.8)),
              ),
              SizedBox(height: SizeConfig.padding12),
              SizedBox(
                width: SizeConfig.padding200 + SizeConfig.padding54,
                child: Text(
                  'Over 2000 users have given contact access to Fello',
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.body0
                      .colour(Colors.white.withOpacity(0.8)),
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              MaterialButton(
                onPressed: showPermissionBottomSheet,
                color: Colors.white,
                minWidth: SizeConfig.padding100,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding60,
                    vertical: SizeConfig.padding12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.padding34,
                child: Text(
                  "SYNC CONTACTS",
                  style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                ),
              ),
              SizedBox(height: SizeConfig.padding54),
            ],
          );
        }

        if (state is ContactsLoaded) {
          return ContactListWidget(
            contacts: state.contacts,
          );
        }

        if (state is ContactsError) {
          return SizedBox(
            height: SizeConfig.padding80,
            child: Center(
              child: Text(
                'Error loading contacts',
                style: TextStyles.sourceSans.body3
                    .colour(Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        }

        return SizedBox(
          height: SizeConfig.screenHeight! * 0.6,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ContactListWidget extends StatefulWidget {
  const ContactListWidget({super.key, required this.contacts});

  final List<Contact> contacts;

  @override
  State<ContactListWidget> createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  TextEditingController controller = TextEditingController();
  List<Contact> filteredContacts = []; // List to store filtered contacts
  late final Debouncer _debouncer;

  // late final ReferralCubit _referralCubit;

  void searchContacts(String query) {
    log('searchContacts: $query', name: 'ReferralDetailsScreen');
    if (query.isEmpty || query.length < 3) {
      // If the query is empty, display all contacts
      setState(() {
        filteredContacts = List.from(widget.contacts);
      });
    } else {
      // Filter contacts based on the query
      setState(() {
        filteredContacts = widget.contacts
            .where((contact) =>
                contact.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
        log('filteredContacts name: ${filteredContacts[0].displayName}',
            name: 'ReferralDetailsScreen');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _referralCubit = context.read<ReferralCubit>();
    filteredContacts = widget
        .contacts; // Initialize filteredContacts with all contacts initially
    _debouncer = Debouncer(delay: const Duration(milliseconds: 700));
  }

  void _navigateToWhatsApp(String phoneNumber) {
    final text = Uri.encodeComponent('Hello, I invite you to join our app!');
    final url = 'https://wa.me/+91$phoneNumber?text=$text';
    log('WhatsApp URL: $url', name: 'ReferralDetailsScreen');
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      color: const Color(0xff454545).withOpacity(0.3),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding22,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/play_gift.svg',
                height: SizeConfig.padding16,
              ),
              SizedBox(
                width: SizeConfig.padding6,
              ),
              'You can earn upto *₹1Lakh* by referring!'.beautify(
                boldStyle: TextStyles.sourceSansB.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
                style: TextStyles.sourceSans.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            height: SizeConfig.padding40,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF454545).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.padding36),
                  child: TextFormField(
                    controller: controller,
                    style: TextStyles.sourceSans.body3.colour(Colors.white),
                    onChanged: (query) {
                      log('Text changed: $query');
                      _debouncer.call(() => searchContacts(query));
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'number length should be greater than 3';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      hintText: "Search by name",
                      hintStyle: TextStyles.sourceSans.body3
                          .colour(Colors.white.withOpacity(0.3)),
                      errorStyle:
                          TextStyles.sourceSans.body3.colour(Colors.red),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          ListView.separated(
            itemCount: filteredContacts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              return Row(
                children: [
                  Container(
                    height: SizeConfig.padding44,
                    width: SizeConfig.padding44,
                    padding: EdgeInsets.all(SizeConfig.padding3),
                    decoration: const ShapeDecoration(
                      shape: OvalBorder(
                        side: BorderSide(width: 0.5, color: Color(0xFF1ADAB7)),
                      ),
                    ),
                    child: Container(
                      height: SizeConfig.padding38,
                      width: SizeConfig.padding38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          contact.displayName.substring(0, 1),
                          style: TextStyles.rajdhaniSB.body0
                              .colour(const Color(0xFF3A3A3C)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
                      ),
                      Text(
                        'Invite and earn ₹500',
                        style: TextStyles.sourceSans.body4
                            .colour(Colors.white.withOpacity(0.48)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _navigateToWhatsApp(contact.phoneNumber);
                    },
                    child: Text(
                      'INVITE',
                      textAlign: TextAlign.right,
                      style: TextStyles.rajdhaniB.body3
                          .colour(const Color(0xFF61E3C4)),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: SizeConfig.padding24,
              );
            },
          ),
          SizedBox(
            height: SizeConfig.navBarHeight * 2.5,
          ),
        ],
      ),
    );
  }
}
