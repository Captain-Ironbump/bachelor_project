import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source.dart';
import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository_impl.dart';
import 'package:student_initializer/domain/usecases/markdown/markdown_usecases.dart';
import 'package:student_initializer/presentation/cubits/markdown/generate_markdown_form/generate_markdown_form_cubit.dart';

final markdownUsecaseProvider = Provider<MarkdownUsecases>((ref) {
  final markdownRepository = ref.read(markdownRepositoryProvider);
  return MarkdownUsecases(markdownRepository);
});

final markdownRepositoryProvider = Provider<MarkdownRepository>((ref) {
  final markdownRemoteDataSource = ref.read(markdownRemoteDataSourceProvider);
  return MarkdownRepositoryImpl(markdownRemoteDataSource);
});

final markdownRemoteDataSourceProvider =
    Provider<MarkdownRemoteDataSource>((ref) {
  return MarkdownRemoteDataSourceImpl();
});

final generateMarkdownFormCubitProvider =
    Provider.autoDispose<GenerateMarkdownFormCubit>((ref) {
  return GenerateMarkdownFormCubit(ref.read(markdownUsecaseProvider));
});
