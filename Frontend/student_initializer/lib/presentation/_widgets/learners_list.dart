import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';

class LearnersListWidget extends StatelessWidget {
  final List<LearnerDetailEntity> learners;

  const LearnersListWidget({super.key, required this.learners});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Form(
        child: CupertinoFormSection.insetGrouped(
          children: List<Widget>.generate(learners.length, (int index) {
            return CupertinoListTile(
              additionalInfo: ,
              title: Text(
                  "${learners[index].firstName} ${learners[index].lastName}"),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.pushNamed('ObservationLearner',
                  pathParameters: {'id': learners[index].learnerId.toString()}),
            );
          }),
        ),
      ),
    );
  }
}

class _ObservationCountAdditonalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetObservationsCountCubit, GetObservationsCountState>(
      builder: (context, state) {
        if (true) { // TODO: correct here
          
        }
      },
    );
  }
  
}
