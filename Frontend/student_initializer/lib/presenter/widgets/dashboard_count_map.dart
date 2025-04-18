import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:student_initializer/data_old/providers/count_map_provider.dart';
import 'package:student_initializer/data_old/remote/models/learner.dart';

class DashboardCountMap extends StatefulWidget {
  const DashboardCountMap({super.key});

  @override
  State<DashboardCountMap> createState() => _DashboardCountMapState();
}

class _DashboardCountMapState extends State<DashboardCountMap> {
  Map<LearnerModel, int> obsPerLearner = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountMapProvider>(context, listen: false)
          .fetchObservationCountPerLearner();
    });
  }

  Widget _listSectionUI(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: const Text('Obs Per Learner'),
      children:
          Provider.of<CountMapProvider>(context).data.entries.map((entry) {
        return CupertinoListTile(
          title: Text('${entry.key.firstName} ${entry.key.lastName}'),
          additionalInfo: Text('${entry.value}'),
        );
      }).toList(),
    );
  }

  Widget _loadingUI(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Provider.of<CountMapProvider>(context).isLoading
          ? _loadingUI(context)
          : Provider.of<CountMapProvider>(context).data.isEmpty && !Provider.of<CountMapProvider>(context).isLoading
              ? const Center(child: Text('No data available'))
              : Provider.of<CountMapProvider>(context).data.isNotEmpty
                  ? _listSectionUI(context)
                  : null,
    );
  }
}
