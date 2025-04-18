import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository_impl.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations/get_observations_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_count/get_observations_count_cubit.dart';
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
    Provider<GetObservationsCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationsCubit(observationUsecases);
});

final getObservationsCountProvider =
    Provider<GetObservationsCountCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return GetObservationsCountCubit(observationUsecases);
});

final saveObservationProvider =
    Provider<SaveObservationCubit>((ref) {
  final observationUsecases = ref.read(observationUsecaseProvider);
  return SaveObservationCubit(observationUsecases);
});