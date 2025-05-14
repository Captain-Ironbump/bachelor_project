import 'package:equatable/equatable.dart';

class TagDetailEntity extends Equatable {
  final String? tag;
  final String? tagColor;

  const TagDetailEntity({this.tag, this.tagColor});

  @override
  List<Object?> get props => [tag, tagColor];
}
