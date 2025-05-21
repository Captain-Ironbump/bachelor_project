import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/usecases/markdown/markdown_usecases.dart';

part 'update_markdown_quality_state.dart';

class UpdateMarkdownQualityCubit extends Cubit<UpdateMarkdownQualityState> {
  UpdateMarkdownQualityCubit(this._markdownUsecases)
      : super(const UpdateMarkdownQualityInitial());

  final MarkdownUsecases _markdownUsecases;

  Future<void> updateMarkdownQuality({
    required int reportId,
    required String quality,
  }) async {
    try {
      emit(const UpdateMarkdownQualityLoading());
      final result = await _markdownUsecases.updateMarkdownForm(
        reportId: reportId,
        quality: quality,
      );
      result.fold(
        (error) => emit(UpdateMarkdownQualityError(message: error.message)),
        (success) {
          print("✅ Emitting UpdateMarkdownQualityLoaded with ${success.toString()}");
          emit(UpdateMarkdownQualitySuccess(markdownForm: success));
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}