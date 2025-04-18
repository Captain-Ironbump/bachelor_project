import 'package:flutter/cupertino.dart';
import 'package:student_initializer/data_old/remote/models/observation.dart';
import 'package:student_initializer/domain_old/observation_service.dart';

class ObservationProvider with ChangeNotifier {
  final _service = ObservationService();
  List<ObservationModel> _data = [];
  List<ObservationModel> get data => _data;
  bool isLoading = false;

  Future<void> getObservationsFromLearner(int learnerId) async {
    isLoading = true;

    final response = await _service.getAllObservationsByLearnerId(learnerId);
    _data = response;
    isLoading = false;
    print('fetched');
    notifyListeners();
  }

  Future<void> saveObservation(int learnerId, String observation) async {
    isLoading = true;
    await _service.saveObservation(learnerId, observation);
    isLoading = false;
    notifyListeners();
  }
}
