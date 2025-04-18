import 'package:flutter/cupertino.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavigationBarItem> tabs;
  final int currentIndex;
  final void Function(int)? onTap;

  const BottomNavBar({super.key, required this.tabs, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      // fixed because the ios tabbar doesn't change height as well
      height: 55,
      currentIndex: currentIndex,
      onTap: onTap,
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoTheme.of(context).textTheme.textStyle.color ?? CupertinoColors.inactiveGray,
      items: tabs,
    );
  }
}
