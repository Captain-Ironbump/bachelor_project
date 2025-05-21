import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/_widgets/report_leading_information.dart';
import 'package:student_initializer/presentation/cubits/learner/save_learner/save_learner_cubit.dart';
import 'package:student_initializer/presentation/cubits/markdown/get_markdowns_by_learner/get_markdowns_by_learner_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';
import 'package:student_initializer/presentation/cubits/markdown/generate_markdown_form/generate_markdown_form_cubit.dart';

class ReportsPopupView extends StatelessWidget {
  final int learnerId;
  final int eventId;
  final Function onChangeRouteCallback;
  final Function onCloseCallback;
  final Function onPressedCallback;

  const ReportsPopupView({
    super.key,
    required this.learnerId,
    required this.eventId,
    required this.onChangeRouteCallback,
    required this.onCloseCallback,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateMarkdownFormCubit, GenerateMarkdownFormState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
          print('BlocListener: $state');
        if (state is GenerateMarkdownFormLoading) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            ),
          );
        } else if (state is GenerateMarkdownFormLoaded) {
          Navigator.of(context, rootNavigator: true).pop();
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Erfolg'),
              content: Text(
                  state.message ?? 'Markdown wurde erfolgreich generiert!'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
              ],
            ),
          );
        } else if (state is GenerateMarkdownFormError) {
          Navigator.of(context, rootNavigator: true).pop();
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Fehler'),
              content: Text(state.message ?? 'Unbekannter Fehler'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        color: CupertinoColors.systemGrey6,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MyNav(
                onPressedCallback: () {
                  onPressedCallback(context);
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
                BlocBuilder<GetMarkdownsByLearnerCubit,
                    GetMarkdownsByLearnerState>(
                  builder: (context, state) {
                    if (state is GetMarkdownsByLearnerLoading) {
                      // Ladeindikator anzeigen
                      return CupertinoFormSection.insetGrouped(
                        children: const [
                          CupertinoFormRow(
                            child: Center(
                              child: BaseIndicator(),
                            ),
                          ),
                        ],
                      );
                    } else if (state is GetMarkdownsByLearnerLoaded) {
                      // Dynamische Inhalte basierend auf dem Zustand

                      if (state.markdownForms!.isEmpty) {
                        return CupertinoFormSection.insetGrouped(
                          header: const Text("Test"),
                          children: const [
                            CupertinoFormRow(
                              child: Center(
                                child: Text('No data available'),
                              ),
                            ),
                          ],
                        );
                      }

                      return CupertinoFormSection.insetGrouped(
                        children: List<Widget>.generate(
                          state.markdownForms!.length,
                          (index) {
                            final date = DateTime.tryParse(
                                state.markdownForms![index].createdDateTime ??
                                    "");
                            final formattedDate = date != null
                                ? "${date.day.toString().padLeft(2, '0')} ${DateFormat('MMM').format(date)} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}"
                                : "-";
                            return CupertinoListTile(
                              title: ReportLeadingInformation(
                                markdownFormEntity: state.markdownForms![index],
                              ),
                              additionalInfo: Text(
                                formattedDate,
                              ),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () {
                                onChangeRouteCallback(
                                  context,
                                  state.markdownForms![index].reportId,
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      // Standardanzeige, wenn keine Daten vorhanden sind
                      return CupertinoFormSection.insetGrouped(
                        header: const Text("Test"),
                        children: const [
                          CupertinoFormRow(
                            child: Center(
                              child: Text('No data available'),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

typedef OnPressedCallback = void Function();

class MyNav extends SliverPersistentHeaderDelegate {
  final OnPressedCallback onPressedCallback;
  final Function onCloseCallback;

  const MyNav({required this.onPressedCallback, required this.onCloseCallback});

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
              child: const Icon(CupertinoIcons.clear_circled_solid),
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
                'Reports',
                style: navTitleTextStyle.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: CupertinoButton(
              onPressed: () {
                onPressedCallback();
              },
              child: const Icon(CupertinoIcons.arrow_right_circle_fill),
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
