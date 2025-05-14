import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/usecases/markdown/markdown_usecases.dart';

part 'generate_markdown_form_state.dart';

class GenerateMarkdownFormCubit extends Cubit<GenerateMarkdownFormState> {
  GenerateMarkdownFormCubit(this._markdownUsecases)
      : super(const GenerateMarkdownFormInitial());

  Future<void> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    try {
      emit(const GenerateMarkdownFormLoading());
      final result = await _markdownUsecases.generateMarkdownForm(
          eventId: eventId, learnerId: learnerId, length: length);
      result.fold((error) => emit(GenerateMarkdownFormError(error.message)),
          (success) {
        print("✅ Emitting GenerateMarkdownFormLoaded with $success");
        emit(GenerateMarkdownFormLoaded(markdownForm: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final MarkdownUsecases _markdownUsecases;
}
