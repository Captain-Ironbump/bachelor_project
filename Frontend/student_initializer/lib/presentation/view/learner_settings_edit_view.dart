import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';
import 'package:student_initializer/presentation/cubits/learner/save_learner/save_learner_cubit.dart';

class LearnerSettingsEditView extends StatelessWidget {
  final Function(String?, String?) onSaveLearner;
  const LearnerSettingsEditView({
    super.key,
    required this.onSaveLearner,
  });
  
  void _showAddLearnerDialog(BuildContext context) {
    final TextEditingController learnerFirstNameController = TextEditingController();
    final TextEditingController learnerLastNameController = TextEditingController();

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            } else {
              currentFocus.unfocus();
            }
          },
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CupertinoPopupSurface(
              isSurfacePainted: false,
              child: CupertinoActionSheet(
                title: const Text("Add Learner"),
                message: Column(
                  children: [
                    CupertinoTextField(
                      controller: learnerFirstNameController,
                      placeholder: "First Name",
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: learnerLastNameController,
                      placeholder: "Last Name",
                    ),
                  ],
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      onSaveLearner(
                        learnerFirstNameController.text,
                        learnerLastNameController.text,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<SaveLearnerCubit, SaveLearnerState>(
            listener: (context, state) {
              if (state is SaveLearnerLoading) {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const CupertinoAlertDialog(
                    content: CupertinoActivityIndicator(),
                  ),
                );
              } else if (state is SaveLearnerLoaded) {
                Navigator.of(context, rootNavigator: true).pop();
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Success'),
                    content: const Text('Learner was successfully saved!'),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text('OK'),
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ],
                  ),
                );
              } else if (state is SaveLearnerError) {
                Navigator.of(context, rootNavigator: true).pop();
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Error'),
                    content: Text(state.message ?? 'Unknown error'),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text('OK'),
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
              color: CupertinoColors.systemGrey6,
              child: CupertinoPageScaffold(
                backgroundColor: CupertinoColors.systemGrey6,
                navigationBar: CupertinoNavigationBar(
                  middle: const Text("Learners"),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showAddLearnerDialog(context);
                      //Navigator.of(context).pop(true);
                    },
                    child: const Icon(CupertinoIcons.plus_circle_fill),
                  ),
                ),
                child: BlocBuilder<GetLearnersCubit, GetLearnersState>(
                  builder: (context, state) {
                    if (state is GetLearnersLoading) {
                      return CupertinoFormSection.insetGrouped(
                        children: const [
                          BaseIndicator(),
                        ],
                      );
                    }
                    if (state is GetLearnersLoaded) {
                      if (state.learners!.isEmpty) {
                        return CupertinoFormSection.insetGrouped(
                          children: [
                            const Text("No learners found."),
                            CupertinoButton(
                              onPressed: () {
                                context.read<GetLearnersCubit>().getAllLearnerDetails();
                              },
                              child: const Text("Reload"),
                            ),
                          ],
                        );
                      }
                      return CupertinoFormSection.insetGrouped(
                        children: state.learners!.map((event) {
                          return CupertinoListTile(
                            title: Text(
                              '${event.firstName} ${event.lastName}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ));
      },
    );
  }
}
