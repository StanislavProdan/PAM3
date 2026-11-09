import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/course_cubit.dart';
import 'widgets/remote_image.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool description = false;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseCubit>().state;
    final course = state.data!.course;
    final filtered = course.lessons.where((lesson) {
      final matchesQuery = lesson.title.toLowerCase().contains(
        state.query.toLowerCase(),
      );
      final matchesFilter = switch (state.filter) {
        LessonFilter.all => true,
        LessonFilter.favorites => state.favorites.contains(lesson.id),
        LessonFilter.completed => state.completedLessons.contains(lesson.id),
      };
      return matchesQuery && matchesFilter;
    }).toList();
    if (state.sort == CourseSort.alphabetical) {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Overview'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<CourseCubit>().toggleFavorite(course.id),
            icon: Icon(
              state.favorites.contains(course.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Stack(
            children: [
              RemoteImage(
                url: course.imageUrl,
                height: 210,
                width: double.infinity,
              ),
              Positioned(
                left: 18,
                bottom: 18,
                child: Text(
                  'SPOKEN ENGLISH',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black.withAlpha(150), blurRadius: 4),
                    ],
                  ),
                ),
              ),
              const Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.play_arrow,
                      color: Color(0xFFFF6F00),
                      size: 34,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            course.title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              Text(' ${course.duration}'),
              const SizedBox(width: 16),
              const Icon(
                Icons.menu_book_outlined,
                size: 18,
                color: Colors.grey,
              ),
              Text(' ${course.lessonCount} lessons'),
              const SizedBox(width: 16),
              const Icon(Icons.star, size: 18, color: Colors.amber),
              Text(' ${course.rating}'),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _Tab(
                  label: 'Lessons',
                  selected: !description,
                  onTap: () => setState(() => description = false),
                ),
              ),
              Expanded(
                child: _Tab(
                  label: 'Description',
                  selected: description,
                  onTap: () => setState(() => description = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (description)
            Text(
              course.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            )
          else ...[
            TextField(
              onChanged: context.read<CourseCubit>().search,
              decoration: InputDecoration(
                hintText: 'Search lessons',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<CourseSort>(
              initialValue: state.sort,
              decoration: const InputDecoration(labelText: 'Sort lessons'),
              items: const [
                DropdownMenuItem(
                  value: CourseSort.recommended,
                  child: Text('Recommended'),
                ),
                DropdownMenuItem(
                  value: CourseSort.alphabetical,
                  child: Text('Alphabetical'),
                ),
              ],
              onChanged: (value) {
                if (value != null) context.read<CourseCubit>().sort(value);
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _FilterChip(
                  label: 'Toate',
                  selected: state.filter == LessonFilter.all,
                  onSelected: () =>
                      context.read<CourseCubit>().setFilter(LessonFilter.all),
                ),
                _FilterChip(
                  label: 'Favorite',
                  selected: state.filter == LessonFilter.favorites,
                  onSelected: () => context.read<CourseCubit>().setFilter(
                    LessonFilter.favorites,
                  ),
                ),
                _FilterChip(
                  label: 'Finalizate',
                  selected: state.filter == LessonFilter.completed,
                  onSelected: () => context.read<CourseCubit>().setFilter(
                    LessonFilter.completed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text('Nu au fost găsite lecții.')),
              )
            else
              ...filtered.map(
                (lesson) => Card(
                  elevation: 0,
                  child: ListTile(
                    enabled: !lesson.locked,
                    leading: IconButton(
                      onPressed: lesson.locked
                          ? null
                          : () => context
                                .read<CourseCubit>()
                                .toggleLessonCompleted(lesson.id),
                      icon: Icon(
                        state.completedLessons.contains(lesson.id)
                            ? Icons.check_circle
                            : (lesson.locked
                                  ? Icons.lock_outline
                                  : Icons.play_circle_outline),
                        color: lesson.locked
                            ? Colors.grey
                            : (state.completedLessons.contains(lesson.id)
                                  ? Colors.green
                                  : const Color(0xFFFF6F00)),
                        size: 34,
                      ),
                    ),
                    title: Text(lesson.title),
                    subtitle: Text(lesson.duration),
                    trailing: IconButton(
                      onPressed: lesson.locked
                          ? null
                          : () => context.read<CourseCubit>().toggleFavorite(
                              lesson.id,
                            ),
                      icon: Icon(
                        state.favorites.contains(lesson.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Te-ai înscris la curs!')),
              ),
              child: const Text('Enroll Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected ? const Color(0xFFFF6F00) : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFFFF6F00) : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
    selectedColor: const Color(0xFFFFDCC7),
    labelStyle: TextStyle(
      color: selected ? const Color(0xFFFF6F00) : Colors.grey.shade700,
      fontWeight: FontWeight.w600,
    ),
  );
}
