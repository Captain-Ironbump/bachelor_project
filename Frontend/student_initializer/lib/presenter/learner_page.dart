import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_initializer/data_old/providers/learner_provider.dart';
import 'package:student_initializer/data_old/providers/observation_provider.dart';
import 'package:student_initializer/presenter/new_observation_page.dart';
import 'package:student_initializer/util/argumets/learner_page_arguments.dart';

class LearnerPage extends StatefulWidget {
  final LearnerPageArgs args;

  const LearnerPage({super.key, required this.args});

  @override
  State<LearnerPage> createState() => _LearnerPageState();
}

class _LearnerPageState extends State<LearnerPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late List<dynamic> _observations = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ObservationProvider>(context, listen: false)
          .getObservationsFromLearner(widget.args.learner.learnerId!);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNewObservationDialog(BuildContext context) {
    _animationController.forward();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: NewObservationPage(args: widget.args),
          ),
        );
      },
    ).then((value) {
      _animationController.reverse();
    });
  }

  Widget _trailingButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: const Icon(CupertinoIcons.share_up),
          onPressed: () {},
        ),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: const Icon(CupertinoIcons.add_circled_solid),
          onPressed: () => _showNewObservationDialog(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        double scale = 1 - (_scaleAnimation.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: widget.args.previousPageTitle,
            middle: Text(
                "${widget.args.learner.firstName} ${widget.args.learner.lastName}"),
            trailing: _trailingButtons(context)
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (Provider.of<ObservationProvider>(context)
                          .data
                          .isEmpty)
                        const Center(
                          child: Text('No Data available'),
                        ),
                      if (Provider.of<ObservationProvider>(context)
                          .data
                          .isNotEmpty)
                        ListView.builder(
                          shrinkWrap:
                              true, // Ensure ListView only takes as much space as needed
                          physics:
                              NeverScrollableScrollPhysics(), // Disable internal scrolling of ListView
                          itemCount: Provider.of<ObservationProvider>(context)
                              .data
                              .length,
                          itemBuilder: (context, index) {
                            var element =
                                Provider.of<ObservationProvider>(context)
                                    .data[index];

                            // Format the created date
                            String formattedDate =
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    DateTime.parse(element.createdDate!));

                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: CupertinoColors
                                    .systemGrey5, // Slight grey color
                                borderRadius: BorderRadius.circular(
                                    10.0), // Rounded borders
                              ),
                              margin: const EdgeInsets.only(
                                  bottom:
                                      10.0), // Add some space between containers
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors
                                              .inactiveGray, // Grey color for the date
                                          fontSize: 12.0,
                                        ),
                                  ),
                                  const SizedBox(
                                      height:
                                          8.0), // Space between date and observation
                                  Text(
                                    element.observation!,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
