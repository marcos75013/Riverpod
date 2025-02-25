import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_training/apprendre_consumers/consumer.dart';
import 'package:riverpod_training/apprendre_consumers/consumer_state.dart';
import 'package:riverpod_training/apprendre_consumers/consumer_widget.dart';
import 'package:riverpod_training/models/chapter.dart';
import 'package:riverpod_training/models/learning_session.dart';
import 'package:riverpod_training/providers/async_notifier_provider.dart';
import 'package:riverpod_training/providers/change_notifier_provider.dart';
import 'package:riverpod_training/providers/future_provider.dart';
import 'package:riverpod_training/providers/future_provider_autodispose.dart';
import 'package:riverpod_training/providers/notifier_provider.dart';
import 'package:riverpod_training/providers/state_notifier_provider.dart';
import 'package:riverpod_training/providers/state_provider.dart';
import 'package:riverpod_training/providers/stream_provider.dart';

final chaptersProvider = Provider<List<Chapter>>((ref) {
  return [
    Chapter(name: "Les Consumers", sessions: [
      LearningSession(name: "ConsumerWidget", project: "", body: const SayHelloScreen()),
      LearningSession(name: "Consumers", project: "", body: const ShowImageScreen()),
      LearningSession(name: "Consumer State", project: "", body: const StateFullScreen())
    ]),
    Chapter(name: "Les Providers", sessions: [
      LearningSession(name: "State Provider", project: "Création d'un counter", body: CounterScreen()),
      LearningSession(name: "Future Provider",project: "Accès flux RSS", body: const RSSLoaderScreen()),
      LearningSession(name: "Future Provider AutoDispose",project: "Appel à une API", body: const RandomUserScreen()),
      LearningSession(name: "Stream Provider",project: "Création d'une horloge", body: const ClockScreen()),
      LearningSession(name: "Change Notifier Provider",project: "To do list", body: const TodoListScreen()),
      LearningSession(name: "State Notifier Provider", project: "Changer le thème de l'app", body: const ThemeSettingsScreen()),
      LearningSession(name: "Notifier Provider", project: "Calculer le pourboire", body: const TipCalculatorScreen()),
      LearningSession(name: "Async Notifier Provider", project: "Blagues", body: const JokeScreen())
    ])
  ];
});

final bodyProvider = StateProvider<Widget>((ref) {
  return Center(
    child: Column(
      children: [
        Image.asset(
          'images/riverpod.png',
        ),
        const Text('Appuyez sur le Drawer pour voir les chapitres'),
      ],
    ),
  );
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
  final chapters = ref.watch(chaptersProvider);
  final body = ref.watch(bodyProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Training'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return const DrawerHeader(child: FlutterLogo());
            } else {
              int currentIndex = index - 1;
              Chapter chapter = chapters[currentIndex];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      chapter.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Column(
                    children: chapter.sessions.map((session) {
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.inversePrimary,
                        title: Text(session.name),
                        subtitle: Text(session.project),
                        onTap: () {
                          ref.read(bodyProvider.notifier).state = session.body;
                           Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          },
          itemCount: chapters.length + 1,
        ),
      ),
      body: ref.watch(bodyProvider),
    );
  }

}
