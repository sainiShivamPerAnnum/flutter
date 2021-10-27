import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OfferCard extends StatelessWidget {
  final PromoCardModel model;
  final bool shimmer;
  OfferCard({this.model, this.shimmer = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConfig.roundness32),
      child: Container(
        width: SizeConfig.screenWidth * 0.5,
        height: SizeConfig.screenWidth * 0.28,
        margin: EdgeInsets.only(
          bottom: SizeConfig.screenWidth * 0.1,
          right: SizeConfig.pageHorizontalMargins,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.germsPattern), fit: BoxFit.cover),
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
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          child: Shimmer(
            enabled: shimmer,
            child: Container(
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
                  if (model.buttonText != null && model.actionUri != null)
                    InkWell(
                      onTap: () {
                        print(model.actionUri.toString());
                        AppState.delegate
                            .parseRoute(Uri.parse(model.actionUri));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth * 0.171,
                        height: SizeConfig.screenWidth * 0.065,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          model.buttonText ?? "Button",
                          style: TextStyles.body4.colour(Colors.white).bold,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
