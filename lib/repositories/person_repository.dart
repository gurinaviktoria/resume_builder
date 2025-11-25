import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/person.dart';
import 'person_repo_base.dart';

class PersonRepository implements PersonRepoBase {
  static final PersonRepository instance = PersonRepository._init();
  PersonRepository._init();

  Future<Database> get _db async => await AppDatabase.instance.database;

  @override
  Future<int> insert(Person p) async {
    final db = await _db;
    return db.insert('people', p.toMap());
  }

  @override
  Future<List<Person>> getAll() async {
    final db = await _db;
    final result = await db.query('people');
    return result.map((r) => Person.fromMap(r)).toList();
  }

  @override
  Future<int> update(Person p) async {
    final db = await _db;
    return db.update('people', p.toMap(),
        where: 'id = ?', whereArgs: [p.id]);
  }

  @override
  Future<int> delete(int id) async {
    final db = await _db;
    return db.delete('people', where: 'id = ?', whereArgs: [id]);
  }
}
