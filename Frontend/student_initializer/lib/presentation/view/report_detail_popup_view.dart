import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/presentation/cubits/learner/get_learner_by_id/get_learner_by_id_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/get_markdown_by_id/get_markdown_by_id_cubit.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ReportDetailPopupView extends StatelessWidget {
  final int reportId;
  final Function onCloseCallback;
  final Function onChangeRouteCallback;

  const ReportDetailPopupView({
    super.key,
    required this.reportId,
    required this.onCloseCallback,
    required this.onChangeRouteCallback,
  });

  void _openShareDialog(BuildContext context) async {
    // Ladeindikator anzeigen
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Center(
            child: BaseIndicator(),
          ),
        ),
      ),
    );

    MarkdownFormEntity? _markdownForm;
    LearnerDetailEntity? _learnerDetailEntity;
    int maxTries = 30;
    while (maxTries-- > 0) {
      final markdownState = context.read<GetMarkdownByIdCubit>().state;
      final learnerState = context.read<GetLearnerByIdCubit>().state;
      if (markdownState is GetMarkdownByIdLoaded && learnerState is GetLearnerByIdLoaded) {
        _markdownForm = markdownState.markdownForm;
        _learnerDetailEntity = learnerState.learner;
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (_markdownForm == null || _learnerDetailEntity == null) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load report data.'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('OK'),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        );
      }
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now());
    final params = ShareParams(files: [
      XFile.fromData(utf8.encode(_markdownForm.report!), mimeType: 'text/markdown')
    ], fileNameOverrides: [
      'markdown_report_${_learnerDetailEntity.firstName}_${_learnerDetailEntity.lastName}_$formattedDate.md'
    ]);
    await SharePlus.instance.share(params);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MyNav(
              reportId: reportId,
              onPressedCallback: () {
                print('Share button pressed');
                _openShareDialog(context);
              },
              onCloseCallback: () {
                onCloseCallback(context);
              },
            ),
            pinned: true,
            floating: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child:
                        BlocBuilder<GetMarkdownByIdCubit, GetMarkdownByIdState>(
                      builder: (context, state) {
                        if (state is GetMarkdownByIdLoading) {
                          return const Center(
                            child: BaseIndicator(),
                          );
                        }
                        if (state is GetMarkdownByIdLoaded) {
                          return Localizations(
                            locale: const Locale('en', 'US'),
                            delegates: const [
                              DefaultMaterialLocalizations.delegate,
                              DefaultWidgetsLocalizations.delegate,
                              DefaultCupertinoLocalizations.delegate,
                            ],
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: MarkdownWidget(
                                data: state.markdownForm!.report!,
                              ),
                            ),
                          );
                        }
                        if (state is GetMarkdownByIdError) {
                          return Center(
                            child: Text(state.message!),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

typedef OnPressedCallback = void Function();

class MyNav extends SliverPersistentHeaderDelegate {
  final int reportId;
  final OnPressedCallback onPressedCallback;
  final Function onCloseCallback;

  const MyNav(
      {required this.reportId,
      required this.onPressedCallback,
      required this.onCloseCallback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    TextStyle navTitleTextStyle =
        CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    return Container(
      color: CupertinoColors
          .systemGrey6, // Set the header background color to systemGrey6
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 40.0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.arrow_left_circle_fill),
              onPressed: () {
                //Navigator.of(context, rootNavigator: true).pop();
                onCloseCallback();
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Report Details $reportId',
                style: navTitleTextStyle.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: CupertinoButton(
              onPressed: () {
                print("Share button pressed, using callback");
                onPressedCallback();
              },
              child: const Icon(CupertinoIcons.share_up),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70.0;

  @override
  double get minExtent => 70.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
