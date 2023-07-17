import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralHome extends StatelessWidget {
  ReferralHome({super.key});

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: UiConstants.kReferralHeaderColor,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xff181818),
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
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                decoration: BoxDecoration(
                  color: UiConstants.kReferralHeaderColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.roundness12),
                    bottomRight: Radius.circular(SizeConfig.roundness12),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding54,
                  ),
                  child: Column(
                    children: [
                      // SizedBox(height: SizeConfig.padding12),
                      Container(
                        height: SizeConfig.padding128,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff1F1F1F),
                        ),
                        child: Center(
                          child: Text(
                            "Lottie",
                            style: TextStyles.body3.colour(Colors.white),
                          ),
                        ),
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
                      Text(
                        'per Referral',
                        style: TextStyles.rajdhaniB.title1.colour(Colors.white),
                      ),
                      SizedBox(height: SizeConfig.padding18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: SizeConfig.padding6,
                            height: SizeConfig.padding6,
                            margin: EdgeInsets.only(top: SizeConfig.padding8),
                            decoration: const ShapeDecoration(
                              color: Color(0xFF61E3C4),
                              shape: OvalBorder(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppConfig.getValue(
                                      AppConfigKey.app_referral_message)
                                  .toString(),
                              style: TextStyles.body3.colour(Colors.white70),
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
                  _controller.animateTo(_controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
              )
            ],
          ),
        ),
      ),
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
