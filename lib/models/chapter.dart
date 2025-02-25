import 'package:riverpod_training/models/learning_session.dart';

class Chapter {
  String name;
  List<LearningSession> sessions;
  
  Chapter({required this.name, required this.sessions});
}