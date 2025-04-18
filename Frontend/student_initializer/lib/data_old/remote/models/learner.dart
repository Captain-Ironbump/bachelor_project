class LearnerModel {
  int? learnerId;
  String? firstName;
  String? lastName;

  LearnerModel({this.learnerId, this.firstName, this.lastName});

  LearnerModel.fromJson(Map<String, dynamic> json) {
    learnerId = json['learnerId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }
}
