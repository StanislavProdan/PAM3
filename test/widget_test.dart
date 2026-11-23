import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pam4/main.dart';
import 'package:pam4/data/api_client.dart';
import 'package:pam4/data/course_repository.dart';
import 'package:pam4/logic/course_cubit.dart';
import 'dart:convert';

void main() {
  test('falls back to bundled data when the API cannot be fetched', () async {
    final repository = CourseRepository(
      apiClient: ApiClient(client: _FailingApiClient()),
    );

    final data = await repository.loadCourse();

    expect(data.home.greeting, 'Hi, Kristin');
    expect(data.course.title, 'React Front To back');
  });

  testWidgets('loads the learning dashboard', (tester) async {
    final repository = CourseRepository(
      apiClient: ApiClient(client: _FakeApiClient()),
    );
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => CourseCubit(repository)..load(),
        child: const LearningApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Learned today'), findsOneWidget);
    expect(find.text('My courses'), findsOneWidget);
  });
}

class _FailingApiClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw http.ClientException('Failed to fetch', request.url);
  }
}

class _FakeApiClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final isDetails = request.url.path.endsWith('/details');
    final payload = isDetails ? _details : _feed;
    final body = jsonEncode(payload);
    return http.StreamedResponse(
      Stream<List<int>>.value(utf8.encode(body)),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

const _feed = <String, dynamic>{
  'header': {
    'greeting': 'Hi',
    'subtitle': 'Learn',
    'avatarUrl': 'https://example.com/avatar.png',
  },
  'learnedToday': {'learnedMinutes': 1, 'goalMinutes': 2, 'progress': 0.5},
  'myCourses': {'title': 'My courses', 'actionLabel': 'View all'},
  'learningPrompt': {
    'title': 'Learn today',
    'actionLabel': 'Start',
    'imageUrl': 'https://example.com/prompt.png',
  },
  'learningPlan': {
    'items': <Map<String, dynamic>>[
      {'title': 'Basics', 'completed': 1, 'total': 2},
    ],
  },
  'meetup': {
    'title': 'Meetup',
    'subtitle': 'Learn together',
    'imageUrl': 'https://example.com/meetup.png',
  },
};

const _details = <String, dynamic>{
  'course': {
    'id': 'course',
    'title': 'Course',
    'duration': '1h',
    'lessonCount': 1,
    'rating': 5,
    'hero': {'label': 'COURSE', 'imageUrl': 'https://example.com/course.png'},
    'lessons': <Map<String, dynamic>>[
      {
        'id': 'lesson',
        'title': 'Lesson',
        'duration': '01:00',
        'locked': false,
        'completed': false,
      },
    ],
    'description': {'text': 'Description'},
  },
  'actions': {
    'enroll': {'label': 'Enroll', 'enabled': true},
  },
};
