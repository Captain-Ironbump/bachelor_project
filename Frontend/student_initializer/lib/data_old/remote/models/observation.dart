import 'dart:convert';

class ObservationModel {
  int? observationId;
  String? createdDate;
  int? learnerId;
  String? observation;

  ObservationModel({
    this.observationId,
    this.createdDate,
    this.learnerId,
    this.observation,
  });

  ObservationModel.fromJson(Map<String, dynamic> json) {
    learnerId = json['learnerId'];
    createdDate = json['createdDateTime'];
    observationId = json['observationId'];
    observation = utf8.decode(base64.decode(json['rawObservation']));
  }
}
