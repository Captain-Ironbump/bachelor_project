import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';

part 'observation_detail_model.g.dart';

@JsonSerializable()
class ObservationDetailModel extends Equatable
    with EntityConvertable<ObservationDetailModel, ObservationDetailEntity> {
  @JsonKey(name: "observationId")
  final int? observationId;
  @JsonKey(name: "learnerId")
  final int? learnerId;
  @JsonKey(name: "eventId")
  final int? eventId;
  @JsonKey(name: "createdDateTime")
  final String? createdDate;
  @JsonKey(name: "rawObservation")
  final String? rawObservation;

  const ObservationDetailModel({
    this.observationId,
    this.learnerId,
    this.eventId,
    this.createdDate,
    this.rawObservation,
  });

  factory ObservationDetailModel.fromJson(Map<String, dynamic> json) {
    return _$ObservationDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ObservationDetailModelToJson(this);

  @override
  List<Object?> get props =>
      [observationId, learnerId, eventId, createdDate, rawObservation];

  @override
  ObservationDetailEntity toEntity() => ObservationDetailEntity(
      observationId: observationId,
      learnerId: learnerId,
      eventId: eventId,
      createdDate: createdDate,
      observation: utf8.decode(base64.decode(rawObservation!)));
}
