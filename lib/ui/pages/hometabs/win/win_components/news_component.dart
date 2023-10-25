import 'dart:math' as math;

import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

List<Color> randomColors = [
  const Color(0xffF79780),
  const Color(0xffEFAF4E),
  const Color(0xff93B5FE),
];

class FelloNewsComponent extends StatelessWidget {
  final WinViewModel model;
  const FelloNewsComponent({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.padding24,
            ),
            child: Text(
              locale.weekHighlights,
              style: TextStyles.sourceSans.semiBold.colour(Colors.white).title3,
            ),
          ),
          SizedBox(height: SizeConfig.padding24),
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth! * 0.4026,
            child: model.isFelloFactsLoading
                ? FullScreenLoader(
                    size: SizeConfig.screenWidth! * 0.4,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: model.fellofacts!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0.0 : SizeConfig.padding20,
                            right: SizeConfig.padding20),
                        height: double.maxFinite,
                        width: SizeConfig.screenWidth! * 0.8,
                        margin: EdgeInsets.only(
                            left: SizeConfig.padding24,
                            right: index == model.fellofacts!.length - 1
                                ? SizeConfig.padding24
                                : 0.0),
                        decoration: BoxDecoration(
                          color: model.fellofacts![index].bgColor == null
                              ? randomColors[
                                  math.Random().nextInt(randomColors.length)]
                              : model.fellofacts![index].bgColor!.toColor(),
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness12)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              model.fellofacts![index].asset!,
                              width: SizeConfig.screenWidth! * 0.25,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: SizeConfig.padding16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      model.fellofacts![index].title!,
                                      style: TextStyles.rajdhaniSB.body1
                                          .colour(UiConstants.kBackgroundColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                  Flexible(
                                    child: Text(
                                      model.fellofacts![index].subTitle!,
                                      style: TextStyles.sourceSans.body4
                                          .colour(UiConstants.kBackgroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
