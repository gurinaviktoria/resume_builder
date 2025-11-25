import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/person.dart';
import '../viewmodels/home_viewmodel.dart';

class AddPersonPage extends StatefulWidget {
  final Person? person;
  final bool isEditing;

  const AddPersonPage({super.key, this.person, this.isEditing = false});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, about;
  late int age;
  List<String> skills = [];
  final TextEditingController skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    name = p?.name ?? '';
    email = p?.email ?? '';
    about = p?.about ?? '';
    age = p?.age ?? 18;
    skills = p?.skills ?? [];
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newPerson = Person(
      id: widget.person?.id,
      name: name,
      age: age,
      email: email,
      about: about,
      skills: skills,
    );

    final vm = context.read<HomeViewModel>();
    if (widget.isEditing) {
      vm.updatePerson(newPerson);
    } else {
      vm.addPerson(newPerson);
    }

    context.pop();
  }

  void _addSkill() {
    if (skillController.text.trim().isEmpty) return;
    setState(() {
      skills.add(skillController.text.trim());
      skillController.clear();
    });
  }

  void _removeSkill(String s) {
    setState(() => skills.remove(s));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Resume' : 'New Resume')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
                onSaved: (v) => email = v!,
              ),
              TextFormField(
                initialValue: about,
                decoration: const InputDecoration(labelText: 'About'),
                onSaved: (v) => about = v ?? '',
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 0) return 'Invalid age';
                  return null;
                },
                onSaved: (v) => age = int.parse(v!),
              ),
              const SizedBox(height: 16),
              const Text('Skills:'),
              Wrap(
                spacing: 8,
                children: skills.map((s) => Chip(label: Text(s), onDeleted: () => _removeSkill(s))).toList(),
              ),
              Row(
                children: [
                  Expanded(child: TextField(controller: skillController, decoration: const InputDecoration(hintText: 'New skill'))),
                  IconButton(icon: const Icon(Icons.add), onPressed: _addSkill),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text(widget.isEditing ? 'Save' : 'Add')),
            ],
          ),
        ),
      ),
    );
  }
}
