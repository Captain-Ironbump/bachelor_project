import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/navigation_provider.dart';
import 'bottom_navbar.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  void _onItemTapped(int index, WidgetRef ref) {
    ref.read(navigationProvider.notifier).update((int state) => index);
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      bottomNavigationBar: _buildBottomNavigationBar(ref),
      body: Container(
        color: CupertinoColors.systemGrey6,
        // Ensure the body has a white background
        child: navigationShell,
      ),
    );
  }

  BottomNavBar _buildBottomNavigationBar(WidgetRef ref) {
    return BottomNavBar(
      onTap: (int index) => _onItemTapped(index, ref),
      currentIndex: navigationShell.currentIndex,
      tabs: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(CupertinoIcons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(CupertinoIcons.eye),
          ),
          label: 'Observations',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(CupertinoIcons.settings),
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
