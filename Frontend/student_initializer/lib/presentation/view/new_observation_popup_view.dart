import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/presentation/cubits/observation/save_observation/save_observation_cubit.dart';
import 'package:student_initializer/presentation/_widgets/new_observation_from.dart';
import 'package:student_initializer/presentation/cubits/tag/get_tags/get_tags_cubit.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/presentation/_widgets/tag_widget.dart';

class NewObservationPopupView extends StatefulWidget {
  final int learnerId;
  final int eventId;

  const NewObservationPopupView({super.key, required this.learnerId, required this.eventId});

  @override
  State<NewObservationPopupView> createState() =>
      _NewObservationPopupViewState();
}

class _NewObservationPopupViewState extends State<NewObservationPopupView> {
  late String observation;
  List<TagDetailEntity> selectedTags =
      []; // Add this to the state to track selected tags

  void initState() {
    super.initState();
    observation = "";
  }

  void _sendObservationData() {
    context.read<SaveObservationCubit>().saveObservation(
          observationDetailEntity: ObservationDetailEntity(
            learnerId: widget.learnerId,
            eventId: widget.eventId,
            observation: observation,
          ),
          selectedTags: selectedTags, // Pass the list of selected tags
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveObservationCubit, SaveObservationState>(
      listener: (context, state) {
        if (state is SaveObservationSuccess) {
          print("success");
          Navigator.of(context).pop();
        }
        if (state is SaveObservationError) {
          // Optionally show an error message
          print("❌ Error saving observation: ${state.message}");
        }
      },
      child: Container(
        color: CupertinoColors
            .systemGrey6, // Set the background color to systemGrey6
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MyNav(onPressedCallback: () {
                _sendObservationData(); // ✅ now just sends the data
              }),
              pinned: true,
              floating: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Dynamische Höhe
                  padding: const EdgeInsets.all(15.0),
                  child: NewObservationFrom(
                    callback: (value) => setState(() {
                      observation = value;
                      print(value);
                    }),
                  ),
                ),
                BlocBuilder<SaveObservationCubit, SaveObservationState>(
                  builder: (context, state) {
                    if (state is SaveObservationLoading) {
                      return const BaseIndicator();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocBuilder<GetTagsCubit, GetTagsState>(
                  builder: (context, state) {
                    if (state is GetTagsLoading) {
                      return const BaseIndicator();
                    } else if (state is GetTagsLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CupertinoListSection.insetGrouped(
                            header: const Text('Available Tags'),
                            children: state.tags!.map((tagObject) {
                              return CupertinoListTile(
                                title: TagWidget(
                                  tagName: tagObject.tag!,
                                  tagColor: tagObject.tagColor!,
                                ),
                                trailing: CupertinoSwitch(
                                  value: selectedTags.contains(
                                      tagObject), // Check if the tag is selected
                                  onChanged: (isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedTags.add(tagObject);
                                      } else {
                                        selectedTags.remove(tagObject);
                                      }
                                    });
                                    print(
                                        "Tag ${tagObject.toString()} selected: ${isSelected}");
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    } else if (state is GetTagsError) {
                      return Text("Error: ${state.message}",
                          style:
                              CupertinoTheme.of(context).textTheme.textStyle);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

typedef OnPressedCallback = void Function();

class MyNav extends SliverPersistentHeaderDelegate {
  final OnPressedCallback onPressedCallback;

  const MyNav({required this.onPressedCallback});

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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'New Observation',
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
