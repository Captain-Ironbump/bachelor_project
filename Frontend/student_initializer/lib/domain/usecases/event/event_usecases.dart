import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';
import 'package:student_initializer/domain/repositories/event/event_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class EventUsecases {
  final EventRepository _eventRepository;

  const EventUsecases(this._eventRepository);

  Future<Either<NetworkException, void>> saveEvent(
      {required String name}) async {
    return _eventRepository.saveEvent(name: name);
  }

  Future<Either<NetworkException, List<EventDetailEntity>>> fetchAllEvents(
      {Map<String, dynamic>? queryParameter}) async {
    return _eventRepository.fetchAllEvents(queryParameter: queryParameter);
  }

  Future<Either<NetworkException, EventDetailEntity>> fetchEventDetailsById(
      {required int? eventId}) async {
    return _eventRepository.fetchEventDetailsById(eventId: eventId);
  }

  Future<Either<NetworkException, void>> addLearnersToEvent({
    required int eventId,
    required List<int> learnerIds,
  }) async {
    return _eventRepository.addLearnersToEvent(
      eventId: eventId,
      learnerIds: learnerIds,
    );
  }
}
