import 'package:student_initializer/data/models/tag_detail/tag_detail_model.dart';

abstract class TagRemoteDataSource {
  Future<List<TagDetailModel>> fetchAllTags();
  Future<void> saveTag({required TagDetailModel tagDetailModel});
}
