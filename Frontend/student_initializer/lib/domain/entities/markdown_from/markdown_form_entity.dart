import 'package:equatable/equatable.dart';

class MarkdownFormEntity extends Equatable {
  final int? reportId;
  final int? learnerId;
  final int? eventId;
  final String? createdDateTime;
  final String? report;

  const MarkdownFormEntity({
    this.reportId,
    this.learnerId,
    this.eventId,
    this.createdDateTime,
    this.report,
  });

  @override
  List<Object?> get props => [
    reportId,
    learnerId,
    eventId,
    createdDateTime,
    report,
  ];
}
