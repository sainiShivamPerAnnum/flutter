import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class SipIntro extends StatelessWidget {
  const SipIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF023C40), // #023C40
                    Color(0x00000000), // rgba(0, 0, 0, 0.00)
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(color: UiConstants.kSipBackgroundColor),
            ),
          ],
        ))
      ],
    );
  }
}
