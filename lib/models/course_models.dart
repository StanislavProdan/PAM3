class CourseData {
  const CourseData({required this.home, required this.course});
  final HomeData home;
  final Course course;
}

class HomeData {
  const HomeData({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.learned,
    required this.coursesTitle,
    required this.coursesAction,
    required this.promptTitle,
    required this.promptAction,
    required this.promptImage,
    required this.meetupTitle,
    required this.meetupSubtitle,
    required this.meetupImage,
    required this.plan,
  });
  final String greeting,
      subtitle,
      avatarUrl,
      coursesTitle,
      coursesAction,
      promptTitle,
      promptAction,
      promptImage,
      meetupTitle,
      meetupSubtitle,
      meetupImage;
  final Learned learned;
  final List<PlanItem> plan;

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final header = json['header'] as Map<String, dynamic>;
    final learned = json['learnedToday'] as Map<String, dynamic>;
    final plan =
        (json['learningPlan'] as Map<String, dynamic>)['items']
            as List<dynamic>;
    final courses = json['myCourses'] as Map<String, dynamic>;
    final prompt = json['learningPrompt'] as Map<String, dynamic>;
    final meetup = json['meetup'] as Map<String, dynamic>;
    return HomeData(
      greeting: header['greeting'] as String,
      subtitle: header['subtitle'] as String,
      avatarUrl: header['avatarUrl'] as String,
      learned: Learned.fromJson(learned),
      coursesTitle: courses['title'] as String,
      coursesAction: courses['actionLabel'] as String,
      promptTitle: prompt['title'] as String,
      promptAction: prompt['actionLabel'] as String,
      promptImage: prompt['imageUrl'] as String,
      meetupTitle: meetup['title'] as String,
      meetupSubtitle: meetup['subtitle'] as String,
      meetupImage: meetup['imageUrl'] as String,
      plan: plan
          .map((item) => PlanItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Learned {
  const Learned({
    required this.minutes,
    required this.goal,
    required this.progress,
  });
  final int minutes, goal;
  final double progress;
  factory Learned.fromJson(Map<String, dynamic> json) => Learned(
    minutes: json['learnedMinutes'] as int,
    goal: json['goalMinutes'] as int,
    progress: (json['progress'] as num).toDouble(),
  );
}

class PlanItem {
  const PlanItem({
    required this.title,
    required this.completed,
    required this.total,
  });
  final String title;
  final int completed, total;
  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
    title: json['title'] as String,
    completed: json['completed'] as int,
    total: json['total'] as int,
  );
}

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessonCount,
    required this.rating,
    required this.imageUrl,
    required this.heroLabel,
    required this.enrollLabel,
    required this.description,
    required this.lessons,
  });
  final String id,
      title,
      duration,
      imageUrl,
      heroLabel,
      enrollLabel,
      description;
  final int lessonCount;
  final double rating;
  final List<Lesson> lessons;

  factory Course.fromJson(Map<String, dynamic> json) {
    final hero = json['hero'] as Map<String, dynamic>;
    final description = json['description'] as Map<String, dynamic>;
    final actions = json['actions'] as Map<String, dynamic>;
    final enroll = actions['enroll'] as Map<String, dynamic>;
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      lessonCount: json['lessonCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: hero['imageUrl'] as String,
      heroLabel: hero['label'] as String,
      enrollLabel: enroll['label'] as String,
      description: description['text'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.locked,
    required this.completed,
  });
  final String id, title, duration;
  final bool locked, completed;
  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['id'] as String,
    title: json['title'] as String,
    duration: json['duration'] as String,
    locked: json['locked'] as bool,
    completed: json['completed'] as bool,
  );
}
