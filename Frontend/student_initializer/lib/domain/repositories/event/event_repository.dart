import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

abstract class EventRepository {
  Future<Either<NetworkException, void>> saveEvent({required String name});
  Future<Either<NetworkException, List<EventDetailEntity>>> fetchAllEvents({Map<String, dynamic>? queryParameter});
  Future<Either<NetworkException, EventDetailEntity>> fetchEventDetailsById({required int? eventId});
  Future<Either<NetworkException, void>> addLearnersToEvent({required int eventId, required List<int> learnerIds});
}
