import 'package:flutter/cupertino.dart';

class TagColorMapper {
  static const Map<String, Color> dbToCupertino = {
    'RED': CupertinoColors.systemRed,
    'GREEN': CupertinoColors.systemGreen,
    'BLUE': CupertinoColors.systemBlue,
    'YELLOW': CupertinoColors.systemYellow,
    'ORANGE': CupertinoColors.systemOrange,
    'PURPLE': CupertinoColors.systemPurple,
    'PINK': CupertinoColors.systemPink,
    'TEAL': CupertinoColors.systemTeal,
    'CYAN': CupertinoColors.systemTeal, // Kein eigenes Cyan
    'BROWN': CupertinoColors.systemBrown,
    'BLACK': CupertinoColors.black,
    'WHITE': CupertinoColors.white,
    'GRAY': CupertinoColors.systemGrey,
    'GREY': CupertinoColors.systemGrey,
    'LIGHT_GRAY': CupertinoColors.systemGrey2,
    'DARK_GRAY': CupertinoColors.systemGrey4,
    'INDIGO': CupertinoColors.systemIndigo,
    'LIME': CupertinoColors.systemGreen,
    'MAROON': CupertinoColors.systemRed,
    'NAVY': CupertinoColors.systemBlue,
    'OLIVE': CupertinoColors.systemGreen,
  };

  static final Map<Color, String> cupertinoToDb = {
    for (var entry in dbToCupertino.entries) entry.value: entry.key,
  };

  static final List<Color> allCupertinoColors = [
    CupertinoColors.systemRed,
    CupertinoColors.systemGreen,
    CupertinoColors.systemBlue,
    CupertinoColors.systemYellow,
    CupertinoColors.systemOrange,
    CupertinoColors.systemPurple,
    CupertinoColors.systemPink,
    CupertinoColors.systemTeal,
    CupertinoColors.systemBrown,
    CupertinoColors.black,
    CupertinoColors.white,
    CupertinoColors.systemGrey,
    CupertinoColors.systemGrey2,
    CupertinoColors.systemGrey4,
    CupertinoColors.systemIndigo,
  ];

  static Color fromDb(String dbColor) {
    return dbToCupertino[dbColor.toUpperCase()] ?? CupertinoColors.systemGrey;
  }

  static String toDb(Color color) {
    return cupertinoToDb[color] ?? 'GRAY';
  }
}
