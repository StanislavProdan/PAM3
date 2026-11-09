import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/course_repository.dart';
import '../models/course_models.dart';

enum CourseStatus { initial, loading, success, empty, error }

enum CourseSort { recommended, alphabetical, duration }

enum LessonFilter { all, favorites, completed }

class CourseState {
  const CourseState({
    this.status = CourseStatus.initial,
    this.data,
    this.query = '',
    this.sort = CourseSort.recommended,
    this.filter = LessonFilter.all,
    this.favorites = const {},
    this.completedLessons = const {},
    this.error,
  });
  final CourseStatus status;
  final CourseData? data;
  final String query;
  final CourseSort sort;
  final LessonFilter filter;
  final Set<String> favorites;
  final Set<String> completedLessons;
  final String? error;
  CourseState copyWith({
    CourseStatus? status,
    CourseData? data,
    String? query,
    CourseSort? sort,
    LessonFilter? filter,
    Set<String>? favorites,
    Set<String>? completedLessons,
    String? error,
  }) => CourseState(
    status: status ?? this.status,
    data: data ?? this.data,
    query: query ?? this.query,
    sort: sort ?? this.sort,
    filter: filter ?? this.filter,
    favorites: favorites ?? this.favorites,
    completedLessons: completedLessons ?? this.completedLessons,
    error: error ?? this.error,
  );
}

class CourseCubit extends Cubit<CourseState> {
  CourseCubit(this.repository) : super(const CourseState());
  final CourseRepository repository;

  Future<void> load() async {
    emit(state.copyWith(status: CourseStatus.loading));
    try {
      final data = await repository.loadCourse();
      emit(state.copyWith(status: CourseStatus.success, data: data));
    } catch (error) {
      emit(state.copyWith(status: CourseStatus.error, error: error.toString()));
    }
  }

  void search(String value) => emit(state.copyWith(query: value));
  void sort(CourseSort value) => emit(state.copyWith(sort: value));
  void setFilter(LessonFilter value) => emit(state.copyWith(filter: value));
  void toggleFavorite(String id) {
    final favorites = {...state.favorites};
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    emit(state.copyWith(favorites: favorites));
  }

  void toggleLessonCompleted(String id) {
    final completed = {...state.completedLessons};
    completed.contains(id) ? completed.remove(id) : completed.add(id);
    emit(state.copyWith(completedLessons: completed));
  }
}
