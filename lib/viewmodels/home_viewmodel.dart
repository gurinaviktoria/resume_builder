import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../repositories/person_repo_base.dart';
import '../repositories/person_repository.dart';

/// Репозиторій для Web (тимчасово в пам'яті)
class InMemoryPersonRepository implements PersonRepoBase {
  final List<Person> _list = [];
  int _idCounter = 1;

  @override
  Future<List<Person>> getAll() async => List.from(_list);

  @override
  Future<int> insert(Person p) async {
    final person = Person(
      id: _idCounter++,
      name: p.name,
      age: p.age,
      email: p.email,
      about: p.about,
      skills: List.from(p.skills),
    );
    _list.add(person);
    return person.id!;
  }

  @override
  Future<int> update(Person p) async {
    final index = _list.indexWhere((e) => e.id == p.id);
    if (index != -1) {
      _list[index] = p;
      return 1; // 1 рядок оновлено
    }
    return 0; // нічого не оновлено
  }

  @override
  Future<int> delete(int id) async {
    final initialLength = _list.length;
    _list.removeWhere((e) => e.id == id);
    return initialLength - _list.length; // кількість видалених рядків
  }
}

class HomeViewModel extends ChangeNotifier {
  final PersonRepoBase repo;

  List<Person> _people = [];
  List<Person> get people => _people;

  HomeViewModel()
      : repo = kIsWeb ? InMemoryPersonRepository() : PersonRepository.instance {
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
