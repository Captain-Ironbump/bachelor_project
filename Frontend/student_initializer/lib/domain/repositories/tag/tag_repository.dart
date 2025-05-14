import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

abstract class TagRepository {
  Future<Either<NetworkException, List<TagDetailEntity>>> getAllTags();
  Future<Either<NetworkException, void>> saveTag(
      {required TagDetailEntity tagDetailEntity});
}
