import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/learners_list.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners_by_event_id/get_learners_by_event_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';

typedef OnTapRoutingCallback = void Function(int learnerId);

class LearnersView extends StatefulWidget {
  final dynamic eventId;
  final OnTapRoutingCallback onTapRoutingCallback;
  final Function(List<int> selectedLearnerIds) onAddLearnersToEventCallback;

  const LearnersView(
      {super.key,
      required this.eventId,
      required this.onTapRoutingCallback,
      required this.onAddLearnersToEventCallback});

  @override
  State<LearnersView> createState() => _LearnersViewState();
}

class _LearnersViewState extends State<LearnersView> {
  List<int>? learners;
  int? timespanInDays;
  bool triggered = false;
  List<int>? allLearners;

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
          BlocListener<GetLearnersCubit, GetLearnersState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is GetLearnersLoaded) {
                print("GetLearnersCubit Listener");
                setState(() {
                  allLearners = state.learners!
                      .map((learner) => learner.learnerId!)
                      .toList();
                });
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
          ),
        ],
        child: _LearnersView(
          parentContext: context,
          callback: () {
            _refreshAllAndTrigger(context);
          },
          onTabRoutingCallback: (int learnerId) {
            _route(learnerId);
          },
          onAddLearnersToEventCallback: (List<int> selectedLearnerIds) {
            widget.onAddLearnersToEventCallback(selectedLearnerIds);
          },
        ));
  }
}

typedef OnCallback = void Function();

class _LearnersView extends StatelessWidget {
  final BuildContext parentContext;
  final OnTabRoutingCallback onTabRoutingCallback;
  final OnCallback callback;
  final Function(List<int> selectedLearnerIds) onAddLearnersToEventCallback;

  const _LearnersView(
      {required this.callback,
      required this.onTabRoutingCallback,
      required this.onAddLearnersToEventCallback,
      required this.parentContext});

  Future<void> _onRefresh(BuildContext context) async {
    callback();
  }

  void _showLinkLearnerToEventDialog(BuildContext context) {
    final allLearnersState = context.read<GetLearnersCubit>().state;
    final learnersState = context.read<GetLearnersByEventIdCubit>().state;

    // Ladeindikator, falls Daten noch nicht geladen
    if (allLearnersState is! GetLearnersLoaded ||
        learnersState is! GetLearnersByEventIdLoaded) {
      showCupertinoDialog(
        context: context,
        builder: (_) => const CupertinoAlertDialog(
          content: CupertinoActivityIndicator(),
        ),
      );
      return;
    }

    final allLearners = allLearnersState.learners!;
    final learnersInEvent =
        learnersState.learners!.map((l) => l.learnerId!).toSet();

    // Map für die Auswahl (true = verknüpft)
    final Map<int, bool> selectedMap = {
      for (final learner in allLearners)
        learner.learnerId!: learnersInEvent.contains(learner.learnerId)
    };

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final height = MediaQuery.of(context).size.height * 0.9;
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: height,
                child: CupertinoPopupSurface(
                  isSurfacePainted: false,
                  child: Container(
                    color: CupertinoColors.systemGrey6,
                    child: CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          delegate: MyNav(
                            onPressedCallback: () {
                              final selectedLearnerIds = selectedMap.entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .toList();
                              onAddLearnersToEventCallback(selectedLearnerIds);
                              Navigator.of(context).pop();
                            },
                          ),
                          pinned: true,
                          floating: false,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final learner = allLearners[index];
                              return CupertinoListTile(
                                title:
                                    Text('${learner.firstName!} ${learner.lastName!}'),
                                trailing: CupertinoSwitch(
                                  value: selectedMap[learner.learnerId!] ?? false,
                                  onChanged: (bool value) {
                                    setState(() {
                                      selectedMap[learner.learnerId!] = value;
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMap[learner.learnerId!] =
                                        !selectedMap[learner.learnerId!]!;
                                  });
                                },
                              );
                            },
                            childCount: allLearners.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add_circled_solid),
              onPressed: () => _showLinkLearnerToEventDialog(parentContext),
            ),
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

typedef OnPressedCallback = void Function();

class MyNav extends SliverPersistentHeaderDelegate {
  final OnPressedCallback onPressedCallback;

  const MyNav({required this.onPressedCallback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    TextStyle navTitleTextStyle =
        CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    return Container(
      color: CupertinoColors.systemGrey6,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 40.0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Link Learners to Event',
                style: navTitleTextStyle.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: CupertinoButton(
              onPressed: () {
                onPressedCallback();
              },
              child: const Icon(CupertinoIcons.arrow_right_circle_fill),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70.0;

  @override
  double get minExtent => 70.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
