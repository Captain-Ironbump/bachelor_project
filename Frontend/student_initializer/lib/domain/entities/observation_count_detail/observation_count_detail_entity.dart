import 'package:equatable/equatable.dart';

class ObservationCountDetailEntity extends Equatable {
  final int? count;
  final int? countWithTimespan;

  const ObservationCountDetailEntity({
    this.count,
    this.countWithTimespan,
  });

  @override
  List<Object?> get props => [count, countWithTimespan];
}
