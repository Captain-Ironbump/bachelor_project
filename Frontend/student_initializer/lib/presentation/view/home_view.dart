import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/event_form.dart';
import 'package:student_initializer/presentation/cubits/event/get_events/get_events_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_bool/get_settings_bool_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({super.key, required this.title});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool? _withLearnerCount;
  String? _eventSortReason;

  void _tryTriggerEventFetch(BuildContext context) {
    if (_withLearnerCount != null && _eventSortReason != null) {
      final qParam = {
        'withLearnerCount': _withLearnerCount!,
        'eventSortReason': _eventSortReason!
      };
      print(qParam.toString());
      context.read<GetEventsCubit>().getAllEvents(queryParameter: qParam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(widget.title),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _tryTriggerEventFetch(context);
              await Future.delayed(const Duration(milliseconds: 500));
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(10.0),
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<EventWithLearnerCountCubit,
                        GetSettingsBoolState>(
                      listenWhen: (previous, current) =>
                          previous != current,
                      listener: (context, state) {
                        if (state is GetSettingsBoolLoaded) {
                          _withLearnerCount = state.value!;
                          _tryTriggerEventFetch(context);
                        }
                      },
                    ),
                    BlocListener<EventSortReasonCubit,
                        GetSettingsStringState>(
                      listenWhen: (previous, current) =>
                          previous != current,
                      listener: (context, state) {
                        if (state is GetSettingsStringLoaded) {
                          _eventSortReason = state.value!;
                          _tryTriggerEventFetch(context);
                        }
                      },
                    )
                  ],
                  child: BlocBuilder<GetEventsCubit, GetEventsState>(
                    builder: (context, state) {
                      if (state is GetEventsLoading) {
                        return const BaseIndicator();
                      } else if (state is GetEventsLoaded) {
                        return EventForm(state: state.events!);
                      } else if (state is GetEventsError) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: RetryButton(
                            retryAction: () {
                              final learnerCountCubitState = context
                                  .read<EventWithLearnerCountCubit>()
                                  .state;
                              final eventSortReasonCubitState = context
                                  .read<EventSortReasonCubit>()
                                  .state;

                              final Map<String, dynamic> qParam = Map.of({
                                'withLearnerCount': (learnerCountCubitState
                                        as GetSettingsBoolLoaded)
                                    .value!,
                                'eventSortReason':
                                    (eventSortReasonCubitState
                                            as GetSettingsStringLoaded)
                                        .value!,
                              });

                              context
                                  .read<GetEventsCubit>()
                                  .getAllEvents(queryParameter: qParam);
                            },
                            text: state.message,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 500),
            ]),
          ),
        ],
      ),
    );
  }
}
