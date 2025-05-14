import 'package:equatable/equatable.dart';

class ObservationDetailEntity extends Equatable {
  final int? observationId;
  final int? learnerId;
  final int? eventId;
  final String? createdDate;
  final String? observation;

  const ObservationDetailEntity({
    this.observationId,
    this.learnerId,
    this.eventId,
    this.createdDate,
    this.observation,
  });

  @override
  List<Object?> get props => [
        observationId,
        learnerId,
        eventId,
        createdDate,
        observation,
      ];
}
