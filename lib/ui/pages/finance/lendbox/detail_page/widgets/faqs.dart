// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class Faqs extends StatefulWidget {
  const Faqs({
    required this.faqs,
    super.key,
  });

  final List<(String, String)> faqs;

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  late final List<bool> _expansionStatus;

  @override
  void initState() {
    super.initState();
    _expansionStatus = List<bool>.filled(
      widget.faqs.length,
      false,
      growable: false,
    );
  }

  @override
  void dispose() {
    _expansionStatus.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding16,
          ),
          child: Text(
            "Frequently Asked Questions",
            style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
          ),
        ),
        SizedBox(
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  brightness: Brightness.dark,
                ),
                child: ExpansionPanelList(
                  animationDuration: const Duration(
                    milliseconds: 600,
                  ),
                  expandedHeaderPadding: const EdgeInsets.all(0),
                  dividerColor: UiConstants.kDividerColor.withOpacity(0.3),
                  elevation: 0,
                  children: List.generate(
                    widget.faqs.length,
                    (index) => ExpansionPanel(
                      backgroundColor: Colors.transparent,
                      canTapOnHeader: true,
                      headerBuilder: (ctx, isOpen) => Padding(
                        padding: EdgeInsets.only(
                          top: SizeConfig.padding20,
                          left: SizeConfig.pageHorizontalMargins,
                          bottom: SizeConfig.padding20,
                        ),
                        child: Text(
                          widget.faqs[index].$1,
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                      ),
                      isExpanded: _expansionStatus[index],
                      body: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.faqs[index].$2,
                          textAlign: TextAlign.start,
                          style: TextStyles.body3.colour(
                            UiConstants.kFAQsAnswerColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  expansionCallback: (i, isOpen) {
                    setState(() {
                      _expansionStatus[i] = !isOpen;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
