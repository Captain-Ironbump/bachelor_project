import 'package:student_initializer/data_old/remote/models/learner.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';

class LearnerPageArgs extends PageArgs {
  final LearnerModel learner;

  LearnerPageArgs({
    required super.previousPageTitle,
    required this.learner,
  });
}
