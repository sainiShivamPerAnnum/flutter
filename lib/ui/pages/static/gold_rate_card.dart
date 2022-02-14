import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CurrentPriceWidget extends StatefulWidget {
  // final AugmontGoldBuyViewModel model;
  // CurrentPriceWidget({this.model});
  final Function fetchGoldRates;
  final double goldprice;
  final bool isFetching;
  final bool mini;

  CurrentPriceWidget(
      {this.fetchGoldRates,
      this.goldprice,
      this.isFetching,
      this.mini = false});

  @override
  _CurrentPriceWidgetState createState() => _CurrentPriceWidgetState();
}

class _CurrentPriceWidgetState extends State<CurrentPriceWidget>
    with SingleTickerProviderStateMixin {
  Animation<Duration> animation;
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(minutes: 3));
    animation = Tween<Duration>(begin: Duration(minutes: 3), end: Duration.zero)
        .animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print(status.toString());
        if (status == AnimationStatus.completed) {
          widget.fetchGoldRates();
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.mini
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Current Gold Price: ",
                style: TextStyles.body3.colour(Colors.black54),
              ),
              widget.isFetching
                  ? SpinKitThreeBounce(
                      size: SizeConfig.body2,
                      color: UiConstants.primaryColor,
                    )
                  : // SizedBox(height: SizeConfig.padding4),
                  Text("₹ ${widget.goldprice.toStringAsFixed(2)}",
                      style: TextStyles.body3.extraBold.colour(Colors.black54)),
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "Valid for next ",
                  style: TextStyles.body4.colour(Colors.grey).light,
                  children: [
                    TextSpan(
                      text:
                          "${animation.value.inMinutes.toString().padLeft(2, '0')}:${(animation.value.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyles.body4
                          .colour(UiConstants.primaryColor)
                          .bold,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            height: SizeConfig.screenWidth * 0.246,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: UiConstants.primaryColor.withOpacity(0.1),
              border: Border.all(width: 1, color: UiConstants.primaryColor),
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Current Price",
                      style: TextStyles.body1.colour(UiConstants.primaryColor),
                    ),
                    Spacer(),
                    widget.isFetching
                        ? SpinKitThreeBounce(
                            size: SizeConfig.body2,
                            color: UiConstants.primaryColor,
                          )
                        : Text(
                            "₹ ${widget.goldprice.toStringAsFixed(2)}",
                            style: TextStyles.body1
                                .colour(UiConstants.primaryColor)
                                .bold,
                          )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Row(
                  children: [
                    Text(
                      "Valid for: ",
                      style: TextStyles.body4
                          .colour(UiConstants.primaryColor)
                          .light,
                    ),
                    Text(
                      '${animation.value.inMinutes.toString().padLeft(2, '0')}:${(animation.value.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyles.body4
                          .colour(UiConstants.primaryColor)
                          .bold,
                    )
                  ],
                )
              ],
            ),
          );
  }
}
