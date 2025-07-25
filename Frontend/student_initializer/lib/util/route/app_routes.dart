import 'package:flutter/cupertino.dart';
import 'package:student_initializer/app.dart';
import 'package:student_initializer/presenter/chat_bot_session_page.dart';
import 'package:student_initializer/presenter/learner_page.dart';
import 'package:student_initializer/presenter/llm_response_page.dart';
import 'package:student_initializer/presenter/new_student_page.dart';
import 'package:student_initializer/presenter/student_slider_page.dart';
import 'package:student_initializer/presenter/student_text_field_page.dart';
import 'package:student_initializer/util/argumets/chat_bot_session_page_arguments.dart';
import 'package:student_initializer/util/argumets/learner_page_arguments.dart';

import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/argumets/response_page_arguments.dart';

enum AppRoutes<T> {
  homePage<Null>(),
  chatBotSessionPage<ChatBotSessionPageArguments>(),
  studentTextFieldPage<PageArgs>(),
  llmResponsePage<ResponsePageArgs>(),
  studentSliderPage<PageArgs>(),
  newStudentPage<PageArgs>(),
  learnerPage<LearnerPageArgs>();

  String get routeName => '/$name';
  RouteSettings get _settings => RouteSettings(name: routeName);

  CupertinoPageRoute route(T args) {
    switch (this) {
      case AppRoutes.homePage:
        return CupertinoPageRoute(
          builder: (context) => const MyCupertinoAppHomePage(),
          settings: _settings,
        );
      case AppRoutes.chatBotSessionPage:
        return CupertinoPageRoute(
          builder: (context) =>
              ChatBotSessionPage(args: args as ChatBotSessionPageArguments),
          settings: _settings,
        );
      case AppRoutes.studentTextFieldPage:
        return CupertinoPageRoute(
          builder: (context) => StudentTextFieldPage(args: args as PageArgs),
          settings: _settings,
        );
      case AppRoutes.llmResponsePage:
        return CupertinoPageRoute(
          builder: (context) => LlmResponsePage(args: args as ResponsePageArgs),
          settings: _settings,
        );
      case AppRoutes.studentSliderPage:
        return CupertinoPageRoute(
          builder: (context) => StudentSliderPage(args: args as PageArgs),
          settings: _settings,
        );
      case AppRoutes.newStudentPage:
        return CupertinoPageRoute(
          builder: (context) => NewStudentPage(args: args as PageArgs),
          settings: _settings,
        );
      case AppRoutes.learnerPage:
        return CupertinoPageRoute(
          builder: (context) => LearnerPage(args: args as LearnerPageArgs),
          settings: _settings,
        );
    }
  }
}
