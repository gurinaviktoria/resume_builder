import '../models/person.dart';

class DetailsViewModel {
  final Person person;
  DetailsViewModel({required this.person});

  List<String> get skills => person.skills;
}
