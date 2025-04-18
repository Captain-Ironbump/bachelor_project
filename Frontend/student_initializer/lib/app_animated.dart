import 'package:flutter/cupertino.dart';
import 'package:student_initializer/config/router/go_router.dart';
import 'package:student_initializer/presenter/chat_bot_page.dart';
import 'package:student_initializer/presenter/home_page.dart';
import 'package:student_initializer/presenter/learners_page.dart';

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      theme: const CupertinoThemeData(
        barBackgroundColor: CupertinoColors.systemGrey6,
        scaffoldBackgroundColor: CupertinoColors.systemGrey6,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
        fontSize: 18,
        color: CupertinoColors.black,
      ))),
      routerConfig: GoRouterCustom().router,
    );
  }
}

class MyCupertinoAppHomePage extends StatefulWidget {
  MyCupertinoAppHomePage({super.key});

  final List<Widget> _tabViews = [
    Container(
      key: const ValueKey(0),
      child: const HomePage(),
    ),
    Container(
      key: const ValueKey(1),
      child: const ChatBotPage(),
    ),
    Container(
      key: const ValueKey(2),
      child: const LearnersPage(),
    ),
    Container(
      key: const ValueKey(3),
      child: const Center(
        child: Text('Settings'),
      ),
    )
  ];

  @override
  State<MyCupertinoAppHomePage> createState() => _MyCupertinoAppHomePageState();
}

class _MyCupertinoAppHomePageState extends State<MyCupertinoAppHomePage> {
  int _selectedIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _tabBarView() {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: widget._tabViews[_selectedIndex]);
  }

  _bottomTabBar() {
    return CupertinoTabBar(
      currentIndex: _selectedIndex,
      onTap: _onTabChanged,
      activeColor: CupertinoColors.activeBlue,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_up_arrow_down_circle_fill),
            label: 'LLM'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
            label: 'ChatBot'),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.collections_solid),
          label: 'Learners',
        ),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings), label: 'Settings'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: _bottomTabBar(),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoPageScaffold(
            child: _tabBarView(),
          );
        },
      ),
    );
  }
}
