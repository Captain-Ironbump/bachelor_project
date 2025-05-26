import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/event/event_remote_data_source.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';
import 'package:student_initializer/domain/repositories/event/event_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _dataSource;

  const EventRepositoryImpl(this._dataSource);

  @override
  Future<Either<NetworkException, List<EventDetailEntity>>> fetchAllEvents(
      {Map<String, dynamic>? queryParameter}) async {
    try {
      final result =
          await _dataSource.fetchAllEvents(queryParameter: queryParameter);
      final list = result.map((item) => item.toEntity()).toList();
      return Right(list);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, void>> saveEvent(
      {required String name}) async {
    try {
      await _dataSource.saveEvent(name: name);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, EventDetailEntity>> fetchEventDetailsById(
      {required int? eventId}) async {
    try {
      final result = await _dataSource.fetchEventDetailsById(eventId: eventId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
  
  @override
  Future<Either<NetworkException, void>> addLearnersToEvent({required int eventId, required List<int> learnerIds}) async {
    try {
      await _dataSource.addLearnerToEvent(eventId: eventId, learnerIds: learnerIds);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
}
