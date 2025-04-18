import 'package:flutter/cupertino.dart';
import 'package:student_initializer/data_old/local/models/student.dart';
import 'package:student_initializer/domain_old/llmTextService.dart';
import 'package:student_initializer/presenter/llm_response_page.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/argumets/response_page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';

class StudentTextFieldPage extends StatefulWidget {
  final PageArgs args;

  const StudentTextFieldPage({super.key, required this.args});

  @override
  State<StudentTextFieldPage> createState() => _StudentTextFieldPageState();
}

class _StudentTextFieldPageState extends State<StudentTextFieldPage> {
  final LlmTextService service = LlmTextService();
  final TextEditingController _queryController = TextEditingController();
  bool _isFetching = false;

  final List<Student> students = [
    Student(name: 'Lukas', surname: 'Linde', marticle: 123),
    Student(name: 'Max', surname: 'Mustermann', marticle: 111),
  ];

  void _toggleFetchingState() {
    setState(() {
      _isFetching = !_isFetching;
    });
  }

  void sendToBackend(Student student, String query, BuildContext context) async {
    print(student.toString());
    print(query);
    _toggleFetchingState();
    await service.getLlmRequest(student, query).then((response) => {
      if (context.mounted) {
        _toggleFetchingState(),
        _navigateToPage(response.body, context)
      }
    }).catchError((onError) => {
      if (context.mounted) {
        _toggleFetchingState(),
        _navigateToPage('Nix funktione', context)
      }
    });
  }

  void _navigateToPage(String response, BuildContext context) {
    Navigator.push(
      context,
      AppRoutes.llmResponsePage.route(
        ResponsePageArgs(
          previousPageTitle: 'LLM', 
          response: response
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.args.previousPageTitle,  // Set the previous page title
        middle: const Text('Student Info'),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.white,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Center(
                      child: CupertinoTextField(
                        placeholder: 'Insert the query here',
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _queryController,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    Center(
                      child: CupertinoButton.filled(
                        child: const Text('Send Student data to Backend'),
                        onPressed: () => sendToBackend(students.last, _queryController.text, context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    if (_isFetching)
                      const Center(
                        child: CupertinoActivityIndicator(
                          radius: 10,
                          color: CupertinoColors.activeBlue,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
