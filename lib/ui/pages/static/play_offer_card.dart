import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferCard extends StatelessWidget {
  final PromoCardModel model;
  final bool shimmer;

  OfferCard({this.model, this.shimmer = false});

  calculateWidth() {
    if (model.gridX != null) {
      if (model.gridX == 1)
        return SizeConfig.screenWidth * 0.5;
      else
        return SizeConfig.screenWidth * 0.85;
    } else
      return SizeConfig.screenWidth * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (model.actionUri != null) {
          print(model.actionUri.toString());
          if (model.actionUri.startsWith("http")) {
            if (await canLaunch(model.actionUri)) {
              launch(model.actionUri);
            }
          } else {
            AppState.delegate.parseRoute(Uri.parse(model.actionUri));
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness24),
        child: Container(
          width: calculateWidth(),
          height: SizeConfig.screenWidth * 0.28,
          margin: EdgeInsets.only(
            bottom: SizeConfig.screenWidth * 0.1,
            right: SizeConfig.pageHorizontalMargins,
          ),
          decoration: (model.bgImage == null || model.bgImage.isEmpty)
              ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.germsPattern),
                      fit: BoxFit.cover),
                  color: model.bgColor != null
                      ? Color(model.bgColor)
                      : UiConstants.tertiarySolid,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 30,
                      color: model.bgColor != null
                          ? Color(model.bgColor).withOpacity(0.3)
                          : UiConstants.tertiarySolid.withOpacity(0.3),
                      offset: Offset(
                        0,
                        SizeConfig.screenWidth * 0.14,
                      ),
                      spreadRadius: -44,
                    )
                  ],
                )
              : BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(model.bgImage),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 30,
                      color: model.bgColor != null
                          ? Color(model.bgColor).withOpacity(0.3)
                          : UiConstants.tertiarySolid.withOpacity(0.3),
                      offset: Offset(
                        0,
                        SizeConfig.screenWidth * 0.14,
                      ),
                      spreadRadius: -44,
                    )
                  ],
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SizeConfig.roundness32),
            child: Shimmer(
              enabled: shimmer,
              child: (model.bgImage == null || model.bgImage.isEmpty)
                  ? Container(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.07,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.title ?? "",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyles.body2.colour(Colors.white).bold,
                          ),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            model.subtitle ?? "",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyles.body2.colour(Colors.white).bold,
                          ),
                          SizedBox(
                            height: SizeConfig.padding8,
                          ),
                          (model.buttonText != null)
                              ? Container(
                                  alignment: Alignment.center,
                                  width: SizeConfig.screenWidth * 0.171,
                                  height: SizeConfig.screenWidth * 0.065,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    model.buttonText ?? "Button",
                                    style: TextStyles.body4
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final CouponModel model;
  final bool shimmer;
  final Function onPressed;

  CouponCard({this.model, this.shimmer = false, this.onPressed});

  // calculateWidth() {
  //   if (model.gridX != null) {
  //     if (model.gridX == 1)
  //       return SizeConfig.screenWidth * 0.5;
  //     else
  //       return SizeConfig.screenWidth * 0.85;
  //   } else
  //     return SizeConfig.screenWidth * 0.5;
  // }

  @override
  Widget build(BuildContext context) {
    return model.priority == 1
        ? InkWell(
            onTap: () async {
              if (onPressed != null) onPressed();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.roundness24),
              child: Container(
                width: SizeConfig.screenWidth * 0.85,
                height: SizeConfig.screenWidth * 0.28,
                margin: EdgeInsets.only(
                  bottom: SizeConfig.screenWidth * 0.1,
                  // right: SizeConfig.pageHorizontalMargins,
                ),
                decoration: (model.additionals.bgImage == null ||
                        model.additionals.bgImage.isEmpty)
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.germsPattern),
                            fit: BoxFit.cover),
                        color: model.additionals.bgColor != null
                            ? Color(model.additionals.bgColor)
                            : UiConstants.tertiarySolid,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: model.additionals.bgColor != null
                                ? Color(model.additionals.bgColor)
                                    .withOpacity(0.3)
                                : UiConstants.tertiarySolid.withOpacity(0.3),
                            offset: Offset(
                              0,
                              SizeConfig.screenWidth * 0.14,
                            ),
                            spreadRadius: -44,
                          )
                        ],
                      )
                    : BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                model.additionals.bgImage),
                            fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: model.additionals.bgColor != null
                                ? Color(model.additionals.bgColor)
                                    .withOpacity(0.3)
                                : UiConstants.tertiarySolid.withOpacity(0.3),
                            offset: Offset(
                              0,
                              SizeConfig.screenWidth * 0.14,
                            ),
                            spreadRadius: -44,
                          )
                        ],
                      ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                  child: Shimmer(
                    enabled: shimmer,
                    child: (model.additionals.bgImage == null ||
                            model.additionals.bgImage.isEmpty)
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.07,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTitle(),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: TextStyles.body2
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text(
                                        getSubtitle(),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: TextStyles.body2
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding8,
                                      ),
                                    ],
                                  ),
                                ),
                                if (model.additionals.btnText != null)
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding12),
                                    //width: SizeConfig.screenWidth * 0.171,
                                    height: SizeConfig.screenWidth * 0.065,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      model.additionals.btnText ?? "Button",
                                      style: TextStyles.body4
                                          .colour(Colors.white)
                                          .bold,
                                    ),
                                  )
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  getTitle() {
    String title = "";
    if (model.code.isNotEmpty) title = model.code;
    if (model.additionals.title.isNotEmpty) title = model.additionals.title;
    return title;
  }

  getSubtitle() {
    String subtitle = "";
    if (model.description.isNotEmpty) subtitle = model.description;
    if (model.additionals.subtitle.isNotEmpty)
      subtitle = model.additionals.subtitle;
    return subtitle;
  }
}
