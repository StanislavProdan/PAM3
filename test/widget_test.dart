import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pam3/main.dart';
import 'package:pam3/data/course_repository.dart';
import 'package:pam3/logic/course_cubit.dart';

void main() {
  testWidgets('loads the learning dashboard', (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => CourseCubit(CourseRepository())..load(),
        child: const LearningApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Learned today'), findsOneWidget);
    expect(find.text('My courses'), findsOneWidget);
  });
}
