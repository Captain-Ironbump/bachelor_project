import 'package:flutter/cupertino.dart';
import 'package:student_initializer/data_old/remote/models/learner.dart';
import 'package:student_initializer/util/argumets/learner_page_arguments.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';

class LearnersForm extends StatelessWidget {
  late List<LearnerModel> learners = [];

  LearnersForm({super.key, required this.learners});

  void _learnerNavigator(BuildContext context, LearnerModel learner) {
    Navigator.of(context).push(
        AppRoutes.learnerPage.route(
          LearnerPageArgs(
            previousPageTitle: 'Learner', 
            learner: learner,
          )
        )
    );
  }

  Widget _formUI(BuildContext context) {
    return Form(
      child: CupertinoFormSection.insetGrouped(
        children: List<Widget>.generate(learners.length, (int index) {
          return CupertinoListTile(
            title: Text(
                "${learners[index].firstName} ${learners[index].lastName}"),
            trailing: const CupertinoListTileChevron(),
            onTap: () => _learnerNavigator(context, learners[index]),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _formUI(context);
  }
}
