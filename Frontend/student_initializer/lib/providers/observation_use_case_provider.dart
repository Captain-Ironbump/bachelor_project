import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository_impl.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';
import 'package:student_initializer/presentation/cubits/observation/delete_observation/delete_observation_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id/get_observation_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations/get_observations_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';

final observationUsecaseProvider = Provider<ObservationUsecases>((ref) {
  final observationRepository = ref.read(observationRepositoryProvider);
  return ObservationUsecases(observationRepository);
});

final observationRepositoryProvider = Provider<ObservationRepository>((ref) {
  final observationRemoteDataSource =
      ref.read(observationRemoteDataSourceProvider);
  return ObservationRepositoryImpl(observationRemoteDataSource);
});

final observationRemoteDataSourceProvider =
    Provider<ObservationRemoteDataSource>((ref) {
  return ObservationRemoteDataSourceImpl();
});

final getObservationsByLearnerIdProvider =
    Provider.autoDispose<GetObservationsCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationsCubit(observationUsecases);
});

final getObservationsCountProvider =
    Provider.autoDispose<GetObservationsCountCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationsCountCubit(observationUsecases);
});

final saveObservationProvider =
    Provider.autoDispose<SaveObservationCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return SaveObservationCubit(observationUsecases);
});

final getObservationByIdCubitProvider =
    Provider.autoDispose<GetObservationByIdCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationByIdCubit(observationUsecases);
});

final getObservationsWithTagsProvider =
    Provider.autoDispose<GetObservationsWithTagsCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationsWithTagsCubit(observationUsecases);
});

final getObservationByIdWithTagsProvider =
    Provider.autoDispose<GetObservationByIdWithTagsCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationByIdWithTagsCubit(observationUsecases);
});

final deleteObservatiobCubitProvider =
    Provider.autoDispose<DeleteObservationCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return DeleteObservationCubit(observationUsecases);
});