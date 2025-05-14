import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';

part 'event_detail_model.g.dart';

@JsonSerializable()
class EventDetailModel extends Equatable
    with EntityConvertable<EventDetailModel, EventDetailEntity> {
  @JsonKey(name: "eventId")
  final int? eventId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "learnerCount")
  final int? learnerCount;

  const EventDetailModel({
    this.eventId,
    this.name,
    this.learnerCount,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return _$EventDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EventDetailModelToJson(this);

  @override
  List<Object?> get props => [eventId, name, learnerCount];

  @override
  toEntity() => EventDetailEntity(
        eventId: eventId,
        name: name,
        learnerCount: learnerCount,
      );
}
