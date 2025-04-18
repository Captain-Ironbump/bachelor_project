import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/argumets/chat_bot_session_page_arguments.dart';

class ChatBotSessionPage extends StatefulWidget {
  final ChatBotSessionPageArguments args;

  const ChatBotSessionPage({super.key, required this.args});

  @override
  State<StatefulWidget> createState() => _ChatBotSessionPageState();
}

class _ChatBotSessionPageState extends State<ChatBotSessionPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.args.connection.isOpen) {
      widget.args.connection.open();
    }
    widget.args.connection.getStreamController().stream.listen((message) {
      setState(() {
        widget.args.connection.messages.first += message;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.args.connection.close();
  }
  

  @override
  Widget build(BuildContext context) {
    print(widget.args.previousPageTitle);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.args.previousPageTitle,
        middle: const Text('Session'),
      ),
      child: SafeArea(
        child: SizedBox(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    StreamBuilder(
                      stream: widget.args.connection.getStreamController().stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.args.connection.messages.first,
                                  style: CupertinoTheme.of(context).textTheme.textStyle,
                                ),
                              ),
                              const CupertinoActivityIndicator(),
                            ],
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.args.connection.messages.first,
                            style: CupertinoTheme.of(context).textTheme.textStyle,
                          ),
                        );
                      }
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      ) 
    );
  }

}