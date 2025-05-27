import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericSettingsFormView<CubitType extends BlocBase<StateType>, StateType, ValueType> extends StatelessWidget {
  final String title;
  final String fieldLabel;
  final IconData icon;
  final ValueType? Function(StateType state) valueSelector;
  final void Function(BuildContext context, ValueType value) onSave;
  final bool Function(StateType state) isLoaded;
  final Widget Function(
    BuildContext context,
    ValueType? value,
    void Function(ValueType newValue) onChanged,
  ) inputBuilder;

  const GenericSettingsFormView({
    super.key,
    required this.title,
    required this.fieldLabel,
    required this.icon,
    required this.valueSelector,
    required this.onSave,
    required this.isLoaded,
    required this.inputBuilder,
  });

  @override
  Widget build(BuildContext context) {
    ValueType? currentValue;

    return Container(
      color: CupertinoColors.systemGrey6,
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentValue != null) {
                onSave(context, currentValue!);
                Navigator.of(context).pop(true);
              }
            },
            child: Icon(icon),
          ),
        ),
        child: BlocBuilder<CubitType, StateType>(
          builder: (context, state) {
            if (isLoaded(state)) {
              currentValue = valueSelector(state);
              print(currentValue);
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: CupertinoFormSection.insetGrouped(
                    children: [
                      inputBuilder(
                        context,
                        currentValue,
                        (newValue) {
                          currentValue = newValue;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}