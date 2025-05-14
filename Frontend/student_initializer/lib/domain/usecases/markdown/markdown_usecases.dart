import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class MarkdownUsecases {
  final MarkdownRepository _markdownRepository;

  const MarkdownUsecases(this._markdownRepository);

  Future<Either<NetworkException, MarkdownFormEntity>> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    return _markdownRepository.generateMarkdownForm(
        eventId: eventId, learnerId: learnerId, length: length);
  }
}
