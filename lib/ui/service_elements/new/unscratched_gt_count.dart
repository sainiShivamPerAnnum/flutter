import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UnscratchedGTCountChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.Prizes],
      builder: (context, model, properties) {
        return model?.unscratchedGTList != null &&
                model!.unscratchedGTList!.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding8,
                  vertical: SizeConfig.padding6,
                ),
                child: Text("${model.unscratchedGTList!.length} New"),
              )
            : Text(
                'See All',
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              );
      },
    );
  }
}
