import 'package:equatable/equatable.dart';

class LearnerDetailEntity extends Equatable {
  final int? learnerId;
  final String? firstName;
  final String? lastName;

  const LearnerDetailEntity({
    this.learnerId,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [
        learnerId,
        firstName,
        lastName,
      ];
}
