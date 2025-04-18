import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:student_initializer/data_old/providers/count_map_provider.dart';
import 'package:student_initializer/presenter/new_student_page.dart';
import 'package:student_initializer/presenter/widgets/dashboard_count_map.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';
import 'package:student_initializer/util/route/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _createNewStudent() {
    //_navigateToPage();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: NewStudentPage(args: PageArgs(previousPageTitle: 'Homeage')),
        );
      },
    );
  }

  void _navigateToPage() {
    Navigator.of(context, rootNavigator: true).push(AppRoutes.newStudentPage
        .route(PageArgs(previousPageTitle: 'Homepage')));
  }

  Future<void> _refreshDashboard() async {
    Provider.of<CountMapProvider>(context, listen: false).fetchObservationCountPerLearner();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            trailing: CupertinoButton(
              padding: const EdgeInsets.only(bottom: 2.0),
              onPressed: () => _createNewStudent(),
              child:
                  const Icon(CupertinoIcons.person_crop_circle_fill_badge_plus),
            ),
            largeTitle: const Text('Homepage'),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshDashboard,
            refreshIndicatorExtent: 15.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.only(top: 10),
              ),
              Center(
                child: CupertinoButton.filled(
                  child: const Text('Student init with Text Field'),
                  onPressed: () => Navigator.of(context, rootNavigator: true)
                      .push(AppRoutes.studentTextFieldPage
                          .route(PageArgs(previousPageTitle: 'Homepage'))),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
              ),
              Center(
                child: CupertinoButton.filled(
                  child: const Text('Student init with Sliders'),
                  onPressed: () => Navigator.of(context, rootNavigator: true)
                      .push(AppRoutes.studentSliderPage
                          .route(PageArgs(previousPageTitle: 'Homepage'))),
                ),
              ),
              const DashboardCountMap(),
            ]),
          )
        ],
      ),
    );
  }
}
