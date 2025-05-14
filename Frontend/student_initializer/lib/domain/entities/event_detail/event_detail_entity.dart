import 'package:equatable/equatable.dart';

class EventDetailEntity extends Equatable {
  final int? eventId;
  final String? name;
  final int? learnerCount;

  const EventDetailEntity({
    this.eventId,
    this.name,
    this.learnerCount,
  });

  @override
  List<Object?> get props => [
        eventId,
        name,
        learnerCount,
      ];
}
