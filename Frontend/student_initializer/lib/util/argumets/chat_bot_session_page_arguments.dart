import 'package:student_initializer/domain/chat_bot_socket.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';

class ChatBotSessionPageArguments extends PageArgs {
  final ChatBotSocket connection;
  
  ChatBotSessionPageArguments({
    required super.previousPageTitle,
    required this.connection,
  });
}