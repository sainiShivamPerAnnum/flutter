import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseAvatar4 extends StatefulWidget {
  const ChooseAvatar4({Key key}) : super(key: key);

  @override
  State<ChooseAvatar4> createState() => _ChooseAvatar4State();
}

class _ChooseAvatar4State extends State<ChooseAvatar4> {
  PageController _controller;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _controller = PageController(
      viewportFraction: 0.43,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.screenWidth * 0.570),
        Text(
          'What avatar suits you the best?',
          style: TextStyles.rajdhaniSB.title5,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          'Swipe to choose your avatar',
          style: TextStyles.sourceSans.body3.colour(
            UiConstants.kTextColor.withOpacity(0.5),
          ),
        ),
        SizedBox(height: SizeConfig.screenWidth * 0.15),
        Stack(
          children: [
            FelloUserAvatar(),
            Container(
              height: SizeConfig.screenWidth * 0.685,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                controller: _controller,
                onPageChanged: (val) {
                  setState(() {
                    currentIndex = val;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, idx) {
                  return Center(
                    child: AnimatedContainer(
                      width: currentIndex == idx
                          ? SizeConfig.screenWidth * 0.48
                          : SizeConfig.screenWidth * 0.2633,
                      height: currentIndex == idx
                          ? SizeConfig.screenWidth * 0.48
                          : SizeConfig.screenWidth * 0.2633,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: currentIndex == idx ? 1.0 : 0.4,
                        child: SvgPicture.asset(
                          'assets/svg/user_avatar_svg.svg',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FelloUserAvatar extends StatelessWidget {
  const FelloUserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth * 0.66,
        height: SizeConfig.screenWidth * 0.66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF737373).withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Center(
          child: Container(
            width: SizeConfig.screenWidth * 0.54,
            height: SizeConfig.screenWidth * 0.54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: SizeConfig.padding4,
              ),
            ),
            child: Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.4267,
                height: SizeConfig.screenWidth * 0.4267,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff135756).withOpacity(0.6),
                      blurRadius: SizeConfig.screenWidth * 0.143,
                      spreadRadius: SizeConfig.screenWidth * 0.096,
                    ),
                  ],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffD9D9D9),
                    width: SizeConfig.padding2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
