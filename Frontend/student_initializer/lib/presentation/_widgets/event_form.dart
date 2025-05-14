import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';

class EventForm extends StatelessWidget {
  final List<EventDetailEntity> state;

  const EventForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: state.isNotEmpty ? Form(
        child: CupertinoFormSection.insetGrouped(
          header: const Text("Events"),
          children: List<Widget>.generate(state.length, (int index) {
            return CupertinoListTile(
              title: Text("${state[index].name}"),
              additionalInfo: state[index].learnerCount != null
                  ? Text("${state[index].learnerCount}")
                  : null,
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.pushNamed('EventLearners',
                  pathParameters: {'eventId': state[index].eventId.toString()}),
            );
          }),
        ),
      ) : const Text('no data'),
    );
  }
}
