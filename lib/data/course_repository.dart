import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import '../models/course_models.dart';

class CourseRepository {
  CourseRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<CourseData> loadCourse() async {
    try {
      final responses = await Future.wait([
        _apiClient.getJson('/feed'),
        _apiClient.getJson('/feed/details'),
      ]);
      return _buildCourseData(responses[0], responses[1]);
    } on http.ClientException {
      return _loadBundledCourse();
    }
  }

  CourseData _buildCourseData(
    Map<String, dynamic> homeJson,
    Map<String, dynamic> detailsJson,
  ) {
    final courseJson = {
      ...(detailsJson['course'] as Map<String, dynamic>),
      'actions': detailsJson['actions'],
    };
    return CourseData(
      home: HomeData.fromJson(homeJson),
      course: Course.fromJson(courseJson),
    );
  }

  Future<CourseData> _loadBundledCourse() async {
    final json =
        jsonDecode(await rootBundle.loadString('assets/lab_v4.json'))
            as Map<String, dynamic>;
    final home = Map<String, dynamic>.from(json['homePage'] as Map);
    final overview = Map<String, dynamic>.from(
      json['courseOverviewPage'] as Map,
    );
    return _buildCourseData(home, overview);
  }
}
