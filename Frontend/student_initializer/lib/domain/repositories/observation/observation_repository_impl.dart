import 'package:fpdart/src/either.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class ObservationRepositoryImpl implements ObservationRepository {
  final ObservationRemoteDataSource _observationRemoteDataSource;

  ObservationRepositoryImpl(this._observationRemoteDataSource);

  @override
  Future<Either<NetworkExcpetion, Map<String, ObservationCountDetailEntity>>>
      getObservationCountWithQueries(
          {int? timespanByDays, List<int>? learner}) async {
    try {
      late Map<String, ObservationCountDetailEntity> data = {};
      final result = await _observationRemoteDataSource.getCountMap(
          timespanInDays: timespanByDays, learners: learner);
      data = result.map(
        (key, value) => MapEntry(key, value.toEntity()),
      );
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkExcpetion.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkExcpetion, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId({required int learnerId}) async {
    try {
      late List<ObservationDetailEntity> data = [];
      final result = await _observationRemoteDataSource
          .getObservationsByLearnerId(learnerId: learnerId);
      data = result.map((e) => e.toEntity()).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkExcpetion.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkExcpetion, void>> saveObservationDetails(
      {required ObservationDetailEntity? observationDetailEntity}) async {
    try {
      await _observationRemoteDataSource.saveObservation(
          learnerId: observationDetailEntity!.learnerId!,
          observation: observationDetailEntity.observation!);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkExcpetion.fromHttpError(e));
    }
  }
}
