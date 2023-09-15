import 'package:felloapp/core/model/tambola_offers_model.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TicketsOffersSection extends StatelessWidget {
  const TicketsOffersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, List<TicketsOffers>?>(
      selector: (p0, p1) => p1.ticketsOffers,
      builder: (context, offers, child) {
        return (offers ?? []).isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSubtitleContainer(
                      title: "Offers",
                      padding: EdgeInsets.only(
                          top: SizeConfig.padding12,
                          left: SizeConfig.pageHorizontalMargins,
                          right: SizeConfig.pageHorizontalMargins,
                          bottom: SizeConfig.padding12)),
                  SizedBox(
                    height: SizeConfig.screenWidth! * 0.36,
                    child: ListView.builder(
                      itemCount: offers!.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins -
                              SizeConfig.padding10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () {
                          AppState.delegate!
                              .parseRoute(Uri.parse(offers[i].deep_uri));
                        },
                        child: Container(
                          height: SizeConfig.padding128,
                          width: SizeConfig.screenWidth! -
                              SizeConfig.pageHorizontalMargins * 2,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding10),
                          child: getChild(offers[i].image),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding10)
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget getChild(String asset) {
    final String ext = asset.split('.').last;

    if (ext == "svg") {
      return SvgPicture.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.cover,
      );
    } else if (ext == "json") {
      return Lottie.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.contain,
      );
    } else {
      return Image.network(
        asset,
        height: SizeConfig.padding128,
        width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        fit: BoxFit.cover,
      );
    }
  }
}
