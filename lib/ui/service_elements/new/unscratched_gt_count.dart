import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class UnscratchedGTCountChip extends StatelessWidget {
  final WinViewModel model;
  UnscratchedGTCountChip({@required this.model});
  @override
  Widget build(BuildContext context) {
    return model.showUnscratchedCount && model.unscratchedGTCount != 0
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding10,
            ),
            child: Text("${model.unscratchedGTCount} New"),
          )
        : Text(
            'See All',
            style: TextStyles.sourceSans.body3.colour(Colors.white),
          );
  }
}
