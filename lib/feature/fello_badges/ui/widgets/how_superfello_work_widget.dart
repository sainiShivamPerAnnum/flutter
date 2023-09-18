import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class HowSuperFelloWorksWidget extends StatefulWidget {
  const HowSuperFelloWorksWidget(
      {super.key, this.isBoxOpen = true, required this.superFelloWorks});

  // final Function onStateChanged;
  final bool isBoxOpen;
  final SuperFelloWorks superFelloWorks;

  @override
  State<HowSuperFelloWorksWidget> createState() =>
      _HowSuperFelloWorksWidgetState();
}

class _HowSuperFelloWorksWidgetState extends State<HowSuperFelloWorksWidget> {
  bool isBoxOpen = false;

  @override
  void initState() {
    super.initState();
    isBoxOpen = widget.isBoxOpen;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
        vertical: SizeConfig.padding4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.01, 1.00),
          end: Alignment(0.01, -1),
          colors: [Color(0xFF3A393C), Color(0xFF232326)],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isBoxOpen = !isBoxOpen;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.padding36),
                  child: Text(
                    widget.superFelloWorks.title ?? 'How SuperFello works?',
                    style: TextStyles.rajdhaniSB.body1,
                  ),
                ),
                const Spacer(),
                Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (isBoxOpen)
            SizedBox(
              height: SizeConfig.padding20,
            ),
          isBoxOpen
              ? AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.superFelloWorks.list?[0] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                SizedBox(
                  height: 24,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: SizeConfig.padding1,
                              height: SizeConfig.padding4,
                              decoration: const BoxDecoration(
                                color: Color(0xffA5FCE7),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding4,
                            ),
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Text(
                  widget.superFelloWorks.list?[1] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                SizedBox(
                  height: 24,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: SizeConfig.padding1,
                              height: SizeConfig.padding4,
                              decoration: const BoxDecoration(
                                color: Color(0xffA5FCE7),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding4,
                            ),
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Text(
                        widget.superFelloWorks.list?[2] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2.colour(
                          Colors.white,
                        ),
                      ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
              ],
            ),
          )
              : const SizedBox()
        ],
      ),
    );
  }
}
