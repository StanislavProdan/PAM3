import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/course_repository.dart';
import 'logic/course_cubit.dart';
import 'presentation/home_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => CourseCubit(CourseRepository())..load(),
      child: const LearningApp(),
    ),
  );
}

class LearningApp extends StatelessWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Learnly',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6F00)),
      scaffoldBackgroundColor: const Color(0xFFF9F9FA),
      useMaterial3: true,
      fontFamily: 'Arial',
    ),
    home: const HomePage(),
  );
}
