import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class EventInstructionsModal extends StatelessWidget {
  final List instructions;
  EventInstructionsModal({@required this.instructions});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              Row(
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
              Divider(
                height: 32,
                thickness: 2,
              ),
              Column(
                children: List.generate(
                  instructions.length,
                  (i) => InfoTile(
                    leadingIcon: Icons.info,
                    title: instructions[i],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
