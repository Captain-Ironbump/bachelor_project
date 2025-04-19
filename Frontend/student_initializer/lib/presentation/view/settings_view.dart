import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/buttons/retry_button.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/timespan_setting_form.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';

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
              )
            ]),
          )
        ],
      ),
    );
  }
}
