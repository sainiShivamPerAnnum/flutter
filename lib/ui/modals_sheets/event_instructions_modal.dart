import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class EventInstructionsModal extends StatelessWidget {
  final List instructions;
  EventInstructionsModal({@required this.instructions});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.pageHorizontalMargins,
                  left: SizeConfig.pageHorizontalMargins,
                  right: SizeConfig.pageHorizontalMargins,
                ),
                child: Row(
                  children: [
                    Text(
                      "How to participate",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        icon: Icon(
                          Icons.close,
                          size: SizeConfig.iconSize1,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 32,
                thickness: 2,
              ),
              Column(
                children: List.generate(
                  instructions.length,
                  (i) => Container(
                    margin: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding6,
                          horizontal: SizeConfig.padding20),
                      leading: CircleAvatar(
                        backgroundColor: UiConstants.tertiarySolid,
                        radius: SizeConfig.body1,
                        child: Text(
                          "${i + 1}",
                          style: TextStyles.body2.bold.colour(Colors.white),
                        ),
                      ),
                      title: Text(instructions[i]),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              )
            ],
          ),
        ),
      ],
    );
  }
}
