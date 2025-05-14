import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/event/event_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/event/event_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/event/event_repository.dart';
import 'package:student_initializer/domain/repositories/event/event_repository_impl.dart';
import 'package:student_initializer/domain/usecases/event/event_usecases.dart';
import 'package:student_initializer/presentation/cubits/event/get_event_details_by_id/get_event_details_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/event/get_events/get_events_cubit.dart';

final eventUsecasesProvider = Provider<EventUsecases>((ref) {
  final eventRepository = ref.read(eventRepositoryProvider);
  return EventUsecases(eventRepository);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final eventRemoteDataSource = ref.read(eventRemoteDataSourceProvider);
  return EventRepositoryImpl(eventRemoteDataSource);
});

final eventRemoteDataSourceProvider = Provider<EventRemoteDataSource>((ref) {
  return EventRemoteDataSourceImpl();
});

final getEventsCubitProvider = Provider.autoDispose<GetEventsCubit>((ref) {
  final eventUsecases = ref.read(eventUsecasesProvider);
  return GetEventsCubit(eventUsecases);
});

final getEventDetailsByIdCubitProvider =
    Provider.autoDispose<GetEventDetailsByIdCubit>((ref) {
  return GetEventDetailsByIdCubit(ref.read(eventUsecasesProvider));
});
