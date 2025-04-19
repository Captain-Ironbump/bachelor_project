import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';

typedef OnCallback = void Function(bool isSuccessfull);

class TimespanSettingForm extends StatelessWidget {
  final GetSettingsIntState state;
  final OnCallback callback;

  const TimespanSettingForm(
      {super.key, required this.state, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        child: CupertinoFormSection.insetGrouped(
          header: const Text("App Config"),
          children: [
            CupertinoListTile(
              additionalInfo:
                  Text((state as GetSettingsIntLoaded).value.toString()),
              title: const Text("Timespan in Days"),
              trailing: const CupertinoListTileChevron(),
              onTap: () async {
                final result = await context.push('/settings/timespan');
                callback(result as bool);
              },
            )
          ],
        ),
      ),
    );
  }
}
