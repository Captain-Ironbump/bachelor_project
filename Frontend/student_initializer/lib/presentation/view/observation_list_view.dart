import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:student_initializer/presentation/_widgets/learners_list.dart';
import 'package:student_initializer/presentation/_widgets/observation_detail_widget.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learner_by_id/get_learner_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/generate_markdown_form/generate_markdown_form_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/get_markdown_by_id/get_markdown_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/get_markdowns_by_learner/get_markdowns_by_learner_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/update_markdown_quality/update_markdown_quality_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/presentation/cubits/tag/get_tags/get_tags_cubit.dart';
import 'package:student_initializer/presentation/view/new_observation_popup_view.dart';
import 'package:student_initializer/presentation/view/report_detail_popup_view.dart';
import 'package:student_initializer/presentation/view/reports_popup_view.dart';
import 'package:student_initializer/providers/learner_use_case_provider.dart';
import 'package:student_initializer/providers/markdown_form_use_case_provider.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';
import 'package:student_initializer/providers/tag_use_case_provider.dart';
import 'package:student_initializer/util/share_generator/markdown_creator.dart';

class ObservationListView extends StatefulWidget {
  final int? eventId;
  final OnTabRoutingCallback onTabRoutingCallback;
  const ObservationListView(
      {super.key, required this.eventId, required this.onTabRoutingCallback});

  @override
  State<ObservationListView> createState() => _ObservationListViewState();
}

class _ObservationListViewState extends State<ObservationListView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  String? _sortOrder;
  String? _sortParameter;
  String? _eventName;
  LearnerDetailEntity? _learner;
  int? _timespanInDays;
  bool _hasFetchedObservations = false;
  String? _markdown;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _callShare() {
    if (_markdown != null && _learner != null) {
      final formattedDate =
          DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now());

      final params = ShareParams(files: [
        XFile.fromData(utf8.encode(_markdown!), mimeType: 'text/plain')
      ], fileNameOverrides: [
        'markdown-Test-${_learner!.firstName!}-${_learner!.lastName}-$formattedDate.md'
      ]);
      SharePlus.instance.share(params);
    }
  }

  void _checkAndFetchObservations() {
    if (_sortOrder != null &&
        _sortParameter != null &&
        _timespanInDays != null &&
        !_hasFetchedObservations) {
      if (_learner != null) {
        print("LearnerId: $_learner");
        print(widget.eventId);
        print(_sortOrder!);
        print(_sortParameter!);
        final queryParams = Map<String, dynamic>.of({
          'sort': _sortParameter!,
          'order': _sortOrder!,
          'timespanInDays': _timespanInDays!
        });

        if (widget.eventId! >= 0) {
          queryParams.addEntries([MapEntry('eventId', widget.eventId!)]);
        }

        context
            .read<GetObservationsWithTagsCubit>()
            .getObservationDetailsByLearnerId(
              learnerId: _learner!.learnerId!,
              queryParams: queryParams,
            );
        _hasFetchedObservations = true;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasEventCubit = true;
    try {
      BlocProvider.of<GetEventDetailsByIdCubit>(context, listen: false);
    } catch (_) {
      print("Bloc Provider for GetEventDetailsByIdCubit not provided");
      hasEventCubit = false;
    }

    bool hasMarkdownCubit = true;
    try {
      BlocProvider.of<GenerateMarkdownFormCubit>(context, listen: false);
    } catch (_) {
      print("ERROR: Bloc Provider for GenerateMarkdownFormCubit not provided");
      hasMarkdownCubit = false;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<GetLearnerByIdCubit, GetLearnerByIdState>(
          listener: (context, state) {
            final cubit = context.read<GetLearnerByIdCubit>();
            print('Cubit found: $cubit');
            if (state is GetLearnerByIdLoaded) {
              _learner = state.learner;
              _checkAndFetchObservations();
            }
          },
        ),
        BlocListener<SortOrderCubit, GetSettingsStringState>(
          listener: (context, state) {
            if (state is GetSettingsStringLoaded) {
              _sortOrder = state.value;
              _checkAndFetchObservations();
            }
          },
        ),
        BlocListener<SortParameterCubit, GetSettingsStringState>(
          listener: (context, state) {
            if (state is GetSettingsStringLoaded) {
              print(state.value);
              _sortParameter = state.value;
              _checkAndFetchObservations();
            }
          },
        ),
        BlocListener<GetSettingsIntCubit, GetSettingsIntState>(
          listener: (context, state) {
            if (state is GetSettingsIntLoaded) {
              _timespanInDays = state.value!;
              _checkAndFetchObservations();
            }
          },
        ),
        if (hasEventCubit)
          BlocListener<GetEventDetailsByIdCubit, GetEventDetailsByIdState>(
            listener: (context, state) {
              if (state is GetEventDetailsByIdLoaded) {
                _eventName = state.event!.name!;
              }
            },
          ),
        if (hasMarkdownCubit)
          BlocListener<GenerateMarkdownFormCubit, GenerateMarkdownFormState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is GenerateMarkdownFormLoading) {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    );
                  },
                );
              }

              if (state is GenerateMarkdownFormError ||
                  state is GenerateMarkdownFormLoaded) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state is GenerateMarkdownFormError) {
                // insert werror here
                print("Oh no");
              }

              if (state is GenerateMarkdownFormLoaded) {
                // show status here
                print("Markdown generated");
              }
            },
          )
      ],
      child: _ObservationDetailView(
        animationController: _animationController,
        scaleAnimation: _scaleAnimation,
        eventId: widget.eventId,
        onTabRoutingCallback: (int observationId) {
          widget.onTabRoutingCallback(observationId);
        },
      ),
    );
  }
}

typedef OnTabRoutingCallback = void Function(int observationId);

class _ObservationDetailView extends StatelessWidget {
  final int? eventId;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final OnTabRoutingCallback onTabRoutingCallback;
  final GlobalKey<NavigatorState> _popupNavigatorKey =
      GlobalKey<NavigatorState>();

  _ObservationDetailView(
      {required this.animationController,
      required this.scaleAnimation,
      required this.eventId,
      required this.onTabRoutingCallback});

  void _showShareObservationDialogOld(BuildContext context) {
    final learnerState = context.read<GetLearnerByIdCubit>().state;

    late LearnerDetailEntity learner;
    if (learnerState is GetLearnerByIdLoaded) {
      learner = learnerState.learner!;
    }
    if (learnerState is GetLearnerByIdError) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return const CupertinoAlertDialog(
            title: Text("Error"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }
    if (learnerState is GetLearnerByIdLoading) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return const CupertinoAlertDialog(
            title: Text("Still Loading"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }

    final eventState = context.read<GetEventDetailsByIdCubit>().state;

    late String eventName;
    late dynamic eventId;
    if (eventState is GetEventDetailsByIdLoaded) {
      eventName = eventState.event!.name!;
      eventId = eventState.event!.eventId!;
    }
    if (eventState is GetEventDetailsByIdError) {
      print('No Event');
      eventName = 'NON';
    }
    final observationsState =
        context.read<GetObservationsWithTagsCubit>().state;

    context.read<GenerateMarkdownFormCubit>().generateMarkdownForm(
        eventId: eventId, learnerId: learner.learnerId!, length: "short");

    late List<ObservationDetailWithTagsEntity> observations;
    if (observationsState is GetObservationsWithTagsLoaded) {
      observations = observationsState.observations!;
    }
  }

  void _showShareObservationDialog(
      BuildContext context, int? learnerId, int? eventId) {
    animationController.forward();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final container = ProviderScope.containerOf(context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<GetLearnerByIdCubit>(
              create: (context) => container.read(getLearnerByIdCubitProvider)
                ..getLearnerDetailsById(learnerId: learnerId!),
            ),
            // Insert all settings cubits here
          ],
          child: CupertinoPopupSurface(
            isSurfacePainted: true,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Navigator(
                  key: _popupNavigatorKey,
                  initialRoute: "reports",
                  onGenerateRoute: (settings) {
                    WidgetBuilder builder;
                    switch (settings.name) {
                      case 'reports':
                        builder = (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<GetMarkdownsByLearnerCubit>(
                                  create: (context) => container.read(
                                      getMarkdownFormsByLearnerAndEventCubitProvider)
                                    ..getMarkdownsByLearnerId(
                                        learnerId: learnerId!,
                                        eventId: eventId,
                                        sortBy: 'createdDateTime',
                                        sortOrder: 'DESC',
                                        timespanInDays: 0),
                                ),
                                BlocProvider<GenerateMarkdownFormCubit>(
                                  create: (context) => container
                                      .read(generateMarkdownFormCubitProvider),
                                ),
                                BlocProvider<UpdateMarkdownQualityCubit>(
                                  create: (context) => container
                                      .read(updateMarkdownQualityCubitProvider),
                                ),
                              ],
                              child: ReportsPopupView(
                                  learnerId: learnerId!,
                                  eventId: eventId!,
                                  onChangeRouteCallback: (context, reportId) {
                                    _popupNavigatorKey.currentState?.pushNamed(
                                        "report",
                                        arguments: {'reportId': reportId});
                                  },
                                  onCloseCallback: (context) async {
                                    await animationController.reverse();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  onPressedCallback: (BuildContext context) {
                                    context
                                        .read<GenerateMarkdownFormCubit>()
                                        .generateMarkdownForm(
                                          eventId: eventId,
                                          learnerId: learnerId,
                                          length: "short",
                                        );
                                  }),
                            );
                        // Animation von rechts nach links (reverse)
                        return PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0); // Start von rechts
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          settings: settings,
                        );
                      case 'report':
                        final args = settings.arguments as Map<String, dynamic>;
                        print(args);
                        builder = (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<GetMarkdownByIdCubit>(
                                  create: (context) => container
                                      .read(getMarkdownByIdCubitProvider)
                                    ..getMarkdownById(
                                        reportId: args['reportId']!),
                                ),
                                BlocProvider<UpdateMarkdownQualityCubit>(
                                  create: (context) => container
                                      .read(updateMarkdownQualityCubitProvider),
                                ),
                              ],
                              child: Builder(
                                builder: (context) {
                                  return ReportDetailPopupView(
                                    reportId: args['reportId']!,
                                    onCloseCallback: (context) async {
                                      // Statt pushReplacement einfach pop, um zur alten ReportsPopupView zurückzukehren
                                      Navigator.of(context).pop();
                                    },
                                    onChangeRouteCallback: (context) {},
                                    onUpdateReportCallback:
                                        (reportId, quality) {
                                      context
                                          .read<UpdateMarkdownQualityCubit>()
                                          .updateMarkdownQuality(
                                              reportId: reportId,
                                              quality: quality);
                                    },
                                  );
                                },
                              ),
                            );
                        // Animation von rechts nach links (reverse)
                        return PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0); // Start von rechts
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          settings: settings,
                        );
                      default:
                        builder = (context) => const SizedBox.shrink();
                        return CupertinoPageRoute(
                          builder: builder,
                          settings: settings,
                        );
                    }
                  },
                )),
          ),
        );
      },
    ).then((value) {
      animationController.reverse();
    });
  }

  void _showNewObservationDialog(BuildContext context, dynamic learnerId) {
    animationController.forward();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final container = ProviderScope.containerOf(context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<SaveObservationCubit>(
              create: (context) {
                return container.read(saveObservationProvider);
              },
            ),
            BlocProvider<GetTagsCubit>(
              create: (context) {
                return container.read(getTagsCubitProvider)..fetchAllTags();
              },
            ),
          ],
          child: CupertinoPopupSurface(
            isSurfacePainted: true,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: NewObservationPopupView(
                learnerId: learnerId!,
              ),
            ),
          ),
        );
      },
    ).then((value) {
      if (learnerId != null) {
        final sortOrderCubit = context.read<SortOrderCubit>();
        final sortParameterCubit = context.read<SortParameterCubit>();
        final eventCubit = context.read<GetEventDetailsByIdCubit>();
        final settingsIntCubit = context.read<GetSettingsIntCubit>();

        context
            .read<GetObservationsWithTagsCubit>()
            .getObservationDetailsByLearnerId(
                learnerId: learnerId,
                queryParams: Map<String, dynamic>.of({
                  'sort': (sortParameterCubit.state as GetSettingsStringLoaded)
                      .value!,
                  'order':
                      (sortOrderCubit.state as GetSettingsStringLoaded).value!,
                  'eventId': (eventCubit.state as GetEventDetailsByIdLoaded)
                      .event!
                      .eventId!,
                  'timespanInDays':
                      (settingsIntCubit.state as GetSettingsIntLoaded).value!,
                }));
      }
      animationController.reverse();
    });
  }

  Widget _trailingButtons(BuildContext context, dynamic learnerId) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          onPressed: eventId! == -1
              ? null
              : () => _showShareObservationDialog(context, learnerId, eventId!),
          child: const Icon(CupertinoIcons.doc_text),
        ),
        CupertinoButton(
          disabledColor: CupertinoColors.systemGrey.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          onPressed: eventId! == -1
              ? null
              : () => _showNewObservationDialog(context, learnerId),
          child: const Icon(CupertinoIcons.add_circled_solid),
        )
      ],
    );
  }

  void _onTab(int observationId) {
    onTabRoutingCallback(observationId);
  }

  @override
  Widget build(BuildContext context) {
    final title = context.select<GetLearnerByIdCubit, Widget>((cubit) {
      final state = cubit.state;
      if (state is GetLearnerByIdLoaded) {
        return Text('${state.learner!.firstName} ${state.learner!.lastName}');
      }
      if (state is GetLearnerByIdLoading) {
        return const BaseIndicator();
      }
      if (state is GetLearnerByIdError) {
        return const Text("Error");
      }
      return const SizedBox.shrink();
    });

    final learnerId = context.select<GetLearnerByIdCubit, dynamic>((cubit) {
      final state = cubit.state;
      if (state is GetLearnerByIdLoaded) {
        return state.learner!.learnerId!;
      }
      return null;
    });

    bool hasEventCubit = true;
    try {
      BlocProvider.of<GetEventDetailsByIdCubit>(context, listen: false);
    } catch (_) {
      hasEventCubit = false;
    }

    int? eventId;
    if (hasEventCubit) {
      eventId = context.select<GetEventDetailsByIdCubit, dynamic>((cubit) {
        final state = cubit.state;
        if (state is GetEventDetailsByIdLoaded) {
          return state.event!.eventId!;
        }
        return null;
      });
    }

    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        double scale = 1 - (scaleAnimation.value * 0.1);
        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: Container(
              color: CupertinoColors.systemGrey6,
              child: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: title,
                  trailing: _trailingButtons(context, learnerId),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          BlocBuilder<GetObservationsWithTagsCubit,
                              GetObservationsWithTagsState>(
                            builder: (context, state) {
                              print(
                                  "🎯 BlocBuilder triggered with state: $state");

                              if (state is GetObservationsWithTagsLoaded) {
                                if (state.observations!.isEmpty) {
                                  return const Text("No Data available");
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.observations!.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      key: ValueKey(state.observations![index]
                                          .observationDetail?.observationId),
                                      onTap: () => _onTab(state
                                              .observations![index]
                                              .observationDetail
                                              ?.observationId ??
                                          0),
                                      child: ObservatioDetailWidget(
                                          observationDetailEntity: state
                                                  .observations![index]
                                                  .observationDetail ??
                                              ObservationDetailEntity(),
                                          tags:
                                              state.observations![index].tags ??
                                                  [] // Pass the tags to,
                                          ),
                                    ),
                                  );
                                }
                              }

                              if (state is GetObservationsWithTagsLoading) {
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
              )),
        ),
      ),
    );
  }
}
