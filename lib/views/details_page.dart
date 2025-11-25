import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/person.dart';
import '../viewmodels/details_viewmodel.dart';

class DetailsPage extends StatelessWidget {
  final Person person;

  const DetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final vm = DetailsViewModel(person: person);

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${person.name}', style: const TextStyle(fontSize: 20)),
            Text('Age: ${person.age}', style: const TextStyle(fontSize: 20)),
            Text('Email: ${person.email}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text('About:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(person.about),
            const SizedBox(height: 16),
            const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...vm.skills.map((s) => Text('• $s')),
            const Spacer(),
            Center(child: ElevatedButton(onPressed: () => context.go('/'), child: const Text('Back'))),
          ],
        ),
      ),
    );
  }
}
