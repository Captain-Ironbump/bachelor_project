import 'package:flutter/cupertino.dart';
import 'package:student_initializer/presenter/student_text_field_page.dart';
import 'package:student_initializer/presenter/chat_bot_page.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';
import 'styles.dart';

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: MyCupertinoAppHomePage(),
    );
  }
}

class MyCupertinoAppHomePage extends StatelessWidget {
  const MyCupertinoAppHomePage({super.key});

  Widget buildPage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_up_arrow_down_circle_fill), label: 'LLM'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill), label: 'ChatBot'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), label: 'Settings'),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;

        switch (index) {
          case 0:
            const String title = 'Homepage';
            returnValue = CupertinoTabView(
              builder: (context) {
                return Container(
                  color: CupertinoColors.white,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      const CupertinoSliverNavigationBar(
                        largeTitle: Text(title),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                            ),
                            Center(
                              child: CupertinoButton.filled(
                                child: const Text('Student init with Text Field'),
                                onPressed: () => Navigator.of(context, rootNavigator: true).push(
                                  AppRoutes.studentTextFieldPage.route(
                                    PageArgs(previousPageTitle: 'HomePage')
                                  )
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
            break;
          case 1:
          // This is the Chat Bot page
            returnValue = CupertinoTabView(
              builder: (context) {
                return const ChatBotPage();
              },
            );
            break;
          case 2:
          // Handle the third tab (Settings) here
            returnValue = CupertinoTabView(
              builder: (context) {
                return const Center(child: Text('Settings'));
              },
            );
            break;
          default:
            returnValue = CupertinoTabView(
              builder: (context) {
                return const Center(child: Text('Default Tab'));
              },
            );
        }

        return returnValue;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}
