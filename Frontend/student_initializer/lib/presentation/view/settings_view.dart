import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/timespan_setting_form.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_bool/get_settings_bool_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_bool/save_settings_bool_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_int/save_settings_int_cubit.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';

class SettingsView extends StatelessWidget {
  final String title;
  const SettingsView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BlocBuilder<GetSettingsIntCubit, GetSettingsIntState>(
                builder: (context, state) {
                  if (state is GetSettingsIntError) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RetryButton(
                          retryAction: () async {
                            await context
                                .read<GetSettingsIntCubit>()
                                .getSettingsValueByKey(key: "timespanInDays");
                          },
                          text: state.message),
                    );
                  }

                  if (state is GetSettingsIntLoaded) {
                    return TimespanSettingForm(
                        state: state,
                        callback: (isSuccessfull) {
                          if (isSuccessfull) {
                            context
                                .read<GetSettingsIntCubit>()
                                .getSettingsValueByKey(
                                  key: "timespanInDays",
                                );
                          }
                        });
                  }

                  if (state is GetSettingsIntLoading) {
                    return const BaseIndicator();
                  }

                  return const SizedBox.shrink();
                },
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: CupertinoFormSection.insetGrouped(
                    header: const Text("Sorting Config"),
                    children: [
                      CupertinoListTile(
                        title: const Text("Sort Order"),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () async {
                          final cubit = context.read<SortOrderCubit>();
                          final result =
                              await context.push('/settings/sortOrder');
                          if (result != null && result is bool && result) {
                            cubit.getSettingsValueByKey(
                              key: "sortOrder",
                            );
                          }
                        },
                        additionalInfo:
                            BlocBuilder<SortOrderCubit, GetSettingsStringState>(
                          builder: (context, state) {
                            if (state is GetSettingsStringLoaded) {
                              return Text(state.value!);
                            }
                            if (state is GetSettingsStringLoading) {
                              return const BaseIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      CupertinoListTile(
                        title: const Text("Sort Parameter"),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () async {
                          final cubit = context.read<SortParameterCubit>();
                          final result =
                              await context.push('/settings/sortParameter');
                          if (result != null && result is bool && result) {
                            cubit.getSettingsValueByKey(
                              key: "sortParameter",
                            );
                          }
                        },
                        additionalInfo: BlocBuilder<SortParameterCubit,
                            GetSettingsStringState>(
                          builder: (context, state) {
                            if (state is GetSettingsStringLoaded) {
                              return Text(state.value!);
                            }
                            if (state is GetSettingsStringLoading) {
                              return const BaseIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: CupertinoFormSection.insetGrouped(
                    header: const Text("Event Config"),
                    children: [
                      CupertinoListTile(
                        title: const Text("With Learner Count"),
                        trailing: BlocBuilder<EventWithLearnerCountCubit, GetSettingsBoolState>(
                          builder: (context, state) {
                            final value = (state is GetSettingsBoolLoaded) ? state.value! : false;
                            return CupertinoSwitch(
                              value: value,
                              onChanged: (newValue) async {
                                context.read<SaveSettingsBoolCubit>().saveSettingsKeyValueBoolPair(
                                  key: "withLearnerCount",
                                  value: newValue,
                                );
                                context.read<EventWithLearnerCountCubit>().getSettingsValueByKey(
                                  key: "withLearnerCount",
                                );
                              },
                            );
                          },
                        ),
                      ),
                      CupertinoListTile(
                        title: const Text("Sort Reason"),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () async {
                          final cubit = context.read<EventSortReasonCubit>();
                          final result =
                              await context.push('/settings/eventSortReason');
                          if (result != null && result is bool && result) {
                            cubit.getSettingsValueByKey(
                              key: "eventSortReason",
                            );
                          }
                        },
                        additionalInfo: BlocBuilder<EventSortReasonCubit,
                            GetSettingsStringState>(
                          builder: (context, state) {
                            if (state is GetSettingsStringLoaded) {
                              return Text(state.value!);
                            }
                            if (state is GetSettingsStringLoading) {
                              return const BaseIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoFormSection.insetGrouped(
                  header: const Text("Learner Sorting Config"),
                  children: [
                    CupertinoListTile(
                      title: const Text("Sort By"),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () async {
                        final cubit = context.read<LearnerSortByCubit>();
                        final result = 
                            await context.push('/settings/learnerSortBy');
                        if (result != null && result is bool && result) {
                          cubit.getSettingsValueByKey(
                            key: "learnerSortBy",
                          );
                        }
                      },
                      additionalInfo: BlocBuilder<LearnerSortByCubit,
                          GetSettingsStringState>(
                        builder: (context, state) {
                          if (state is GetSettingsStringLoaded) {
                            return Text(state.value!);
                          }
                          if (state is GetSettingsStringLoading) {
                            return const BaseIndicator();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    CupertinoListTile(
                      title: const Text("Sort Order"),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () async {
                        final cubit = context.read<LearnerSortOrderCubit>();
                        final result =
                            await context.push('/settings/learnerSortOrder');
                        if (result != null && result is bool && result) {
                          cubit.getSettingsValueByKey(
                            key: "learnerSortOrder",
                          );
                        }
                      },
                      additionalInfo: BlocBuilder<LearnerSortOrderCubit,
                          GetSettingsStringState>(
                        builder: (context, state) {
                          if (state is GetSettingsStringLoaded) {
                            return Text(state.value!);
                          }
                          if (state is GetSettingsStringLoading) {
                            return const BaseIndicator();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoFormSection.insetGrouped(
                  header: const Text("Data Management"),
                  children: [
                    CupertinoListTile(
                      title: const Text('Tags'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        context.push('/settings/tags');
                      },
                    ),
                    CupertinoListTile(
                      title: const Text('Events'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        context.push('/settings/events');
                      },
                    ),
                    CupertinoListTile(
                      title: const Text('Learners'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        context.push('/settings/learners');
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoFormSection.insetGrouped(
                  header: const Text("Markdown Generation"),
                  children: [
                    CupertinoListTile(
                      title: const Text('Endpoint'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () async {
                        final cubit = context.read<MarkdownUsedEndpointCubit>();
                        final result =
                            await context.push('/settings/markdownEndpoint');
                        if (result != null && result is bool && result) {
                          cubit.getSettingsValueByKey(
                            key: "markdownUsedEndpoint",
                          );
                        }
                      },
                      additionalInfo:
                          BlocBuilder<MarkdownUsedEndpointCubit,
                              GetSettingsStringState>(
                        builder: (context, state) {
                          if (state is GetSettingsStringLoaded) {
                            return Text(state.value!);
                          }
                          if (state is GetSettingsStringLoading) {
                            return const BaseIndicator();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
