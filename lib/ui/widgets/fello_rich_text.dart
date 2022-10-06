import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloRichText extends RichText {
  final String paragraph;

  FelloRichText({Key key, @required this.paragraph})
      : super(
          key: key,
          text: renderedWidget(paragraph),
          textAlign: TextAlign.center,
        );

  static TextSpan renderedWidget(String paragraph) {
    try {
      if (paragraph.isEmpty ||
          (!paragraph.contains("*") && !paragraph.contains("_"))) {
        return new TextSpan(
            text: paragraph,
            style: TextStyles.sourceSans.body1.colour(UiConstants.kTextColor));
      }

      String snip = '';
      List<TextSpan> groups = [];
      bool isBoldOn = false;
      bool isItalicsOn = false;
      paragraph.runes.forEach((element) {
        var character = String.fromCharCode(element);
        if (character == '*' || character == '_') {
          if (snip == '') {
            //this is the start of a text span
            if (character == '*') isBoldOn = true;
            if (character == '_') isItalicsOn = true;
          } else {
            //this is the end of either a bold text or an italics text
            if (isBoldOn) {
              isBoldOn = false;
              groups.add(TextSpan(
                text: snip,
                style:
                    TextStyles.sourceSansB.body1.colour(UiConstants.kTextColor),
              ));
            } else if (isItalicsOn) {
              isItalicsOn = false;
              groups.add(TextSpan(
                text: snip,
                style: TextStyles.sourceSans.body1
                    .colour(UiConstants.kTextColor3)
                    .italic,
              ));
            } else {
              groups.add(TextSpan(
                text: snip,
                style:
                    TextStyles.sourceSans.body1.colour(UiConstants.kTextColor2),
              ));
              if (character == '*') isBoldOn = true;
              if (character == '_') isItalicsOn = true;
            }
            snip = '';
          }
        } else {
          snip = snip + character;
        }
      });

      if (snip != null && snip.isNotEmpty) {
        groups.add(TextSpan(
          text: snip,
          style: TextStyles.sourceSans.body1.colour(UiConstants.kTextColor2),
        ));
      }
      return new TextSpan(children: groups);
    } catch (e) {
      return const TextSpan();
    }
  }
}
