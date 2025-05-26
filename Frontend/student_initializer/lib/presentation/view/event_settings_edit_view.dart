import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/cubits/event/get_events/get_events_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/save_event/save_event_cubit.dart';

class EventSettingsEditView extends StatelessWidget {
  final Function(String?) onSaveEvent;
  const EventSettingsEditView({
    super.key,
    required this.onSaveEvent,
  });

  void _showAddEventDialog(BuildContext context) {
    final TextEditingController eventController = TextEditingController();

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
                title: const Text("Add Event"),
                message: CupertinoTextField(
                  controller: eventController,
                  placeholder: "Event-Name",
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      onSaveEvent(eventController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save"),
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
        return BlocListener<SaveEventCubit, SaveEventState>(
            listener: (context, state) {
              if (state is SaveEventLoading) {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const CupertinoAlertDialog(
                    content: CupertinoActivityIndicator(),
                  ),
                );
              } else if (state is SaveEventSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Success'),
                    content: const Text('Event was successfully saved!'),
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
              } else if (state is SaveEventError) {
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
                  middle: const Text("Events"),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showAddEventDialog(context);
                      //Navigator.of(context).pop(true);
                    },
                    child: const Icon(CupertinoIcons.plus_circle_fill),
                  ),
                ),
                child: BlocBuilder<GetEventsCubit, GetEventsState>(
                  builder: (context, state) {
                    if (state is GetEventsLoading) {
                      return CupertinoFormSection.insetGrouped(
                        children: const [
                          BaseIndicator(),
                        ],
                      );
                    }
                    if (state is GetEventsLoaded) {
                      if (state.events!.isEmpty) {
                        return CupertinoFormSection.insetGrouped(
                          children: [
                            const Text("No events found."),
                            CupertinoButton(
                              onPressed: () {
                                context.read<GetEventsCubit>().getAllEvents();
                              },
                              child: const Text("Reload Events"),
                            ),
                          ],
                        );
                      }
                      return CupertinoFormSection.insetGrouped(
                        children: state.events!.map((event) {
                          return CupertinoListTile(
                            title: Text(event.name ?? "Unknown Event"),
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
