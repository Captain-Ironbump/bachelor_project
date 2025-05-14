import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/cubits/learner/save_learner/save_learner_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observation_by_id_with_tags/get_observation_by_id_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/get_observations_with_tags/get_observations_with_tags_cubit.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/providers/observation_use_case_provider.dart';

class ReportPopupView extends StatefulWidget {
  final int learnerId;
  final int eventId;
  final Function onChangeRouteCallback;
  final Function onCloseCallback;

  const ReportPopupView({
    super.key,
    required this.learnerId,
    required this.eventId,
    required this.onChangeRouteCallback,
    required this.onCloseCallback,
  });

  @override
  State<ReportPopupView> createState() => _ReportPopupViewState();
}

class _ReportPopupViewState extends State<ReportPopupView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MyNav(
              onPressedCallback: () {},
              onCloseCallback: () {
                widget.onCloseCallback(context);
              },
            ),
            pinned: true,
            floating: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BlocBuilder<GetObservationsWithTagsCubit,
                  GetObservationsWithTagsState>(
                builder: (context, state) {
                  if (state is GetObservationsWithTagsLoading) {
                    // Ladeindikator anzeigen
                    return CupertinoFormSection.insetGrouped(
                      header: const Text("Test"),
                      children: const [
                        CupertinoFormRow(
                          child: Center(
                            child: BaseIndicator(),
                          ),
                        ),
                      ],
                    );
                  } else if (state is GetObservationsWithTagsLoaded) {
                    // Dynamische Inhalte basierend auf dem Zustand
                    return CupertinoFormSection.insetGrouped(
                      header: const Text("Test"),
                      children: List<Widget>.generate(
                        state.observations!.length,
                        (index) {
                          return CupertinoListTile(
                            title: Text(
                              "${state.observations![index].observationDetail!.observationId}",
                            ),
                            additionalInfo: Text(
                              "${state.observations![index].observationDetail!.createdDate}",
                            ),
                            trailing: const CupertinoListTileChevron(),
                            onTap: () {
                              widget.onChangeRouteCallback(
                                context,
                                state.observations![index].observationDetail!
                                    .observationId,
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
                Navigator.of(context, rootNavigator: true).pop();
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
