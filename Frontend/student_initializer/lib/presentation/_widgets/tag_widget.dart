import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/get_cupertino_color.dart';

class TagWidget extends StatelessWidget {
  final String tagName;
  final String tagColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const TagWidget({
    super.key,
    required this.tagName,
    required this.tagColor,
    this.fontSize = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  });

  Color _getTextColor(String colorName) {
    final color = CupertinoColorHelper.getCupertinoColor(colorName);
    if (color == null) {
      return CupertinoColors.black;
    }

    final brightness = color.computeLuminance();
    return brightness > 0.5 ? CupertinoColors.black : CupertinoColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: CupertinoColorHelper.getCupertinoColor(tagColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        tagName,
        style: TextStyle(
          color: _getTextColor(tagColor),
          fontSize: fontSize,
        ),
      ),
    );
  }
}