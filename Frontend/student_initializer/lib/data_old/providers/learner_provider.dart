import 'package:flutter/cupertino.dart';
import 'package:student_initializer/data_old/remote/models/learner.dart';
import 'package:student_initializer/domain_old/learner_service.dart';

class LearnerProvider with ChangeNotifier {
  final _service = LearnerService();
  bool isLoading = false;
  List<LearnerModel> _data = [];
  List<LearnerModel> get data => _data;

  Future<void> getLearnersData() async {
    isLoading = true;

    final response = await _service.getAllLearners();
    _data = response;
    isLoading = false;
    print('fetched');
    notifyListeners();
  }
}
