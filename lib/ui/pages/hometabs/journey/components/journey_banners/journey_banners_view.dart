import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class JourneyBannersView extends StatelessWidget {
  const JourneyBannersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<JourneyBannersViewModel>(
      onModelReady: (model) => model.loadOfferList(),
      builder: (ctx, model, child) {
        return Positioned(
          bottom: SizeConfig.navBarHeight * 0.74,
          child: SafeArea(
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.navBarHeight * 0.64,
              child: !model.isOfferListLoading && model.offerList.isNotEmpty
                  ? PageView.builder(
                      controller: model.promoPageController,
                      itemCount: model.offerList.length,
                      itemBuilder: (cntx, i) {
                        return Container(
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0),
                            width: SizeConfig.screenWidth,
                            child: ListTile(
                              minVerticalPadding: SizeConfig.padding10,
                              leading: model.offerList[i].bgImage != null
                                  ? Container(
                                      width: SizeConfig.padding54,
                                      height: SizeConfig.padding54,
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
                              title: Text(
                                model.offerList[i].title ?? "Hello World",
                                style: TextStyles.rajdhaniEB.body0.bold
                                    .colour(Colors.white),
                              ),
                              subtitle: Text(
                                model.offerList[i].subtitle ??
                                    "Welcome to this Universe and win a lot of prizes and gold",
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.white),
                              ),
                              trailing: Icon(Icons.arrow_right_rounded,
                                  color: Colors.white),
                            ));
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
