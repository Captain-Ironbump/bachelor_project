import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:student_initializer/data_old/providers/learner_provider.dart';
import 'package:student_initializer/presenter/new_student_page.dart';
import 'package:student_initializer/presenter/widgets/learners_form.dart';
import 'package:student_initializer/util/argumets/page_arguments.dart';

class LearnersPage extends StatefulWidget {
  const LearnersPage({super.key});

  @override
  State<LearnersPage> createState() => _LearnersPageState();
}

class _LearnersPageState extends State<LearnersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LearnerProvider>(context, listen: false).getLearnersData();
    });
  }

  Future<void> _refreshEvent() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LearnerProvider>(context, listen: false).getLearnersData();
    });
  }

  void _createNewStudent() {
    //_navigateToPage();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: NewStudentPage(args: PageArgs(previousPageTitle: 'Learners')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Learners'),
            trailing: CupertinoButton(
              padding: const EdgeInsets.only(bottom: 2.0),
              onPressed: () => _createNewStudent(),
              child:
                  const Icon(CupertinoIcons.person_crop_circle_fill_badge_plus),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshEvent,
            refreshIndicatorExtent: 15.0,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            if (Provider.of<LearnerProvider>(context).isLoading)
              const Center(
                child: CupertinoActivityIndicator(),
              ),
            if (Provider.of<LearnerProvider>(context).data.isNotEmpty)
              LearnersForm(learners: Provider.of<LearnerProvider>(context, listen: false).data),
            if (Provider.of<LearnerProvider>(context).data.isEmpty && !Provider.of<LearnerProvider>(context).isLoading)
              const Text('No Data')
          ])),
        ],
      ),
    );
  }
}
