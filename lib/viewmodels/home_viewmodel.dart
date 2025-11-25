import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../repositories/person_repo_base.dart';
import '../repositories/person_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PersonRepoBase repo;

  List<Person> _people = [];
  List<Person> get people => _people;

  HomeViewModel() : repo = PersonRepository.instance {
    loadPeople();
  }

  HomeViewModel.forTests(this.repo);

  Future<void> loadPeople() async {
    _people = await repo.getAll();
    notifyListeners();
  }

  Future<void> addPerson(Person p) async {
    final map = p.toMap()..remove('id');
    await repo.insert(Person.fromMap(map));
    await loadPeople();
  }

  Future<void> updatePerson(Person p) async {
    await repo.update(p);
    await loadPeople();
  }

  Future<void> deletePerson(int id) async {
    await repo.delete(id);
    await loadPeople();
  }

  Future<void> duplicatePerson(int index) async {
    final original = _people[index];

    final copy = Person(
      name: '${original.name} (copy)',
      age: original.age,
      email: original.email,
      about: original.about,
      skills: List.from(original.skills),
    );

    await addPerson(copy);
  }
}
