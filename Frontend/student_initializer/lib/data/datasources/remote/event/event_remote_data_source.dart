import 'package:student_initializer/data/models/event_detail/event_detail_model.dart';

abstract class EventRemoteDataSource {
  Future<void> saveEvent({required String name});
  Future<List<EventDetailModel>> fetchAllEvents(
      {Map<String, dynamic>? queryParameter});
  Future<EventDetailModel> fetchEventDetailsById({required int? eventId});
  Future<void> addLearnerToEvent(
      {required int eventId, required List<int> learnerIds});
}
