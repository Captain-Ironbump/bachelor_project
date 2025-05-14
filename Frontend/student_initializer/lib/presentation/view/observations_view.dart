import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/learners_list.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';

class ObservationsView extends StatefulWidget {
  final String title;
  final OnTabRoutingCallback onTabRoutingCallback;

  const ObservationsView(
      {super.key, required this.title, required this.onTabRoutingCallback});

  @override
  State<ObservationsView> createState() => _ObservationsViewState();
}

class _ObservationsViewState extends State<ObservationsView> {
  List<int>? learners;
  int? timespanInDays;
  bool triggered = false;

  void tryTriggerObservationCount(BuildContext context) {
    if (learners != null && timespanInDays != null && !triggered) {
      triggered = true;
      context.read<GetObservationsCountCubit>().getObservationCountWithQueries(
          timespanInDays: timespanInDays!, learners: learners!, eventId: null);
    }
  }

  void _refreshAllAndTrigger(BuildContext context) {
    setState(() {
      triggered = false;
      learners = null;
      timespanInDays = null;
    });

    context.read<GetLearnersCubit>().getAllLearnerDetails();
    context.read<GetSettingsIntCubit>().getSettingsValueByKey(
          key: "timespanInDays",
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetLearnersCubit, GetLearnersState>(
          listener: (context, state) {
            if (state is GetLearnersLoaded) {
              learners =
                  state.learners!.map((learner) => learner.learnerId!).toList();
              tryTriggerObservationCount(context);
            }
          },
        ),
        BlocListener<GetSettingsIntCubit, GetSettingsIntState>(
          listener: (context, state) {
            if (state is GetSettingsIntLoaded) {
              timespanInDays = state.value;
              tryTriggerObservationCount(context);
            }
          },
        ),
      ],
      child: _ObservationsView(
        title: widget.title,
        callback: () {
          _refreshAllAndTrigger(context);
        },
        onTabRoutingCallback: (int learnerId) {
          widget.onTabRoutingCallback(learnerId);
        },
      ),
    );
  }
}

typedef OnCallback = void Function();
typedef OnTabRoutingCallback = void Function(int learnerId);

class _ObservationsView extends StatelessWidget {
  final String title;
  final OnCallback callback;
  final OnTabRoutingCallback onTabRoutingCallback;

  const _ObservationsView(
      {required this.title,
      required this.callback,
      required this.onTabRoutingCallback});

  Future<void> _onRefresh(BuildContext context) async {
    callback();
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
                      eventId: -1,
                      onTabRoutingCallback: (int learnerId) {
                        onTabRoutingCallback(learnerId);
                      },
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
