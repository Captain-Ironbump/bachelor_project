import 'package:flutter/cupertino.dart';
import 'package:student_initializer/data_old/local/models/competence_information.dart';
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
  Map<String, CompetenceInformation> competences = {};

  void _updateMap(Map<String, double> state) {
    for (var entries in state.entries) {
      setState(() {
        competences.update(entries.key, (value) {
          value.score = entries.value;
          return value;
        });
      });
    }
  }

  @override
  void initState() {
    final initMap = <String, CompetenceInformation>{
      'Competence one for something': CompetenceInformation(
          indicators: ['This and That', 'Very old'], score: 1.0),
      'Competence Two because I can': CompetenceInformation(indicators: [
        'This is awesome',
        'Hello world',
        'Over and Out',
      ], score: 1.0),
    };
    competences.addEntries(initMap.entries);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.args.previousPageTitle,
        middle: const Text('Student Competences Info'),
      ),
      child: SizedBox(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    String competence = competences.keys.elementAt(index);
                    List<String> indicators =
                        competences[competence]!.indicators;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CompetenceSlider(
                            competence: competence,
                            indicators: indicators,
                            callback: (state) => _updateMap(state)),
                      ),
                    );
                  },
                  childCount: competences.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
