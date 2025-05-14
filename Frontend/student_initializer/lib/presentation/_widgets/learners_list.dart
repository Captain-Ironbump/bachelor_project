import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';

typedef OnTabRoutingCallback = void Function(int learnerId);

class LearnersListWidget extends StatelessWidget {
  final dynamic eventId;
  final List<LearnerDetailEntity> learners;
  final OnTabRoutingCallback onTabRoutingCallback;

  const LearnersListWidget(
      {super.key,
      required this.learners,
      required this.eventId,
      required this.onTabRoutingCallback});

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
                      onTap: () {
                        onTabRoutingCallback(learners[index].learnerId!);
                      });
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
          final entry = state.countMap?[learnerId.toString()];
          //print(entry);
          if (entry != null) {
            return Text(entry.countWithTimespan != null
                ? '${entry.count}/${entry.countWithTimespan}'
                : '${entry.count}');
          } else {
            return const SizedBox.shrink();
          }
        }
        return const CupertinoActivityIndicator();
      },
    );
  }
}
