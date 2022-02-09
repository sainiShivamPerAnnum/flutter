import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class EventInstructionsModal extends StatelessWidget {
  const EventInstructionsModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}
