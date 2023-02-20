import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnscratchedGTCountChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<JourneyService>(
      // properties: [JourneyServiceProperties.Prizes],
      builder: (context, model, properties) {
        return model.unscratchedGTList != null &&
                model.unscratchedGTList!.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: UiConstants.primaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding8,
                  vertical: SizeConfig.padding6,
                ),
                child: Text(
                  "${model.unscratchedGTList!.length} " + locale.btnNew,
                  style: TextStyles.body4.colour(UiConstants.primaryColor),
                ),
              )
            : Text(
                locale.btnSeeAll,
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              );
      },
    );
  }
}
