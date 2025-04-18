import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/learner/learner_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/learner/learner_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository_impl.dart';
import 'package:student_initializer/domain/usecases/learner/learner_usecases.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learners/get_learners_cubit.dart';

final learnerUsecasesProvider = Provider<LearnerUsecases>((ref) {
  final learnerRepository = ref.read(learnerRepositoryProvider);
  return LearnerUsecases(learnerRepository);
});

final learnerRepositoryProvider = Provider<LearnerRepository>((ref) {
  final learnerRemoteDataSource = ref.read(learnerRemoteDataSourceProvider);
  return LearnerRepositoryImpl(learnerRemoteDataSource);
});

final learnerRemoteDataSourceProvider =
    Provider<LearnerRemoteDataSource>((ref) {
  return LearnerRemoteDataSourceImpl();
});

final getLearnersCubitProvider = Provider<GetLearnersCubit>((ref) {
  final learnerUsecases = ref.read(learnerUsecasesProvider);
  return GetLearnersCubit(learnerUsecases);
});
