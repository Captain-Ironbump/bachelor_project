import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/learners_list.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';

class ObservationsView extends StatelessWidget {
  final String title;
  const ObservationsView({super.key, required this.title});

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<GetLearnersCubit>().getAllLearnerDetails();
    final state = context.read<GetLearnersCubit>().state;
    if (state is GetLearnersLoaded) {
      final learnerIds = state.learners!.map((e) => e.learnerId!).toList();
      context.read<GetObservationsCountCubit>().getObservationCountWithQueries(
            timespanInDays: 14,
            learners: learnerIds,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => _onRefresh(context),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BlocBuilder<GetLearnersCubit, GetLearnersState>(
                builder: (context, state) {
                  if (state is GetLearnersError) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: RetryButton(
                          retryAction: context
                              .read<GetLearnersCubit>()
                              .getAllLearnerDetails,
                          text: state.message),
                    );
                  }

                  if (state is GetLearnersLoaded) {
                    return LearnersListWidget(
                      learners: state.learners!,
                    );
                  }

                  if (state is GetLearnersLoading) {
                    return const BaseIndicator();
                  }

                  return const SizedBox.shrink();
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
