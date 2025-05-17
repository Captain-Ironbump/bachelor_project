import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/usecases/tag/tag_usecases.dart';

part 'save_tag_state.dart';

class SaveTagCubit extends Cubit<SaveTagState> {
  SaveTagCubit(this._tagUsecases) : super(const SaveTagInitial());

  Future<void> saveTag({required TagDetailEntity tagDetailEntity}) async {
    try {
      emit(const SaveTagLoading());
      final result = await _tagUsecases.saveTag(tagDetailEntity: tagDetailEntity);
      result.fold(
        (error) => emit(SaveTagError(message: error.message)),
        (_) => emit(const SaveTagSuccess()),
      );
    } catch (_) {
      rethrow;
    }
  }

  final TagUsecases _tagUsecases;
}