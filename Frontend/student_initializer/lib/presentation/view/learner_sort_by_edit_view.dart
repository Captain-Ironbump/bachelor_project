import 'package:flutter/cupertino.dart';
import 'package:student_initializer/presentation/_widgets/generic_settings_form_view.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/providers/settings_use_case_provider.dart';

class LearnerSortByEditView extends StatefulWidget {
  final Function(String) onSave;

  const LearnerSortByEditView({super.key, required this.onSave});

  @override
  State<LearnerSortByEditView> createState() => _LearnerSortByEditViewState();
}

class _LearnerSortByEditViewState extends State<LearnerSortByEditView> {
  int _selectedIndex = 0;
  final List<String> _options = ["lastName", "obs-count"];

  @override
  Widget build(BuildContext context) {
    return GenericSettingsFormView<LearnerSortByCubit, GetSettingsStringState,
            String>(
        title: "Learner Sort By",
        fieldLabel: "Sort By",
        icon: CupertinoIcons.add_circled_solid,
        valueSelector: (state) =>
            state is GetSettingsStringLoaded ? state.value : null,
        onSave: (context, value) {
          print(value);
          widget.onSave(value);
        },
        isLoaded: (state) => state is GetSettingsStringLoaded,
        inputBuilder: (context, value, onChanged) {
          int selectedIndex = _options.indexOf(value ?? _options[0]);
          if (selectedIndex == -1) selectedIndex = 0;
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoFormRow(
                prefix: const Text("Sort By"),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(_options[selectedIndex]),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => Container(
                        height: 200,
                        color: CupertinoColors.systemGrey6,
                        child: SafeArea(
                          top: false,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedIndex),
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                selectedIndex = index;
                              });
                              onChanged(_options[index]);
                            },
                            children: _options
                                .map((e) => Center(child: Text(e)))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
  }
}
