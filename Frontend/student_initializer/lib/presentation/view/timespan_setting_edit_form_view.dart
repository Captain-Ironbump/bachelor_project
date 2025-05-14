import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/config/router/go_router.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_int/save_settings_int_cubit.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';

class TimespanSettingEditFormView extends StatelessWidget {
  TimespanSettingEditFormView({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          navigationBar: CupertinoNavigationBar(
            middle: const Text("Timespan in Days"),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context
                    .read<SaveSettingsIntCubit>()
                    .saveSettingsKeyValueIntPair(
                        key: "timespanInDays",
                        value: int.tryParse(_controller.value.text)!);
                Navigator.of(context).pop(true);
              },
              child: const Icon(CupertinoIcons.check_mark_circled_solid),
            ),
          ),
          child: BlocBuilder<GetSettingsIntCubit, GetSettingsIntState>(
            builder: (context, state) {
              if (state is GetSettingsIntLoaded) {
                _controller.text = state.value.toString();
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    onChanged: () {
                      Form.maybeOf(primaryFocus!.context!)?.save();
                    },
                    child: CupertinoFormSection.insetGrouped(
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: _controller,
                          prefix: const Text("Timespan (Day)"),
                          keyboardType: const TextInputType.numberWithOptions(),
                        )
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )),
    );
  }
}
