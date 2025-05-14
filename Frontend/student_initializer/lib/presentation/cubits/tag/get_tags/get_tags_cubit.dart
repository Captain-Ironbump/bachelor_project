import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/usecases/tag/tag_usecases.dart';

part 'get_tags_state.dart';

class GetTagsCubit extends Cubit<GetTagsState> {
  GetTagsCubit(this._tagUsecases) : super(const GetTagsInitial());

  Future<void> fetchAllTags() async {
    try {
      emit(const GetTagsLoading());
      final result = await _tagUsecases.fetchAllTags();
      result.fold(
        (error) => emit(GetTagsError(message: error.message)),
        (success) {
          print("✅ Emitting GetTagsLoaded with ${success.length} items");
          emit(GetTagsLoaded(tags: success));
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  final TagUsecases _tagUsecases;
}
