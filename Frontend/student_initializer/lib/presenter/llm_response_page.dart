import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/argumets/response_page_arguments.dart';

class LlmResponsePage extends StatelessWidget {
  final ResponsePageArgs args;

  const LlmResponsePage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: args.previousPageTitle,
        middle: const Text('Response'),
      ),
      child: SafeArea(
          child: Container(
            color: CupertinoColors.white,
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(args.response)
                      ]
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}
