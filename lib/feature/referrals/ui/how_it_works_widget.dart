import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HowItWorksWidget extends StatefulWidget {
  const HowItWorksWidget(
      {required this.onStateChanged, super.key, this.isBoxOpen = true});

  final Function onStateChanged;
  final bool isBoxOpen;

  @override
  State<HowItWorksWidget> createState() => _HowItWorksWidgetState();
}

class _HowItWorksWidgetState extends State<HowItWorksWidget> {
  bool isBoxOpen = false;

  @override
  void initState() {
    super.initState();
    isBoxOpen = widget.isBoxOpen;
  }

  String get text1 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][0]['text'];

  String get text2 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][1]['text'];

  String get text3 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][2]['text'];

  String get image1 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][0]['image'];

  String get image2 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][1]['image'];

  String get image3 => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.revamped_referrals_config)['how'][2]['image'];

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
                  margin: EdgeInsets.only(left: SizeConfig.padding36),
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
                                  SvgPicture.network(
                                    image1,
                                    width: SizeConfig.padding32,
                                    height: SizeConfig.padding44,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding88,
                                    child: Text(
                                      text1,
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
                                    child: SvgPicture.network(
                                      image2,
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
                                      text2,
                                      textAlign: TextAlign.center,
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.network(
                                    image3,
                                    width: SizeConfig.padding32,
                                    height: SizeConfig.padding40,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding8,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding88,
                                    child: Text(
                                      text3,
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
