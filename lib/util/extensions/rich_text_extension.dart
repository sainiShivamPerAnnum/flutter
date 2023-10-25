import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

extension RichTextExtension on String {
  RichText beautify(
      {TextStyle? style,
      TextStyle? boldStyle,
      TextStyle? italicStyle,
      TextAlign? alignment}) {
    try {
      if (isEmpty || (!contains("*") && !contains("_"))) {
        return RichText(
          textAlign: alignment ?? TextAlign.start,
          text: TextSpan(
            text: this,
            style: style ??
                TextStyles.sourceSans.body1.colour(UiConstants.kTextColor),
          ),
        );
      }

      String snip = '';
      List<TextSpan> groups = [];
      bool isBoldOn = false;
      bool isItalicsOn = false;
      for (final element in runes) {
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
                style: boldStyle ??
                    style?.bold ??
                    TextStyles.sourceSansB.body1.colour(UiConstants.kTextColor),
              ));
            } else if (isItalicsOn) {
              isItalicsOn = false;
              groups.add(TextSpan(
                text: snip,
                style: italicStyle ??
                    style?.italic ??
                    TextStyles.sourceSans.body1
                        .colour(UiConstants.kTextColor3)
                        .italic,
              ));
            } else {
              groups.add(TextSpan(
                text: snip,
                style: style ??
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
      }

      if (snip.isNotEmpty) {
        groups.add(
          TextSpan(
            text: snip,
            style: style ??
                TextStyles.sourceSans.body1.colour(UiConstants.kTextColor2),
          ),
        );
      }
      return RichText(
          textAlign: alignment ?? TextAlign.start,
          text: TextSpan(children: groups));
    } catch (e) {
      return RichText(
        textAlign: alignment ?? TextAlign.start,
        text: const TextSpan(),
      );
    }
  }
}

extension OverFlowStringExtension on String {
  String checkOverFlow({maxLength = 30}) {
    return length > maxLength ? "${substring(0, maxLength)}..." : this;
  }
}
