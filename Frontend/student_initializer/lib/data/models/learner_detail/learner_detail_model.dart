import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';

part 'learner_detail_model.g.dart';

@JsonSerializable()
class LearnerDetailModel extends Equatable
    with EntityConvertable<LearnerDetailModel, LearnerDetailEntity> {
  @JsonKey(name: "learnerId")
  final int? learnerId;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;

  const LearnerDetailModel({
    this.learnerId,
    this.firstName,
    this.lastName,
  });

  factory LearnerDetailModel.fromJson(Map<String, dynamic> json) {
    return _$LearnerDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LearnerDetailModelToJson(this);

  @override
  List<Object?> get props => [learnerId, firstName, lastName];

  @override
  LearnerDetailEntity toEntity() => LearnerDetailEntity(
        learnerId: learnerId,
        firstName: firstName,
        lastName: lastName,
      );
}
