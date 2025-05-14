import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/timespan_setting_form.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_bool/get_settings_bool_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
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
                        trailing: const CupertinoListTileChevron(),
                        onTap: () async {
                          final cubit = context.read<EventWithLearnerCountCubit>();
                          final result =
                              await context.push('/settings/learnercount');
                          if (result != null && result is bool && result) {
                            cubit.getSettingsValueByKey(
                              key: "withLearnerCount",
                            );
                          }
                        },
                        additionalInfo:
                            BlocBuilder<EventWithLearnerCountCubit, GetSettingsBoolState>(
                          builder: (context, state) {
                            if (state is GetSettingsBoolLoaded) {
                              return Text('${state.value!}');
                            }
                            if (state is GetSettingsBoolLoading) {
                              return const BaseIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      CupertinoListTile(
                        title: const Text("Sort Reason"),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () async {
                          final cubit = context.read<EventSortReasonCubit>();
                          final result =
                              await context.push('/settings/sortreason');
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
              )
            ]),
          )
        ],
      ),
    );
  }
}
