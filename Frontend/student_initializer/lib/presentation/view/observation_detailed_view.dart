import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learner_by_id/get_learner_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id/get_observation_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/_widgets/tag_widget.dart';

class ObservationDetailedView extends StatelessWidget {
  const ObservationDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    final dateWidget = context.select<GetObservationByIdWithTagsCubit, Widget>((cubit) {
      final state = cubit.state;
      if (state is GetObservationDetailByIdWithTagsLoaded) {
        final createdDate = DateTime.tryParse(state.observation!.observationDetail!.createdDate ?? '');

        return Text(
          DateFormat.yMMMMd().format(createdDate!),
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
        );
      }

      if (state is GetObservationDetailByIdLoading) {
        return const BaseIndicator();
      }

      return const SizedBox.shrink();
    });

    final learnerTitle = context.select<GetLearnerByIdCubit, Widget>((cubit) {
      final state = cubit.state;
      if (state is GetLearnerByIdLoaded) {
        return Text(
          '${state.learner!.firstName![0]}. ${state.learner!.lastName!} -',
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
        );
      }

      if (state is GetObservationDetailByIdLoading) {
        return const BaseIndicator();
      }

      return const SizedBox.shrink();
    });

    return Container(
      color: CupertinoColors.systemGrey6,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              learnerTitle,
              const SizedBox(width: 4.0),
              dateWidget,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: CupertinoColors.systemGrey4,
                        width: 0.5,
                      ),
                    ),
                    child: BlocBuilder<GetObservationByIdWithTagsCubit,
                        GetObservationDetailByIdWithTagsState>(
                      builder: (context, state) {
                        print(
                            "🎯 BlocBuilder for GetObservationByIdWithTagsCubit triggered with state: $state");

                        if (state is GetObservationDetailByIdWithTagsLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.observation!.observationDetail!.observation}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 12.0),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: state.observation!.tags?.map((tag) {
                                  return TagWidget(
                                    tagName: tag.tag ?? "Unknown",
                                    tagColor: tag.tagColor ?? "systemBlue",
                                  );
                                }).toList() ?? [],
                              ),
                            ],
                          );
                        }

                        if (state is GetObservationDetailByIdWithTagsLoading) {
                          return const BaseIndicator();
                        }

                        return const SizedBox.shrink();
                      },
                    ),
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
