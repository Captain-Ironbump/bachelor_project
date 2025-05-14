import 'package:flutter/cupertino.dart';

class SpellCheckerController extends TextEditingController {
  final List<String> listErrorTexts;

  SpellCheckerController({super.text, this.listErrorTexts = const []});

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final List<TextSpan> children = [];
    if (listErrorTexts.isEmpty) {
      return TextSpan(text: text, style: style);
    }
    try {
      text.splitMapJoin(
          RegExp(r'\b(' + listErrorTexts.join('|').toString() + r')+\b'),
          onMatch: (m) {
        children.add(TextSpan(
          text: m[0],
          style: style!.copyWith(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.wavy,
              decorationColor: CupertinoColors.systemRed),
        ));
        return "";
      }, onNonMatch: (n) {
        children.add(TextSpan(text: n, style: style));
        return n;
      });
    } on Exception catch (e) {
      return TextSpan(text: text, style: style);
    }
    return TextSpan(children: children, style: style);
  }
}

// https://medium.com/@southxzx/implement-a-simple-spell-checker-system-in-flutter-37b2bd0d63b4