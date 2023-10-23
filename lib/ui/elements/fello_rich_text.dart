import 'package:flutter/material.dart';

class FelloRichText extends RichText {
  final String paragraph;
  final TextStyle? style;

  FelloRichText({
    required this.paragraph,
    this.style,
    super.key,
  }) : super(
          text: renderedWidget(paragraph, style),
          textAlign: TextAlign.center,
        );

  static TextSpan renderedWidget(String paragraph, TextStyle? style) {
    if (paragraph.isEmpty ||
        (!paragraph.contains("*") && !paragraph.contains("_"))) {
      return TextSpan(
        text: paragraph,
        style: style,
      );
    }

    String snip = '';
    List<TextSpan> groups = [];
    bool isBoldOn = false;
    bool isItalicsOn = false;
    for (final element in paragraph.runes) {
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
            groups.add(
              TextSpan(
                text: snip,
                style: style?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (isItalicsOn) {
            isItalicsOn = false;
            groups.add(
              TextSpan(
                text: snip,
                style: style?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          } else {
            groups.add(
              TextSpan(
                text: snip,
                style: style,
              ),
            );
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
          style: style,
        ),
      );
    }

    return TextSpan(children: groups);
  }
}
