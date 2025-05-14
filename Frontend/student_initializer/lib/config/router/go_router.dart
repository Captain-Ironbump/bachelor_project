import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/_widgets/scaffold_with_navbar.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/get_events/get_events_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learner_by_id/get_learner_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners_by_event_id/get_learners_by_event_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/generate_markdown_form/generate_markdown_form_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id/get_observation_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations/get_observations_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/view/home_view.dart';
import 'package:student_initializer/presentation/view/learners_view.dart';
import 'package:student_initializer/presentation/view/observation_detailed_view.dart';
import 'package:student_initializer/presentation/view/observation_list_view.dart';
import 'package:student_initializer/presentation/view/observations_view.dart';
import 'package:student_initializer/presentation/view/settings_view.dart';
import 'package:student_initializer/presentation/view/timespan_setting_edit_form_view.dart';
import 'package:student_initializer/providers/event_use_case_provider.dart';
import 'package:student_initializer/providers/learner_use_case_provider.dart';
import 'package:student_initializer/providers/markdown_form_use_case_provider.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home_shell');
final GlobalKey<NavigatorState> _observationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'observations_shell');
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings_shell');

class GoRouterCustom {
  final GoRouter router = GoRouter(
      initialLocation: '/home',
      navigatorKey: _rootNavigatorKey,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => ScaffoldWithNavBar(
            navigationShell: navigationShell,
          ),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                initialLocation: '/home',
                navigatorKey: _homeShellNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                      path: '/home',
                      name: 'Home',
                      builder: (context, state) {
                        final container = ProviderScope.containerOf(context);
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<EventSortReasonCubit>(
                              create: (context) => container.read(
                                  getEventSettingsStringSortReasonCubitProvider)
                                ..getSettingsValueByKey(key: "eventSortReason"),
                            ),
                            BlocProvider<EventWithLearnerCountCubit>(
                              create: (context) => container.read(
                                  getSettingsBoolWithLearnerCountCubitProvider)
                                ..getSettingsValueByKey(
                                    key: "withLearnerCount"),
                            ),
                            BlocProvider<GetEventsCubit>(
                              create: (context) =>
                                  container.read(getEventsCubitProvider),
                            )
                          ],
                          child: const HomeView(title: "Dashboard"),
                        );
                      },
                      routes: [
                        GoRoute(
                            path: 'event/:eventId',
                            name: 'EventLearners',
                            builder: (context, state) {
                              final eventId = state.pathParameters['eventId']!;
                              final container =
                                  ProviderScope.containerOf(context);
                              return MultiBlocProvider(
                                  providers: [
                                    BlocProvider<EventSortReasonCubit>(
                                      create: (context) => container.read(
                                          getEventSettingsStringSortReasonCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "eventSortReason"),
                                    ),
                                    BlocProvider<GetLearnersByEventIdCubit>(
                                      create: (context) => container.read(
                                          getLearnersByEventIdCubitProvider)
                                        ..getLearnersByEventId(
                                            eventId: int.tryParse(eventId)!),
                                    ),
                                    BlocProvider<GetSettingsIntCubit>(
                                      create: (context) => container
                                          .read(getSettingsIntCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "timespanInDays"),
                                    ),
                                    BlocProvider<GetEventDetailsByIdCubit>(
                                      create: (context) => container.read(
                                          getEventDetailsByIdCubitProvider)
                                        ..getEventDetailsById(
                                            eventId: int.tryParse(eventId)!),
                                    ),
                                    BlocProvider<GetObservationsCountCubit>(
                                      create: (context) => container
                                          .read(getObservationsCountProvider),
                                    )
                                  ],
                                  child: LearnersView(
                                    eventId: int.tryParse(eventId)!,
                                    onTapRoutingCallback: (int learnerId) {
                                      context.pushNamed(
                                          'EventLearnerObservations',
                                          pathParameters: {
                                            'learnerId': learnerId.toString(),
                                            'eventId': eventId.toString(),
                                          });
                                    },
                                  ));
                            },
                            routes: [
                              GoRoute(
                                  path: "observations/learner/:learnerId",
                                  name: "EventLearnerObservations",
                                  builder: (context, state) {
                                    final eventId =
                                        state.pathParameters['eventId']!;
                                    final learnerId =
                                        state.pathParameters['learnerId']!;
                                    final container =
                                        ProviderScope.containerOf(context);
                                    return MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => container.read(
                                                getSettingsStringSortOrderCubitProvider)
                                              ..getSettingsValueByKey(
                                                  key: "sortOrder"),
                                          ),
                                          BlocProvider(
                                            create: (context) => container.read(
                                                getSettingsStringSortParameterCubitProvider)
                                              ..getSettingsValueByKey(
                                                  key: "sortParameter"),
                                          ),
                                          BlocProvider<GetObservationsCubit>(
                                            create: (context) => container.read(
                                                getObservationsByLearnerIdProvider),
                                          ),
                                          BlocProvider<GetObservationsWithTagsCubit>(
                                            create: (context) => container.read(
                                                getObservationsWithTagsProvider),
                                          ),
                                          BlocProvider<GetLearnerByIdCubit>(
                                            create: (context) => container.read(
                                                getLearnerByIdCubitProvider)
                                              ..getLearnerDetailsById(
                                                  learnerId:
                                                      int.tryParse(learnerId)!),
                                          ),
                                          BlocProvider<SaveObservationCubit>(
                                            create: (context) => container
                                                .read(saveObservationProvider),
                                          ),
                                          BlocProvider<
                                              GetEventDetailsByIdCubit>(
                                            create: (context) => container.read(
                                                getEventDetailsByIdCubitProvider)
                                              ..getEventDetailsById(
                                                  eventId:
                                                      int.tryParse(eventId)!),
                                          ),
                                          BlocProvider<GetSettingsIntCubit>(
                                            create: (context) => container.read(
                                                getSettingsIntCubitProvider)
                                              ..getSettingsValueByKey(
                                                  key: 'timespanInDays'),
                                          ),
                                          BlocProvider<
                                              GenerateMarkdownFormCubit>(
                                            create: (context) => container.read(
                                                generateMarkdownFormCubitProvider),
                                          ),
                                        ],
                                        child: Builder(
                                          builder: (context) =>
                                              ObservationListView(
                                            eventId: int.tryParse(eventId),
                                            onTabRoutingCallback:
                                                (int observationId) {
                                              context.pushNamed(
                                                  'DetailedObservation',
                                                  pathParameters: {
                                                    'observationId':
                                                        observationId
                                                            .toString(),
                                                    'eventId': eventId,
                                                    'learnerId': learnerId,
                                                  });
                                            },
                                          ),
                                        ));
                                  },
                                  routes: [
                                    GoRoute(
                                      path: 'observation/:observationId',
                                      name: 'DetailedObservation',
                                      builder: (context, state) {
                                        final observationId = state
                                            .pathParameters['observationId']!;
                                        final learnerId =
                                          state.pathParameters['learnerId']!;
                                        final container =
                                            ProviderScope.containerOf(context);
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider<
                                                GetObservationByIdWithTagsCubit>(
                                              create: (context) => container.read(
                                                  getObservationByIdWithTagsProvider)
                                                ..getObservationByIdWithTags(
                                                    observationId: int.tryParse(
                                                        observationId)!),
                                            ),
                                            BlocProvider<GetLearnerByIdCubit>(
                                              create: (context) => container.read(
                                                  getLearnerByIdCubitProvider)
                                                ..getLearnerDetailsById(
                                                    learnerId: int.tryParse(learnerId)!),
                                            ),
                                          ],
                                          child: ObservationDetailedView(),
                                        );
                                      },
                                    )
                                  ])
                            ])
                      ])
                ]),
            StatefulShellBranch(
                navigatorKey: _observationsNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                      path: '/observations',
                      name: 'Observations',
                      builder: (context, state) {
                        final container = ProviderScope.containerOf(context);
                        return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) =>
                                    container.read(getLearnersCubitProvider)
                                      ..getAllLearnerDetails(),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    container.read(getSettingsIntCubitProvider)
                                      ..getSettingsValueByKey(
                                          key: "timespanInDays"),
                              ),
                              BlocProvider(
                                create: (context) => container
                                    .read(getObservationsCountProvider),
                              )
                            ],
                            child: ObservationsView(
                              title: 'Observations',
                              onTabRoutingCallback: (int learnerId) {
                                context.pushNamed('ObservationLearner',
                                    pathParameters: {
                                      'id': learnerId.toString(),
                                    });
                              },
                            ));
                      },
                      routes: [
                        GoRoute(
                            path: 'observations/learners/:id',
                            name: 'ObservationLearner',
                            builder: (context, state) {
                              final learnerId = state.pathParameters['id']!;
                              final container =
                                  ProviderScope.containerOf(context);
                              return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => container.read(
                                          getSettingsStringSortOrderCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "sortOrder"),
                                    ),
                                    BlocProvider(
                                      create: (context) => container.read(
                                          getSettingsStringSortParameterCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "sortParameter"),
                                    ),
                                    BlocProvider<GetObservationsCubit>(
                                      create: (context) => container.read(
                                          getObservationsByLearnerIdProvider),
                                    ),
                                    BlocProvider<GetLearnerByIdCubit>(
                                      create: (context) => container
                                          .read(getLearnerByIdCubitProvider)
                                        ..getLearnerDetailsById(
                                            learnerId:
                                                int.tryParse(learnerId)!),
                                    ),
                                    BlocProvider<GetSettingsIntCubit>(
                                      create: (context) => container
                                          .read(getSettingsIntCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: 'timespanInDays'),
                                    )
                                  ],
                                  child: Builder(
                                    builder: (context) => ObservationListView(
                                      eventId: -1,
                                      onTabRoutingCallback:
                                          (int observationId) {
                                        context.pushNamed('', pathParameters: {
                                          'observationId':
                                              observationId.toString()
                                        });
                                      },
                                    ),
                                  ));
                            })
                      ]),
                ]),
            StatefulShellBranch(
                navigatorKey: _settingsNavigatorKey,
                routes: <GoRoute>[
                  GoRoute(
                      path: '/settings',
                      name: 'Settings',
                      builder: (context, state) {
                        final container = ProviderScope.containerOf(context);
                        return MultiBlocProvider(providers: [
                          BlocProvider(
                            create: (context) => container.read(
                                getEventSettingsStringSortReasonCubitProvider)
                              ..getSettingsValueByKey(key: "eventSortReason"),
                          ),
                          BlocProvider(
                            create: (context) => container.read(
                                getSettingsBoolWithLearnerCountCubitProvider)
                              ..getSettingsValueByKey(key: 'withLearnerCount'),
                          ),
                          BlocProvider(
                            create: (context) => container
                                .read(getSettingsIntCubitProvider)
                              ..getSettingsValueByKey(key: "timespanInDays"),
                          ),
                          BlocProvider(
                            create: (context) =>
                                container.read(saveSettingsIntCubitProvider),
                          ),
                          BlocProvider(
                            create: (context) => container
                                .read(getSettingsStringSortOrderCubitProvider)
                              ..getSettingsValueByKey(key: "sortOrder"),
                          ),
                          BlocProvider(
                            create: (context) => container.read(
                                getSettingsStringSortParameterCubitProvider)
                              ..getSettingsValueByKey(key: "sortParameter"),
                          )
                        ], child: const SettingsView(title: "Settings"));
                      },
                      routes: [
                        GoRoute(
                          path: "timespan",
                          name: "Timespan",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => container
                                      .read(getSettingsIntCubitProvider)
                                    ..getSettingsValueByKey(
                                        key: "timespanInDays"),
                                ),
                                BlocProvider(
                                  create: (context) => container
                                      .read(saveSettingsIntCubitProvider),
                                ),
                              ],
                              child: TimespanSettingEditFormView(),
                            );
                          },
                        )
                      ])
                ])
          ],
        )
      ]);
}
