import 'package:go_router/go_router.dart';
import '../views/home_page.dart';
import '../views/add_person_page.dart';
import '../views/details_page.dart';
import '../models/person.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/add',
      builder: (_, state) {
        final person = state.extra as Person?;
        return AddPersonPage(person: person, isEditing: person != null);
      },
    ),
    GoRoute(
      path: '/details',
      builder: (_, state) {
        final person = state.extra as Person;
        return DetailsPage(person: person);
      },
    ),
  ],
);
