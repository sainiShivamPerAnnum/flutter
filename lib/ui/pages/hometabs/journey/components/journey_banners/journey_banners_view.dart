import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class JourneyBannersView extends StatelessWidget {
  const JourneyBannersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<JourneyBannersViewModel>(
      onModelReady: (model) => model.loadOfferList(),
      onModelDispose: (model) => model.clear(),
      builder: (ctx, model, child) {
        return Positioned(
          bottom: SizeConfig.navBarHeight,
          child: SafeArea(
            child: Container(
              width: SizeConfig.screenWidth,
              height: kBottomNavigationBarHeight,
              child: !model.isOfferListLoading && model.offerList.isNotEmpty
                  ? PageView.builder(
                      controller: model.promoPageController,
                      itemCount: model.offerList.length,
                      itemBuilder: (cntx, i) {
                        return Container(
                          padding: EdgeInsets.only(left: SizeConfig.padding16),
                          color: UiConstants.kBackgroundColor,
                          height: kBottomNavigationBarHeight,
                          width: SizeConfig.screenWidth,
                          child: Row(
                            children: [
                              model.offerList[i].bgImage != null
                                  ? Container(
                                      width: kBottomNavigationBarHeight * 0.8,
                                      height: kBottomNavigationBarHeight * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.roundness12),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                model.offerList[i].bgImage),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(width: SizeConfig.padding10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.offerList[i].title ?? "Hello World",
                                      style: TextStyles.rajdhaniEB.body0.bold
                                          .colour(Colors.white),
                                    ),
                                    Text(
                                      model.offerList[i].subtitle ??
                                          "Welcome to this Universe and win ",
                                      style: TextStyles.sourceSans.body4
                                          .colour(Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  AppState.delegate.parseRoute(
                                      Uri.parse(model.offerList[i].actionUri));
                                },
                                icon: Icon(Icons.arrow_right_rounded,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox(),
            ),
          ),
        );
      },
    );
  }
}
