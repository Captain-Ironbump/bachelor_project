import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Homepage'),
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
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Center(
                  child: CupertinoButton.filled(
                    child: const Text('Student init with Sliders'),
                    onPressed: () => Navigator.of(context, rootNavigator: true).push(
                      AppRoutes.studentSliderPage.route(
                        PageArgs(previousPageTitle: 'HomePage')
                      )
                    ),
                  ),
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}