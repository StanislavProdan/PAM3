# PAM4 - Laborator nr. 4

Aplicație Flutter pentru gestionarea unei platforme de învățare. Proiectul demonstrează state management cu BLoC/Cubit, programare asincronă, integrare REST API, serializare JSON, arhitectură Clean și componente UI reutilizabile.

## Cerințe implementate

| Cerință | Implementare |
|---|---|
| Încărcare asincronă a datelor | `CourseRepository.loadCourse()` în [`lib/data/course_repository.dart`](lib/data/course_repository.dart), cu apeluri paralele |
| Integrare REST API | [`ApiClient`](lib/data/api_client.dart) apelează endpointurile `/feed` și `/feed/details` |
| State management cu BLoC/Cubit | [`CourseCubit`](lib/logic/course_cubit.dart) și `BlocProvider` în [`lib/main.dart`](lib/main.dart) |
| Stare Loading | `CourseStatus.loading` în [`CourseCubit.load()`](lib/logic/course_cubit.dart) și indicatorul din [`HomePage`](lib/presentation/home_page.dart) |
| Stare Success | `CourseStatus.success` și afișarea dashboard-ului în [`HomePage`](lib/presentation/home_page.dart) |
| Stare Error | `CourseStatus.error`, mesajul de eroare și tratarea excepțiilor în [`CourseCubit`](lib/logic/course_cubit.dart) |
| Stare Empty | `CourseStatus.empty` și mesajul „Nu există date disponibile.” în [`HomePage`](lib/presentation/home_page.dart) |
| Modelarea datelor | Modelele `CourseData`, `HomeData`, `Course`, `Lesson` în [`lib/models/course_models.dart`](lib/models/course_models.dart) |
| Arhitectură modulară | Separarea în `data`, `models`, `logic` și `presentation` |
| Componente UI reutilizabile | [`RemoteImage`](lib/presentation/widgets/remote_image.dart) și [`SectionTitle`](lib/presentation/widgets/section_title.dart) |
| Dashboard principal | [`HomePage`](lib/presentation/home_page.dart) |
| Navigare către pagina de detalii | [`CoursePage`](lib/presentation/course_page.dart), accesată din cardul cursului |
| Căutare | Căutarea lecțiilor după titlu în [`CoursePage`](lib/presentation/course_page.dart), prin `CourseCubit.search()` |
| Sortare | Sortare recomandată/alfabetică în [`CoursePage`](lib/presentation/course_page.dart), prin `CourseCubit.sort()` |
| Filtrare | Filtrele „Toate”, „Favorite” și „Finalizate” în [`CoursePage`](lib/presentation/course_page.dart) |
| Favorite | Favorite pentru curs și lecții prin `toggleFavorite()` în [`CourseCubit`](lib/logic/course_cubit.dart) |
| Finalizarea lecțiilor | `toggleLessonCompleted()` și filtrul `LessonFilter.completed` în [`CourseCubit`](lib/logic/course_cubit.dart) |
| Pagina de descriere a cursului | Tab-ul `Description` în [`CoursePage`](lib/presentation/course_page.dart) |
| Înscriere la curs | Butonul „Enroll Now” din [`CoursePage`](lib/presentation/course_page.dart) |
| Design responsive | `LayoutBuilder` și constrângeri adaptive în [`HomePage`](lib/presentation/home_page.dart) |

## Structura proiectului

```text
lib/
├── data/
│   ├── api_client.dart
│   └── course_repository.dart
├── logic/
│   └── course_cubit.dart
├── models/
│   └── course_models.dart
├── presentation/
│   ├── course_page.dart
│   ├── home_page.dart
│   └── widgets/
│       ├── remote_image.dart
│       └── section_title.dart
└── main.dart
```

## Rulare

```powershell
flutter pub get
flutter run
```

## Verificare

```powershell
flutter analyze
flutter test
```

În starea verificată, analiza statică nu raportează probleme, iar testele widget trec cu succes.
