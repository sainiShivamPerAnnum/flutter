import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TambolaMiniInfoCard extends StatelessWidget {
  const TambolaMiniInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, int>(
        builder: (context, count, child) => GestureDetector(
              onTap: () {
                AppState.delegate!.parseRoute(Uri.parse("tambolaHome"));
              },
              child: Card(
                  margin: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins,
                    top: SizeConfig.pageHorizontalMargins,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12)),
                  color: UiConstants.darkPrimaryColor4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding16,
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Row(children: [
                      SvgPicture.asset(
                        Assets.tambolaCardAsset,
                        width: SizeConfig.padding40,
                      ),
                      SizedBox(width: SizeConfig.padding10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    count > 0
                                        ? "Tambola Tickets"
                                        : "Get your first free tambola ticket",
                                    style: TextStyles.rajdhaniM.body0
                                        .colour(Colors.white),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (count > 0)
                        Row(
                          children: [
                            SizedBox(width: SizeConfig.pageHorizontalMargins),
                            Text(
                              count.toString(),
                              style: TextStyles.rajdhaniB.title3
                                  .colour(Colors.white),
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            SvgPicture.asset(
                              Assets.chevRonRightArrow,
                              color: Colors.white,
                            )
                          ],
                        )
                    ]),
                  )),
            ),
        selector: (p0, p1) => p1.tambolaTicketCount);
  }
}
