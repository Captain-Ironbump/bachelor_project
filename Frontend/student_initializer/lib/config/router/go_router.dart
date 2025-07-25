import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/_widgets/scaffold_with_navbar.dart';
import 'package:student_initializer/presentation/cubits/event/add_learners_to_event/add_learners_to_event_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/get_events/get_events_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/save_event/save_event_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learner_by_id/get_learner_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners_by_event_id/get_learners_by_event_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/save_learner/save_learner_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/generate_markdown_form/generate_markdown_form_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/delete_observation/delete_observation_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id/get_observation_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations/get_observations_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_string/save_settings_string_cubit.dart';
import 'package:student_initializer/presentation/cubits/tag/get_tags/get_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/tag/save_tag/save_tag_cubit.dart';
import 'package:student_initializer/presentation/view/event_settings_edit_view.dart';
import 'package:student_initializer/presentation/view/event_sort_reason_edit_view.dart';
import 'package:student_initializer/presentation/view/home_view.dart';
import 'package:student_initializer/presentation/view/learner_settings_edit_view.dart';
import 'package:student_initializer/presentation/view/learner_sort_by_edit_view.dart';
import 'package:student_initializer/presentation/view/learner_sort_order_edit_view.dart';
import 'package:student_initializer/presentation/view/learners_view.dart';
import 'package:student_initializer/presentation/view/observation_detailed_view.dart';
import 'package:student_initializer/presentation/view/observation_list_view.dart';
import 'package:student_initializer/presentation/view/observations_view.dart';
import 'package:student_initializer/presentation/view/report_gen_uri_settings_eddit_view.dart';
import 'package:student_initializer/presentation/view/settings_view.dart';
import 'package:student_initializer/presentation/view/sort_order_edit_view.dart';
import 'package:student_initializer/presentation/view/sort_parameter_edit_view.dart';
import 'package:student_initializer/presentation/view/tags_setting_edit_view.dart';
import 'package:student_initializer/presentation/view/timespan_setting_edit_form_view.dart';
import 'package:student_initializer/providers/event_use_case_provider.dart';
import 'package:student_initializer/providers/learner_use_case_provider.dart';
import 'package:student_initializer/providers/markdown_form_use_case_provider.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';
import 'package:student_initializer/providers/tag_use_case_provider.dart';

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
                                          getLearnersByEventIdCubitProvider),
                                    ),
                                    BlocProvider<GetLearnersCubit>(
                                      create: (context) => container
                                          .read(getLearnersCubitProvider)
                                        ..getAllLearnerDetails(),
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
                                    ),
                                    BlocProvider<AddLearnersToEventCubit>(
                                      create: (context) => container.read(
                                          addLearnersToEventCubitProvider),
                                    ),
                                    BlocProvider<LearnerSortByCubit>(
                                      create: (context) => container.read(
                                          getSettingsStringLearnerSortByCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "learnerSortBy"),
                                    ),
                                    BlocProvider<LearnerSortOrderCubit>(
                                      create: (context) => container.read(
                                          getSettingsStringLearnerSortOrderCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "learnerSortOrder"),
                                    )
                                  ],
                                  child: Builder(
                                    builder: (context) => LearnersView(
                                      eventId: int.tryParse(eventId)!,
                                      onTapRoutingCallback: (int learnerId) {
                                        context.pushNamed(
                                            'EventLearnerObservations',
                                            pathParameters: {
                                              'learnerId': learnerId.toString(),
                                              'eventId': eventId.toString(),
                                            });
                                      },
                                      onAddLearnersToEventCallback:
                                          (List<int> learnerIds) {
                                        context
                                            .read<AddLearnersToEventCubit>()
                                            .addLearnersToEvent(
                                                int.tryParse(eventId)!,
                                                learnerIds);
                                      },
                                    ),
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
                                          BlocProvider<
                                              GetObservationsWithTagsCubit>(
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
                                          BlocProvider<
                                              MarkdownUsedEndpointCubit>(
                                            create: (context) => container.read(
                                                getSettingsStringMarkdownUsedEndpointCubitProvider)
                                              ..getSettingsValueByKey(
                                                  key: "markdownUsedEndpoint"),
                                          ),
                                          BlocProvider<DeleteObservationCubit>(
                                            create: (context) => container.read(
                                                deleteObservatiobCubitProvider),
                                          )
                                        ],
                                        child: Builder(
                                          builder: (context) => BlocListener<
                                              DeleteObservationCubit,
                                              DeleteObservationState>(
                                            listener: (context, state) async {
                                              if (state
                                                  is DeleteObservationSuccess) {
                                                final timespanInDays = (context
                                                            .read<
                                                                GetSettingsIntCubit>()
                                                            .state
                                                        as GetSettingsIntLoaded)
                                                    .value!;
                                                final sortOrder = (context
                                                            .read<SortOrderCubit>()
                                                            .state
                                                        as GetSettingsStringLoaded)
                                                    .value!;
                                                final sortParameter = (context
                                                            .read<
                                                                SortParameterCubit>()
                                                            .state
                                                        as GetSettingsStringLoaded)
                                                    .value!;

                                                await Future.delayed(
                                                    const Duration(seconds: 1));

                                                if (context.mounted) {
                                                  context
                                                      .read<
                                                          GetObservationsWithTagsCubit>()
                                                      .getObservationDetailsByLearnerId(
                                                    learnerId: int.tryParse(
                                                        learnerId)!,
                                                    queryParams: {
                                                      "eventId":
                                                          int.tryParse(eventId),
                                                      "order": sortOrder,
                                                      "sort": sortParameter,
                                                      "timespanInDays":
                                                          timespanInDays,
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            child: ObservationListView(
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
                                                  },
                                                );
                                              },
                                              onObservationDeleteCallback:
                                                  (p0) {
                                                print(
                                                    "Deleting observation: $p0");
                                                context
                                                    .read<
                                                        DeleteObservationCubit>()
                                                    .deleteObservation(
                                                      observationId: p0!,
                                                    );
                                              },
                                            ),
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
                                                    learnerId: int.tryParse(
                                                        learnerId)!),
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
                                    BlocProvider<MarkdownUsedEndpointCubit>(
                                      create: (context) => container.read(
                                          getSettingsStringMarkdownUsedEndpointCubitProvider)
                                        ..getSettingsValueByKey(
                                            key: "markdownUsedEndpoint"),
                                    ),
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
                                    BlocProvider<GetObservationsWithTagsCubit>(
                                      create: (context) => container.read(
                                          getObservationsWithTagsProvider),
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
                                      onObservationDeleteCallback: (p0) {
                                        print("Deleting observation: $p0");
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
                          ),
                          BlocProvider(
                            create: (context) => container.read(
                                getSettingsStringLearnerSortByCubitProvider)
                              ..getSettingsValueByKey(key: "learnerSortBy"),
                          ),
                          BlocProvider(
                            create: (context) => container.read(
                                getSettingsStringLearnerSortOrderCubitProvider)
                              ..getSettingsValueByKey(key: "learnerSortOrder"),
                          ),
                          BlocProvider(
                            create: (context) => container.read(
                                getSettingsStringMarkdownUsedEndpointCubitProvider)
                              ..getSettingsValueByKey(
                                  key: "markdownUsedEndpoint"),
                          ),
                          BlocProvider(
                            create: (context) =>
                                container.read(saveSettingsBoolCubitProvider),
                          ),
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
                        ),
                        GoRoute(
                          path: "tags",
                          name: "Tags",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<GetTagsCubit>(
                                  create: (context) =>
                                      container.read(getTagsCubitProvider)
                                        ..fetchAllTags(),
                                ),
                                BlocProvider<SaveTagCubit>(
                                  create: (context) =>
                                      ProviderScope.containerOf(context,
                                              listen: false)
                                          .read(saveTagCubitProvider),
                                ),
                              ],
                              child: Builder(
                                builder: (context) => TagsSettingEditView(
                                  onTagSaved: (p0) =>
                                      context.read<SaveTagCubit>()
                                        ..saveTag(tagDetailEntity: p0!),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "events",
                          name: "Events",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<GetEventsCubit>(
                                  create: (context) =>
                                      container.read(getEventsCubitProvider)
                                        ..getAllEvents(),
                                ),
                                BlocProvider<SaveEventCubit>(
                                  create: (context) =>
                                      ProviderScope.containerOf(context,
                                              listen: false)
                                          .read(saveEventCubitProvider),
                                ),
                              ],
                              child: Builder(
                                builder: (context) => EventSettingsEditView(
                                  onSaveEvent: (p0) =>
                                      context.read<SaveEventCubit>()
                                        ..saveEvent(name: p0!),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "learners",
                          name: "Learners",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<GetLearnersCubit>(
                                  create: (context) =>
                                      container.read(getLearnersCubitProvider)
                                        ..getAllLearnerDetails(),
                                ),
                                BlocProvider<SaveLearnerCubit>(
                                  create: (context) =>
                                      ProviderScope.containerOf(context,
                                              listen: false)
                                          .read(saveLearnerCubitProvider),
                                ),
                              ],
                              child: Builder(
                                builder: (context) => LearnerSettingsEditView(
                                  onSaveLearner: (p0, p1) =>
                                      context.read<SaveLearnerCubit>()
                                        ..saveLearnerDetail(
                                            firstName: p0!, lastName: p1!),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "learnerSortBy",
                          name: "LearnerSortBy",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<LearnerSortByCubit>(
                                  create: (context) => container.read(
                                      getSettingsStringLearnerSortByCubitProvider)
                                    ..getSettingsValueByKey(
                                        key: "learnerSortBy"),
                                ),
                                BlocProvider<SaveSettingsStringCubit>(
                                  create: (context) => container
                                      .read(saveSettingsStringCubitProvider),
                                )
                              ],
                              child: Builder(
                                builder: (context) => LearnerSortByEditView(
                                  onSave: (p0) => context
                                      .read<SaveSettingsStringCubit>()
                                      .saveSettingsKeyValueStringPair(
                                        key: "learnerSortBy",
                                        value: p0,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "learnerSortOrder",
                          name: "LearnerSortOrder",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<LearnerSortOrderCubit>(
                                  create: (context) => container.read(
                                      getSettingsStringLearnerSortOrderCubitProvider)
                                    ..getSettingsValueByKey(
                                        key: "learnerSortOrder"),
                                ),
                                BlocProvider<SaveSettingsStringCubit>(
                                  create: (context) => container
                                      .read(saveSettingsStringCubitProvider),
                                )
                              ],
                              child: Builder(
                                builder: (context) => LearnerSortOrderEditView(
                                  onSave: (p0) => context
                                      .read<SaveSettingsStringCubit>()
                                      .saveSettingsKeyValueStringPair(
                                        key: "learnerSortOrder",
                                        value: p0,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "markdownEndpoint",
                          name: "MarkdownEndpoint",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                                providers: [
                                  BlocProvider<MarkdownUsedEndpointCubit>(
                                    create: (context) => container.read(
                                        getSettingsStringMarkdownUsedEndpointCubitProvider)
                                      ..getSettingsValueByKey(
                                        key: "markdownUsedEndpoint",
                                      ),
                                  ),
                                  BlocProvider<SaveSettingsStringCubit>(
                                    create: (context) => container
                                        .read(saveSettingsStringCubitProvider),
                                  ),
                                ],
                                child: Builder(
                                  builder: (context) =>
                                      ReportGenUriSettingsEdditView(
                                    onSave: (p0) => context
                                        .read<SaveSettingsStringCubit>()
                                        .saveSettingsKeyValueStringPair(
                                          key: "markdownUsedEndpoint",
                                          value: p0,
                                        ),
                                  ),
                                ));
                          },
                        ),
                        GoRoute(
                          path: "sortOrder",
                          name: "SortOrder",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<SortOrderCubit>(
                                  create: (context) => container.read(
                                      getSettingsStringSortOrderCubitProvider)
                                    ..getSettingsValueByKey(key: "sortOrder"),
                                ),
                                BlocProvider<SaveSettingsStringCubit>(
                                  create: (context) => container
                                      .read(saveSettingsStringCubitProvider),
                                )
                              ],
                              child: Builder(
                                builder: (context) =>
                                    SortOrderEditView(onSave: (p0) {
                                  context
                                      .read<SaveSettingsStringCubit>()
                                      .saveSettingsKeyValueStringPair(
                                        key: "sortOrder",
                                        value: p0,
                                      );
                                }),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "sortParameter",
                          name: "SortParameter",
                          builder: (context, state) {
                            final container =
                                ProviderScope.containerOf(context);
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<SortParameterCubit>(
                                  create: (context) => container.read(
                                      getSettingsStringSortParameterCubitProvider)
                                    ..getSettingsValueByKey(
                                        key: "sortParameter"),
                                ),
                                BlocProvider<SaveSettingsStringCubit>(
                                  create: (context) => container
                                      .read(saveSettingsStringCubitProvider),
                                )
                              ],
                              child: Builder(
                                builder: (context) =>
                                    SortParameterEditView(onSave: (p0) {
                                  context
                                      .read<SaveSettingsStringCubit>()
                                      .saveSettingsKeyValueStringPair(
                                        key: "sortParameter",
                                        value: p0,
                                      );
                                }),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: "eventSortReason",
                          name: "EventSortReason",
                          builder: (context, state) {
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
                                BlocProvider<SaveSettingsStringCubit>(
                                  create: (context) => container
                                      .read(saveSettingsStringCubitProvider),
                                )
                              ],
                              child: Builder(
                                builder: (context) =>
                                    EventSortReasonEditView(onSave: (p0) {
                                  context
                                      .read<SaveSettingsStringCubit>()
                                      .saveSettingsKeyValueStringPair(
                                        key: "eventSortReason",
                                        value: p0,
                                      );
                                }),
                              ),
                            );
                          },
                        )
                      ])
                ])
          ],
        )
      ]);
}
