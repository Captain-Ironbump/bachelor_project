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
        child: learners.isEmpty
            ? const Center(child: Text("No data"))
            : CupertinoFormSection.insetGrouped(
                children: List<Widget>.generate(learners.length, (int index) {
                  return CupertinoListTile(
                    additionalInfo: _ObservationCountAdditonalInfo(
                        learnerId: learners[index].learnerId!),
                    title: Text(
                        "${learners[index].firstName} ${learners[index].lastName}"),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => context.pushNamed('ObservationLearner',
                        pathParameters: {
                          'id': learners[index].learnerId.toString()
                        }),
                  );
                }),
              ),
      ),
    );
  }
}

class _ObservationCountAdditonalInfo extends StatelessWidget {
  final int learnerId;

  const _ObservationCountAdditonalInfo({required this.learnerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetObservationsCountCubit, GetObservationsCountState>(
      builder: (context, state) {
        if (state is GetObservationsCountLoaded) {
          if (state.countMap != null &&
              state.countMap!.containsKey(learnerId.toString()) &&
              state.countMap![learnerId.toString()] != null) {
            return Text(
              '${state.countMap![learnerId.toString()]!.count}/${state.countMap![learnerId.toString()]!.countWithTimespan}',
            );
          } else {
            return const SizedBox.shrink(); // or any fallback widget you prefer
          }
        }
        return const CupertinoActivityIndicator();
      },
    );
  }
}
