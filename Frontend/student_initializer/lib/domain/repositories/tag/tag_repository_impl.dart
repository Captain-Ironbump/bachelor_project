import 'package:fpdart/src/either.dart';
import 'package:student_initializer/data/datasources/remote/tag/tag_remote_data_source.dart';
import 'package:student_initializer/data/models/tag_detail/tag_detail_model.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/repositories/tag/tag_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class TagRepositoryImpl extends TagRepository {
  final TagRemoteDataSource _tagRemoteDataSource;

  TagRepositoryImpl(this._tagRemoteDataSource);

  @override
  Future<Either<NetworkException, List<TagDetailEntity>>> getAllTags() async {
    try {
      late List<TagDetailEntity> data = [];
      final result = await _tagRemoteDataSource.fetchAllTags();
      data = result.map((item) => item.toEntity()).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, void>> saveTag(
      {required TagDetailEntity tagDetailEntity}) async {
    try {
      await _tagRemoteDataSource.saveTag(
          tagDetailModel: TagDetailModel(
              tag: tagDetailEntity.tag, tagColor: tagDetailEntity.tagColor));
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
}
