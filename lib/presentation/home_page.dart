import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/course_cubit.dart';
import 'course_page.dart';
import 'widgets/remote_image.dart';
import 'widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state.status == CourseStatus.loading ||
              state.status == CourseStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CourseStatus.error) {
            return Center(child: Text('Eroare la încărcare: ${state.error}'));
          }
          if (state.status == CourseStatus.empty || state.data == null) {
            return const Center(child: Text('Nu există date disponibile.'));
          }
          final home = state.data!.home;
          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 700;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 48 : 22,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1050),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(home: home),
                        const SizedBox(height: 28),
                        _LearningProgress(home: home),
                        const SizedBox(height: 30),
                        SectionTitle(title: 'My courses', action: 'View all'),
                        const SizedBox(height: 14),
                        _CourseCard(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CoursePage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SectionTitle(title: 'Learning Plan'),
                        const SizedBox(height: 14),
                        ...home.plan.map(
                          (item) => _PlanTile(
                            title: item.title,
                            completed: item.completed,
                            total: item.total,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _PromptCard(imageUrl: home.promptImage),
                        const SizedBox(height: 18),
                        _MeetupCard(imageUrl: home.meetupImage),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.home});
  final dynamic home;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipOval(
        child: Image.network(
          home.avatarUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 56,
            height: 56,
            color: Colors.orange.shade100,
            child: const Icon(Icons.person_outline),
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              home.greeting,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(home.subtitle, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
      Stack(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
          ),
          Positioned(
            right: 10,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6F00),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _LearningProgress extends StatelessWidget {
  const _LearningProgress({required this.home});
  final dynamic home;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0E7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: home.learned.progress,
                strokeWidth: 8,
                backgroundColor: Colors.white,
                color: const Color(0xFFFF6F00),
              ),
              Text(
                '${home.learned.minutes}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learned today',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 4),
            Text(
              '${home.learned.minutes}min / ${home.learned.goal}min',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black87,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Opacity(
                opacity: .55,
                child: RemoteImage(
                  url: 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80',
                  radius: 20,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'React Front To back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '6h 30min  •  7 lessons',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 20,
            child: CircleAvatar(
              backgroundColor: Color(0xFFFF6F00),
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.title,
    required this.completed,
    required this.total,
  });
  final String title;
  final int completed, total;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const Icon(Icons.auto_graph, color: Color(0xFF7E858C)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: LinearProgressIndicator(
          value: completed / total,
          color: const Color(0xFFFF6F00),
          backgroundColor: Colors.orange.shade50,
        ),
      ),
      trailing: Text('$completed/$total'),
    ),
  );
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    child: Stack(
      children: [
        Positioned.fill(child: RemoteImage(url: imageUrl)),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black38,
            ),
          ),
        ),
        const Positioned(
          left: 20,
          top: 24,
          child: Text(
            'What do you want to\\nlearn today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 18,
          child: FilledButton(
            onPressed: () {},
            child: const Text('Get Started'),
          ),
        ),
      ],
    ),
  );
}

class _MeetupCard extends StatelessWidget {
  const _MeetupCard({required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        RemoteImage(url: imageUrl, width: 110, height: 80, radius: 14),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meetup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Off-line exchange of learning experience',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
