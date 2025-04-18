import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';

class NewStudentPage extends StatelessWidget {
  final PageArgs args;

  const NewStudentPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.chevron_down), 
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
        ),
        middle: const Text('Hi'),
      ),
      child: SizedBox(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    child: Text('Hi'),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}