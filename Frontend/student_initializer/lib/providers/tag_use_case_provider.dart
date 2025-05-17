import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/tag/tag_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/tag/tag_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/tag/tag_repository.dart';
import 'package:student_initializer/domain/repositories/tag/tag_repository_impl.dart';
import 'package:student_initializer/domain/usecases/tag/tag_usecases.dart';
import 'package:student_initializer/presentation/cubits/tag/get_tags/get_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/tag/save_tag/save_tag_cubit.dart';

final tagUsecasesProvider = Provider<TagUsecases>((ref) {
  final tagRepository = ref.read(tagRepositoryProvider);
  return TagUsecases(tagRepository);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final tagRemoteDataSource = ref.read(tagRemoteDataSourceProvider);
  return TagRepositoryImpl(tagRemoteDataSource);
});

final tagRemoteDataSourceProvider = Provider<TagRemoteDataSource>((ref) {
  return TagRemoteDataSourceImpl();
});

final getTagsCubitProvider = Provider.autoDispose<GetTagsCubit>((ref) {
  final tagUsecases = ref.read(tagUsecasesProvider);
  return GetTagsCubit(tagUsecases);
});

final saveTagCubitProvider = Provider.autoDispose<SaveTagCubit>((ref) {
  final tagUsecases = ref.read(tagUsecasesProvider);
  return SaveTagCubit(tagUsecases);
});