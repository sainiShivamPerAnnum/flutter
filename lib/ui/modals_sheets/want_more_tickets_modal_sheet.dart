import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class WantMoreTicketsModalSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: CustomPaint(
        size: Size(
          SizeConfig.screenWidth,
          (SizeConfig.screenWidth * 1.321256038647343).toDouble(),
        ),
        painter: TicketModalCustomBackground(),
        child: Container(
          alignment: Alignment.bottomCenter,
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.only(top: SizeConfig.screenWidth * 0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.scaffoldMargin,
                    vertical: SizeConfig.scaffoldMargin / 2),
                decoration: BoxDecoration(
                  color: UiConstants.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: CircleAvatar(
                    backgroundColor: UiConstants.primaryColor.withOpacity(0.4),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: UiConstants.primaryColor,
                    ),
                  ),
                  title: Text(
                    "Save More Money",
                    style: TextStyles.body1.bold,
                  ),
                  subtitle: Text("Get 1 ticket for every 100",
                      style: TextStyles.body3),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: UiConstants.primaryColor,
                  ),
                ),
              ),
            ),

            //   ListTile(
            //     leading: Icon(Icons.share),
            //     title: Text("Refer your friends",
            //         style: TextStyles.body2.bold),
            //     subtitle: Text("Get 10 tickets per referral",
            //         style: TextStyles.body3),
            //   ),
            //   ListTile(
            //     leading: Icon(Icons.repeat),
            //     title: Text("Set up SIP", style: TextStyles.body2.bold),
            //     subtitle: Text("Earn tickets on the go",
            //         style: TextStyles.body3),
            //   )
            // ],
          ),
        ),
      ),
    );
  }
}

class TicketModalCustomBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.2200018);
    path_0.lineTo(size.width * 0.3330266, size.height * 0.2200018);
    path_0.cubicTo(
        size.width * 0.3619034,
        size.height * 0.2200018,
        size.width * 0.3904662,
        size.height * 0.2154753,
        size.width * 0.4169179,
        size.height * 0.2067057);
    path_0.cubicTo(
        size.width * 0.4699203,
        size.height * 0.1891316,
        size.width * 0.5301739,
        size.height * 0.1889707,
        size.width * 0.5833382,
        size.height * 0.2062596);
    path_0.lineTo(size.width * 0.5852005, size.height * 0.2068647);
    path_0.cubicTo(
        size.width * 0.6118575,
        size.height * 0.2155320,
        size.width * 0.6405652,
        size.height * 0.2200018,
        size.width * 0.6695773,
        size.height * 0.2200018);
    path_0.lineTo(size.width, size.height * 0.2200018);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);
    path_0.lineTo(0, size.height * 0.2200018);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4444444, size.height * 0.2299415);
    path_1.cubicTo(
        size.width * 0.4444444,
        size.height * 0.2237331,
        size.width * 0.4500266,
        size.height * 0.2183218,
        size.width * 0.4579831,
        size.height * 0.2168172);
    path_1.lineTo(size.width * 0.4883551, size.height * 0.2110695);
    path_1.cubicTo(
        size.width * 0.4975870,
        size.height * 0.2093236,
        size.width * 0.5072440,
        size.height * 0.2093236,
        size.width * 0.5164758,
        size.height * 0.2110695);
    path_1.lineTo(size.width * 0.5468478, size.height * 0.2168172);
    path_1.cubicTo(
        size.width * 0.5548043,
        size.height * 0.2183218,
        size.width * 0.5603865,
        size.height * 0.2237331,
        size.width * 0.5603865,
        size.height * 0.2299415);
    path_1.cubicTo(
        size.width * 0.5603865,
        size.height * 0.2301664,
        size.width * 0.5601473,
        size.height * 0.2303473,
        size.width * 0.5598502,
        size.height * 0.2303473);
    path_1.lineTo(size.width * 0.4449807, size.height * 0.2303473);
    path_1.cubicTo(
        size.width * 0.4446836,
        size.height * 0.2303473,
        size.width * 0.4444444,
        size.height * 0.2301664,
        size.width * 0.4444444,
        size.height * 0.2299415);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff34C3A7).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
