import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/usecases/markdown/markdown_usecases.dart';

part 'get_markdowns_by_learner_state.dart';

class GetMarkdownsByLearnerCubit extends Cubit<GetMarkdownsByLearnerState> {
  GetMarkdownsByLearnerCubit(this._markdownUsecases)
      : super(const GetMarkdownsByLearnerInitial());

  Future<void> getMarkdownsByLearnerId(
      {required int learnerId,
      int? eventId,
      String? sortBy,
      String? sortOrder,
      int? timespanInDays}) async {
    try {
      emit(const GetMarkdownsByLearnerLoading());
      final result = await _markdownUsecases.getMarkdownFormsByLearnerAndEvent(
          learnerId: learnerId,
          eventId: eventId,
          sortBy: sortBy,
          sortOrder: sortOrder,
          timespanInDays: timespanInDays);
      result.fold(
          (error) => emit(GetMarkdownsByLearnerError(message: error.message)),
          (success) {
        print(
            "✅ Emitting GetMarkdownsByLearnerLoaded with ${success.length} items");
        emit(GetMarkdownsByLearnerLoaded(markdownForms: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final MarkdownUsecases _markdownUsecases;
}
