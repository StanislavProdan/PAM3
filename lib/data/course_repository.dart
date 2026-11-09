import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course_models.dart';

class CourseRepository {
  Future<CourseData> loadCourse() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final raw = await rootBundle.loadString('assets/lab_v4.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return CourseData.fromJson(json);
  }
}
