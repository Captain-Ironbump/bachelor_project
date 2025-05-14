import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/tag/tag_remote_data_source.dart';
import 'package:student_initializer/data/models/tag_detail/tag_detail_model.dart';
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';
import 'package:http/http.dart' as http;

class TagRemoteDataSourceImpl implements TagRemoteDataSource {
  @override
  Future<List<TagDetailModel>> fetchAllTags() async {
    try {
      final Uri uri = SimplifiedUri.uri('${PlattformUri.getUri()}/tags', null);
      final response = await http.get(uri);
      final List<dynamic> items = json.decode(response.body);
      return items.map((item) => TagDetailModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveTag({required TagDetailModel tagDetailModel}) {
    // TODO: implement saveTag
    throw UnimplementedError();
  }
}
