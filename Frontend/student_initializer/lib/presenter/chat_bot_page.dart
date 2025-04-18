import 'package:flutter/cupertino.dart';
import 'package:student_initializer/domain_old/chat_bot_socket.dart';
import 'package:student_initializer/util/argumets/chat_bot_session_page_arguments.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';
import 'chat_bot_session_page.dart';

class ChatBotPage extends StatefulWidget {

  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  late List<ChatBotSocket> connections = [
    ChatBotSocket.withDefaultUri(),
  ];

  void _createNewChat() {
    _navigateToPage();
  }

  void _navigateToPage() {
    Navigator.of(context, rootNavigator: true).push(
      AppRoutes.chatBotSessionPage.route(
        ChatBotSessionPageArguments(
          previousPageTitle: 'ChatBot',
          connection: connections.first
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            trailing: CupertinoButton(
                padding: const EdgeInsets.only(bottom: 2.0),
                onPressed: () => _createNewChat(),
                child: const Icon(CupertinoIcons.add_circled_solid)
            ),
            largeTitle: const Text('ChatBot'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Center(
                  child: CupertinoButton.filled(
                      child: const Text('Start new Chat'),
                      onPressed: () => print('new chat will be opened')),
                )
              ]
            ),
          )
        ],
      ),
    );
  }

}