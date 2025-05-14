import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';
import 'package:student_initializer/data/models/observation_detail_with_tags/observation_detail_with_tags_model.dart';

class ObservationRepositoryImpl implements ObservationRepository {
  final ObservationRemoteDataSource _observationRemoteDataSource;

  ObservationRepositoryImpl(this._observationRemoteDataSource);

  @override
  Future<Either<NetworkException, Map<String, ObservationCountDetailEntity>>>
      getObservationCountWithQueries(
          {int? timespanByDays, List<int>? learner, int? eventId}) async {
    try {
      late Map<String, ObservationCountDetailEntity> data = {};
      final result = await _observationRemoteDataSource.getCountMap(
          timespanInDays: timespanByDays, learners: learner, eventId: eventId);
      data = result.map(
        (key, value) => MapEntry(key, value.toEntity()),
      );
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId(
          {required int learnerId,
          required Map<String, dynamic> queryParams}) async {
    try {
      late List<ObservationDetailEntity> data = [];
      final result =
          await _observationRemoteDataSource.getObservationsByLearnerId(
              learnerId: learnerId, queryParams: queryParams);
      data = result.map((e) => e.toEntity()).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, void>> saveObservationDetails(
      {required ObservationDetailEntity? observationDetailEntity,
      required List<TagDetailEntity> selectedTags}) async {
    try {
      await _observationRemoteDataSource.saveObservation(
          learnerId: observationDetailEntity!.learnerId!,
          eventId: observationDetailEntity.eventId!,
          observation: observationDetailEntity.observation!,
          selectedTags: selectedTags);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, ObservationDetailEntity>>
      getObservationDetailById({required int observationId}) async {
    try {
      final result = await _observationRemoteDataSource
          .getObservationDetailById(observationId: observationId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, List<ObservationDetailWithTagsEntity>>>
      getObservationsWithTagsByLearnerId({
    required int learnerId,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      late List<ObservationDetailWithTagsEntity> data = [];
      final result = await _observationRemoteDataSource
          .getObservationsWithTagsByLearnerId(
              learnerId: learnerId, queryParams: queryParams);
      data = result.map((e) => e.toEntity()).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
  
  @override
  Future<Either<NetworkException, ObservationDetailWithTagsEntity>> getObservationWithTagsById({required int observationId}) async {
    try {
      final result = await _observationRemoteDataSource.getObservationWithTagsById(observationId: observationId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
      
    }
  }
}
