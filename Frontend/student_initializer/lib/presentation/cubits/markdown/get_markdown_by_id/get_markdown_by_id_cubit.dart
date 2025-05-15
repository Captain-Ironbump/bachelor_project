import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/usecases/markdown/markdown_usecases.dart';

part 'get_markdown_by_id_state.dart';

class GetMarkdownByIdCubit extends Cubit<GetMarkdownByIdState> {
  GetMarkdownByIdCubit(this._markdownUsecases)
      : super(const GetMarkdownByIdInitial());

  Future<void> getMarkdownById({required int reportId}) async {
    try {
      emit(const GetMarkdownByIdLoading());
      final result = await _markdownUsecases.getMarkdownForm(reportId: reportId);
      result.fold((error) => emit(GetMarkdownByIdError(message: error.message)),
          (success) {
        print("✅ Emitting GetMarkdownByIdLoaded with $success");
        emit(GetMarkdownByIdLoaded(markdownForm: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final MarkdownUsecases _markdownUsecases;
}