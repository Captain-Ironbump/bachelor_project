import 'package:student_initializer/util/argumets/page_arguments.dart';

class ResponsePageArgs extends PageArgs {
  final String response;
  
  ResponsePageArgs({
    required super.previousPageTitle,
    required this.response,
  });
}