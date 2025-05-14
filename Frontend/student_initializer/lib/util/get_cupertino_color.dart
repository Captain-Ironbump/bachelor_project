import 'package:flutter/cupertino.dart';

class CupertinoColorHelper {
  static Color? getCupertinoColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return CupertinoColors.systemRed;
      case 'blue':
        return CupertinoColors.systemBlue;
      case 'green':
        return CupertinoColors.systemGreen;
      case 'yellow':
        return CupertinoColors.systemYellow;
      case 'orange':
        return CupertinoColors.systemOrange;
      case 'pink':
        return CupertinoColors.systemPink;
      case 'purple':
        return CupertinoColors.systemPurple;
      case 'teal':
        return CupertinoColors.systemTeal;
      case 'indigo':
        return CupertinoColors.systemIndigo;
      case 'grey':
      case 'gray':
        return CupertinoColors.systemGrey;
      case 'white':
        return CupertinoColors.systemGrey5;
      case 'brown':
        return CupertinoColors.systemBrown;
      case 'black':
        return CupertinoColors.black;
      default:
        return null; // Return null if no match is found
    }
  }
}
