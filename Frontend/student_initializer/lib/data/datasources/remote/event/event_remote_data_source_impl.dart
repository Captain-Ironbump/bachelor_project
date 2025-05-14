import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/event/event_remote_data_source.dart';
import 'package:student_initializer/data/models/event_detail/event_detail_model.dart';
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';
import 'package:http/http.dart' as http;

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  @override
  Future<List<EventDetailModel>> fetchAllEvents(
      {Map<String, dynamic>? queryParameter}) async {
    try {
      final Uri uri =
          SimplifiedUri.uri('${PlattformUri.getUri()}/events', queryParameter);
      final response = await http.get(uri);
      final List<dynamic> items = json.decode(response.body);
      return items.map((item) => EventDetailModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveEvent({required String name}) async {
    try {
      final Uri uri =
          SimplifiedUri.uri('${PlattformUri.getUri()}/events', null);
      final body = EventDetailModel(name: name).toJson();
      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: body);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<EventDetailModel> fetchEventDetailsById(
      {required int? eventId}) async {
    try {
      if (eventId == null) {
        return const EventDetailModel(eventId: null, name: 'NON', learnerCount: null);
      }
      final Uri uri =
          SimplifiedUri.uri('${PlattformUri.getUri()}/events/$eventId', null);
      final response = await http.get(uri);
      return EventDetailModel.fromJson(json.decode(response.body));
    } catch (_) {
      rethrow;
    }
  }
}
