import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/data/models/observation_detail/observation_detail_model.dart';
import 'package:student_initializer/data/models/tag_detail/tag_detail_model.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:equatable/equatable.dart';

part 'observation_detail_with_tags_model.g.dart';

@JsonSerializable()
class ObservationDetailWithTagsModel extends Equatable
    with EntityConvertable<ObservationDetailWithTagsModel, ObservationDetailWithTagsEntity>  {
  @JsonKey(name: "observationDTO")
  final ObservationDetailModel observationDTO;

  @JsonKey(name: "tags")
  final List<TagDetailModel> tags;

  ObservationDetailWithTagsModel({
    required this.observationDTO,
    required this.tags,
  });

  factory ObservationDetailWithTagsModel.fromJson(Map<String, dynamic> json) {
    return _$ObservationDetailWithTagsModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ObservationDetailWithTagsModelToJson(this);

  @override
  ObservationDetailWithTagsEntity toEntity() {
    return ObservationDetailWithTagsEntity(
      observationDetail: observationDTO.toEntity(),
      tags: tags.map((tag) => tag.toEntity()).toList(),
    );
  }
  
  @override
  List<Object?> get props => [
        observationDTO,
        tags,
      ];
}
