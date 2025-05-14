import 'package:equatable/equatable.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';

class ObservationDetailWithTagsEntity extends Equatable {
  final ObservationDetailEntity? observationDetail;
  final List<TagDetailEntity>? tags;

  const ObservationDetailWithTagsEntity({
    required this.observationDetail,
    required this.tags,
  });
  
  @override
  List<Object?> get props => [
        observationDetail,
        tags,
      ];
}