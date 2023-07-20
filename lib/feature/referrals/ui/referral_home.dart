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
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
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

class ReferralHome extends StatelessWidget {
  ReferralHome({super.key});

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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: UiConstants.kReferralHeaderColor,
          ),
          child: Material(
            child: Stack(
              children: [
                Scaffold(
                  extendBody: true,
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
                  body: SingleChildScrollView(
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
                                  SizedBox(height: SizeConfig.padding6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  create: (_) => ReferralCubit(),
                                  child: HeightAdaptivePageView(
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
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding200,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
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
}


class PermissionModalSheet extends StatelessWidget {
  const PermissionModalSheet({
    super.key,
    required this.widget,
  });

  final InviteContactWidget widget;

  String get referrersCount => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['stats']['referrersCount'];

  String get usersFromReferrals => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['stats']['usersFromReferrals'];

  String get rewardsFromReferrals => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['stats']['rewardsFromReferrals'];

  @override
  Widget build(BuildContext context) {
    return Container(
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
                horizontal: SizeConfig.padding4, vertical: SizeConfig.padding4),
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
                      usersFromReferrals,
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
                      referrersCount,
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
                      rewardsFromReferrals,
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
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.004032258, size.height * 0.09106542);
    path_0.cubicTo(
        size.width * 0.004032258,
        size.height * 0.04364792,
        size.width * 0.03379194,
        size.height * 0.005208333,
        size.width * 0.07050226,
        size.height * 0.005208333);
    path_0.lineTo(size.width * 0.9294968, size.height * 0.005208333);
    path_0.cubicTo(
        size.width * 0.9662065,
        size.height * 0.005208333,
        size.width * 0.9959677,
        size.height * 0.04364792,
        size.width * 0.9959677,
        size.height * 0.09106542);
    path_0.lineTo(size.width * 0.9959677, size.height * 0.5828458);
    path_0.cubicTo(
        size.width * 0.9959677,
        size.height * 0.6302667,
        size.width * 0.9662097,
        size.height * 0.6687042,
        size.width * 0.9294968,
        size.height * 0.6687042);
    path_0.lineTo(size.width * 0.7140290, size.height * 0.6687042);
    path_0.cubicTo(
        size.width * 0.6904452,
        size.height * 0.6687042,
        size.width * 0.6682548,
        size.height * 0.6831208,
        size.width * 0.6541935,
        size.height * 0.7075750);
    path_0.lineTo(size.width * 0.5116258, size.height * 0.9555167);
    path_0.cubicTo(
        size.width * 0.5016774,
        size.height * 0.9728208,
        size.width * 0.4814677,
        size.height * 0.9722042,
        size.width * 0.4721645,
        size.height * 0.9543167);
    path_0.lineTo(size.width * 0.3457258, size.height * 0.7112833);
    path_0.cubicTo(
        size.width * 0.3318806,
        size.height * 0.6846667,
        size.width * 0.3086871,
        size.height * 0.6687042,
        size.width * 0.2838629,
        size.height * 0.6687042);
    path_0.lineTo(size.width * 0.07050226, size.height * 0.6687042);
    path_0.cubicTo(
        size.width * 0.03379194,
        size.height * 0.6687042,
        size.width * 0.004032258,
        size.height * 0.6302667,
        size.width * 0.004032258,
        size.height * 0.5828458);
    path_0.lineTo(size.width * 0.004032258, size.height * 0.09106542);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.013096774;
    paint_0_stroke.color = const Color(0xff62E3C4).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void navigateToWhatsApp(String phoneNumber) {
  final text = Uri.encodeComponent('Hello, I invite you to join our app!');
  final url = 'https://wa.me/+91$phoneNumber?text=$text';
  log('WhatsApp URL: $url', name: 'ReferralDetailsScreen');
  launch(url);
}