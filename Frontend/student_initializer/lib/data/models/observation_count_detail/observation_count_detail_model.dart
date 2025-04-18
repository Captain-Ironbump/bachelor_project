import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';

part 'observation_count_detail_model.g.dart';

@JsonSerializable()
class ObservationCountDetailModel extends Equatable
    with
        EntityConvertable<ObservationCountDetailModel,
            ObservationCountDetailEntity> {
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "countWithTimespan")
  final int? countWithTimespan;

  const ObservationCountDetailModel({
    this.count,
    this.countWithTimespan,
  });

  factory ObservationCountDetailModel.fromJson(Map<String, dynamic> json) {
    return _$ObservationCountDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ObservationCountDetailModelToJson(this);

  @override
  List<Object?> get props => [count, countWithTimespan];

  @override
  ObservationCountDetailEntity toEntity() => ObservationCountDetailEntity(
        count: count,
        countWithTimespan: countWithTimespan,
      );
}
