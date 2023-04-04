import 'package:flutter/material.dart';

class PowerPlayBackgroundUi extends StatelessWidget {
  const PowerPlayBackgroundUi(
      {Key? key, required this.child, this.floatingActionButton})
      : super(key: key);

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff21284A),
                  Color(0xff3C2840),
                  Color(0xff772828),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.6, 1],
              ),
            ),
          ),
          child
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
