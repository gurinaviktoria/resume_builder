import '../models/person.dart';

abstract class PersonRepoBase {
  Future<int> insert(Person p);
  Future<List<Person>> getAll();
  Future<int> update(Person p);
  Future<int> delete(int id);
}
