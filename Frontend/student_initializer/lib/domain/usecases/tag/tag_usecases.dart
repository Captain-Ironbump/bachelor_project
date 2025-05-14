import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/repositories/tag/tag_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class TagUsecases {
  final TagRepository _tagRepository;

  const TagUsecases(this._tagRepository);

  Future<Either<NetworkException, void>> saveTag({
    required TagDetailEntity tagDetailEntity,
  }) async {
    return _tagRepository.saveTag(tagDetailEntity: tagDetailEntity);
  }

  Future<Either<NetworkException, List<TagDetailEntity>>> fetchAllTags() async {
    return _tagRepository.getAllTags();
  }
}