import 'package:flutter/cupertino.dart';
import 'package:student_initializer/presenter/widgets/competence_slider.dart';
import 'package:student_initializer/presenter/widgets/scoring_slider.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';

class StudentSliderPage extends StatefulWidget {
  final PageArgs args;

  const StudentSliderPage({super.key, required this.args});

  @override
  State<StudentSliderPage> createState() => _StudentSliderPageState();
}

class _StudentSliderPageState extends State<StudentSliderPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.args.previousPageTitle,
        middle: const Text('Student Competences Info'),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 2.0),
          color: CupertinoColors.white,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Center(
                      child: CompetenceSlider(
                        competence: 'This is a test',
                      ),
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
