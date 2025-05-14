import 'package:intl/intl.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';

class MarkdownCreator {
  static String generateObservationMarkdown({
    required List<ObservationDetailEntity> observations,
    required LearnerDetailEntity learner,
    required String event,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# Observation Report');
    buffer.writeln('');
    buffer.writeln('**Learner:** ${learner.firstName} ${learner.lastName}');
    buffer.writeln('**Learner ID:** ${learner.learnerId}');
    buffer.writeln('**Event:** $event');
    buffer.writeln('');
    buffer.writeln('---');
    buffer.writeln('');

    // Observations
    buffer.writeln('## Observations (${observations.length})');
    buffer.writeln('');

    for (var i = 0; i < observations.length; i++) {
      final obs = observations[i];
      final formattedDate = obs.createdDate != null
          ? DateFormat.yMMMMd().format(DateTime.parse(obs.createdDate!))
          : "Unknown";

      buffer.writeln('### Observation ${i + 1}');
      buffer.writeln('- **ID:** ${obs.observationId}');
      buffer.writeln('- **Date:** $formattedDate');
      buffer.writeln('**Content:**');
      buffer.writeln('```');
      buffer.writeln(obs.observation);
      buffer.writeln('```');
      buffer.writeln(' ------- ');
    }

    buffer.writeln('---');
    buffer.writeln('*Generated on ${DateFormat.yMMMMd().format(DateTime.now())}*');

    return buffer.toString();
  }
}
