import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/learners_list.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners_by_event_id/get_learners_by_event_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';

typedef OnTapRoutingCallback = void Function(int learnerId);

class LearnersView extends StatefulWidget {
  final dynamic eventId;
  final OnTapRoutingCallback onTapRoutingCallback;

  const LearnersView(
      {super.key, required this.eventId, required this.onTapRoutingCallback});

  @override
  State<LearnersView> createState() => _LearnersViewState();
}

class _LearnersViewState extends State<LearnersView> {
  List<int>? learners;
  int? timespanInDays;
  bool triggered = false;

  void _route(int learnerId) {
    widget.onTapRoutingCallback(learnerId);
  }

  void tryTriggerObservationCount(BuildContext context) {
    if (learners != null && timespanInDays != null && !triggered) {
      triggered = true;
      print(widget.eventId);
      final _eventId = widget.eventId ?? -1;
      print(_eventId);
      context.read<GetObservationsCountCubit>().getObservationCountWithQueries(
            timespanInDays: timespanInDays!,
            learners: learners!,
            eventId: _eventId,
          );
    }
  }

  void _refreshAllAndTrigger(BuildContext context) {
    setState(() {
      triggered = false;
      learners = null;
      timespanInDays = null;
    });

    final _eventId = widget.eventId ?? -1;

    context
        .read<GetEventDetailsByIdCubit>()
        .getEventDetailsById(eventId: _eventId);
    context
        .read<GetLearnersByEventIdCubit>()
        .getLearnersByEventId(eventId: _eventId);
    context.read<GetSettingsIntCubit>().getSettingsValueByKey(
          key: "timespanInDays",
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<GetLearnersByEventIdCubit, GetLearnersByEventIdState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is GetLearnersByEventIdLoaded) {
                setState(() {
                  learners = state.learners!
                      .map((learner) => learner.learnerId!)
                      .toList();
                });
                tryTriggerObservationCount(context);
              }
            },
          ),
          BlocListener<GetSettingsIntCubit, GetSettingsIntState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is GetSettingsIntLoaded) {
                setState(() {
                  timespanInDays = state.value;
                });
                tryTriggerObservationCount(context);
              }
            },
          )
        ],
        child: _LearnersView(
          callback: () {
            _refreshAllAndTrigger(context);
          },
          onTabRoutingCallback: (int learnerId) {
            _route(learnerId);
          },
        ));
  }
}

typedef OnCallback = void Function();

class _LearnersView extends StatelessWidget {
  final OnTabRoutingCallback onTabRoutingCallback;
  final OnCallback callback;

  const _LearnersView(
      {required this.callback, required this.onTabRoutingCallback});

  Future<void> _onRefresh(BuildContext context) async {
    callback();
  }

  @override
  Widget build(BuildContext context) {
    final Widget title =
        context.select<GetEventDetailsByIdCubit, Widget>((cubit) {
      final state = cubit.state;
      if (state is GetEventDetailsByIdLoaded) {
        return Text('${state.event!.name}');
      }
      if (state is GetLearnersByEventIdLoading) {
        return const BaseIndicator();
      }
      if (state is GetEventDetailsByIdError) {
        return const Text('Error Happend');
      }
      return const SizedBox.shrink();
    });

    return Container(
        color: CupertinoColors.systemGrey6,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: title,
          ),
          child: Container(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () => _onRefresh(context),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    BlocBuilder<GetLearnersByEventIdCubit,
                        GetLearnersByEventIdState>(
                      builder: (context, state) {
                        final int? eventId = context
                            .select<GetEventDetailsByIdCubit, dynamic>((cubit) {
                          final state = cubit.state;
                          if (state is GetEventDetailsByIdLoaded) {
                            return state.event!.eventId!;
                          }
                          return null;
                        });

                        if (state is GetLearnersByEventIdError) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: RetryButton(
                                retryAction: () => context
                                    .read<GetLearnersByEventIdCubit>()
                                    .getLearnersByEventId(eventId: eventId!),
                                text: state.message),
                          );
                        }

                        if (state is GetLearnersByEventIdLoaded) {
                          return LearnersListWidget(
                            learners: state.learners!,
                            eventId: eventId,
                            onTabRoutingCallback: (learnerId) {
                              onTabRoutingCallback(learnerId);
                            },
                          );
                        }

                        if (state is GetLearnersByEventIdLoading) {
                          return const BaseIndicator();
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
