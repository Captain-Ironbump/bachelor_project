import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:student_initializer/data_old/providers/observation_provider.dart';
import 'package:student_initializer/presenter/widgets/new_observation_from.dart';
import 'package:student_initializer/util/argumets/learner_page_arguments.dart';

class NewObservationPage extends StatefulWidget {
  final LearnerPageArgs args;

  const NewObservationPage({super.key, required this.args});

  @override
  State<NewObservationPage> createState() => _NewObservationPageState();
}

class _NewObservationPageState extends State<NewObservationPage> {
  late String observation;

  @override
  void initState() {
    super.initState();
    observation = "";
  }

  void _sendObservationData() {
    Provider.of<ObservationProvider>(context, listen: false)
        .saveObservation(widget.args.learner.learnerId!, observation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MyNav(onPressedCallback: () {
              _sendObservationData();
            }),
            pinned: true,
            floating: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(15.0),
                child: NewObservationFrom(
                  callback: (value) => setState(() {
                    observation = value;
                    print(value);
                  }),
                ),
              ),
            ]),
          )
        ],
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
      color: CupertinoColors.systemBackground,
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
                Navigator.of(context).pop();
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
