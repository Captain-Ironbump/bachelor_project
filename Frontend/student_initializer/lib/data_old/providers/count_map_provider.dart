import 'package:flutter/material.dart';
import 'package:student_initializer/data_old/remote/models/learner.dart';
import 'package:student_initializer/domain_old/learner_service.dart';
import 'package:student_initializer/domain_old/observation_service.dart';

class CountMapProvider extends ChangeNotifier {
  final _service = ObservationService();
  final _learnerService = LearnerService();

  bool isLoading = false;
  Map<LearnerModel, int> _data = {};
  Map<LearnerModel, int> get data => _data;

  Future<void> fetchObservationCountPerLearner() async {
    isLoading = false;

    final learnersResponse = await _learnerService.getAllLearners();
    final countMapResponse = await _service.fetchCountMap();
    print(learnersResponse.toString());
    print(countMapResponse.toString());

    final sortedEntries = countMapResponse.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _data.clear();

    for (var entry in sortedEntries) {
      for (var element in learnersResponse) {
        if (element.learnerId! == int.tryParse(entry.key)) {
          _data.addEntries([MapEntry(element, entry.value)]);
        }
      }
    }
    isLoading = false;
    print(_data.toString());
    notifyListeners();
  }
}
