import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class GameStepper extends StatelessWidget {
  const GameStepper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Column(
        children: [
          for (var val = 0; val < 5; val++)
            Container(
              margin: const EdgeInsets.all(2.0),
              height: (val == 0 || val == 4) ? 3 : 5,
              width: 1.5,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
