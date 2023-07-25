import 'dart:developer';

import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/bloc/referral_cubit.dart';
import 'package:felloapp/feature/referrals/ui/how_it_works_widget.dart';
import 'package:felloapp/feature/referrals/ui/invite_contact_widget.dart';
import 'package:felloapp/feature/referrals/ui/referral_list.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/assets.dart';
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

  TextStyle get _selectedTextStyle =>
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  TextStyle get _unselectedTextStyle => TextStyles.sourceSans.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  String get subTitle => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['hero']['subtitle'];

  @override
  Widget build(BuildContext context) {
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) {
        return Material(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: UiConstants.kReferralHeaderColor,
            ),
            child: Stack(
              children: [
                Scaffold(
                  extendBody: true,
                  backgroundColor: const Color(0xff181818),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      controller: _controller,
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        color: const Color(0xff181818),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: UiConstants.kReferralHeaderColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          SizeConfig.roundness12),
                                      bottomRight: Radius.circular(
                                          SizeConfig.roundness12),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding54,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.28),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Win ',
                                                style: TextStyles
                                                    .rajdhaniB.title1
                                                    .colour(Colors.white),
                                              ),
                                              TextSpan(
                                                text: '₹500',
                                                style: TextStyles
                                                    .rajdhaniB.title1
                                                    .colour(const Color(
                                                        0xFFFFD979)),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Transform.translate(
                                          offset:
                                              Offset(0, -SizeConfig.padding10),
                                          child: Text(
                                            'per Referral',
                                            style: TextStyles.rajdhaniB.title1
                                                .colour(Colors.white),
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.padding6),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              style: TextStyles.body3
                                                  .colour(Colors.white70),
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
                                ),
                                Positioned(
                                  child: Lottie.asset(
                                    'assets/lotties/referral_lottie.json',
                                    // height: SizeConfig.padding140,
                                    width: SizeConfig.screenWidth,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                    ),
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            AppState.backButtonDispatcher!
                                                .didPopRoute();
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                                          bottomLeft: Radius.circular(
                                              SizeConfig.roundness16),
                                          bottomRight: Radius.circular(
                                              SizeConfig.roundness16),
                                        ),
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'You’ve earned ',
                                                style: TextStyles
                                                    .rajdhaniSB.body2
                                                    .colour(Colors.white)),
                                            TextSpan(
                                                text: '₹350',
                                                style: TextStyles
                                                    .rajdhaniB.body2
                                                    .colour(const Color(
                                                        0xFFFFD979))),
                                            TextSpan(
                                                text: ' so far!',
                                                style: TextStyles
                                                    .rajdhaniSB.body2
                                                    .colour(Colors.white)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Positioned(
                                    left: SizeConfig.padding24,
                                    top: SizeConfig.padding24,
                                    child: CustomPaint(
                                      size: Size(
                                          SizeConfig.padding8,
                                          (SizeConfig.padding8 * 1.125)
                                              .toDouble()),
                                      painter: ReferralStarCustomPainter(),
                                    ),
                                  ),
                                  Positioned(
                                    left: SizeConfig.padding32,
                                    top: SizeConfig.padding18,
                                    child: CustomPaint(
                                      size: Size(
                                          SizeConfig.padding8,
                                          (SizeConfig.padding8 * 1.125)
                                              .toDouble()),
                                      painter: ReferralStarCustomPainter(),
                                    ),
                                  ),
                                ],
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
                            Column(
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
                                      duration:
                                          const Duration(milliseconds: 500),
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
                                  create: (context) => ReferralCubit(model),
                                  child:
                                      BlocBuilder<ReferralCubit, ReferralState>(
                                    builder: (context, state) {
                                      return HeightAdaptivePageView(
                                        controller: model.pageController,
                                        onPageChanged: (int page) {
                                          model.switchTab(page);
                                        },
                                        children: [
                                          ReferralList(
                                            model: model,
                                          ),
                                          InviteContactWidget(
                                            model: model,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                // SizedBox(
                                //   height: model.tabNo == 0
                                //       ? SizeConfig.padding200
                                //       : SizeConfig.padding1,
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins,
                        vertical: SizeConfig.padding16),
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
                ),
                CustomKeyboardSubmitButton(
                  onSubmit: () {
                    //hide keyboard
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Change the statusBarColor back to the default color here
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change to the default color
    ));
    super.dispose();
  }
}

void navigateToWhatsApp(String phoneNumber) {
  final text = Uri.encodeComponent('Hello, I invite you to join our app!');
  final url = 'https://wa.me/+91$phoneNumber?text=$text';
  log('WhatsApp URL: $url', name: 'ReferralDetailsScreen');
  launch(url);
}

class ReferralRatingSheet extends StatelessWidget {
  const ReferralRatingSheet({
    super.key,
  });

  String get title => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['hero']['subtitle'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff39393C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding16),
          topRight: Radius.circular(SizeConfig.padding16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.padding90 + SizeConfig.padding6,
            height: SizeConfig.padding4,
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(SizeConfig.padding4),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding26,
          ),
          Text('Enjoying Fello?',
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniSB.title4.colour(Colors.white)),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            'Invite your friends and create your community on Fello!',
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body0.colour(
              Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
          SvgPicture.network(
            Assets.peopleGroup,
            height: SizeConfig.padding76,
            width: SizeConfig.padding116,
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
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
                title,
                style: TextStyles.body3.colour(Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          // TextButton(
          //   onPressed: () {
          //     if (Platform.isAndroid) {
          //       BaseUtil.launchUrl(Strings.playStoreUrl);
          //     } else {
          //       BaseUtil.launchUrl(Strings.appStoreUrl);
          //     }
          //   },
          //   child: Text('RATE FELLO',
          //       textAlign: TextAlign.center,
          //       style: TextStyles.rajdhaniB.body0.colour(Colors.white)),
          // ),
          // SizedBox(
          //   height: SizeConfig.padding16,
          // ),
          AppPositiveBtn(
            btnText: "",
            height: SizeConfig.padding56,
            onPressed: () {
              if (locator<ReferralDetailsViewModel>().isShareAlreadyClicked ==
                  false) {
                locator<ReferralService>().shareLink();
              }
            },
            widget: Text(
              'INVITE & EARN ₹500 PER REFERRAL',
              textAlign: TextAlign.center,
              style: TextStyles.rajdhaniB.body0.colour(Colors.white),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
        ],
      ),
    );
  }
}
