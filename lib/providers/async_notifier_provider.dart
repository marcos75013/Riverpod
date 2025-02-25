import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//1: Provider
final jokeProvider = AsyncNotifierProvider<JokeNotifier, Joke>(JokeNotifier.new);

//2. Consumer
class JokeScreen extends ConsumerWidget {
  const JokeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokeP = ref.watch(jokeProvider);
    final jokeNotifier = ref.read(jokeProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Ma Blague', style: TextStyle(fontSize: 24)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: jokeP.when(
              data: (joke) => JokeCard(joke: joke),
              error: (e, s) => Text(e.toString()),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               ElevatedButton(
            onPressed: () {
              jokeNotifier.newJoke();
            },
            child: const Text('Nouvelle Blague'),
          ),
            ],
      
          )
         
        ],
      ),
    );
  }
}

class JokeCard extends StatelessWidget {
  final Joke joke;
  const JokeCard({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              joke.setup,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              joke.punchline,
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//3. Notifier
class JokeNotifier extends AsyncNotifier<Joke> {
  @override
  FutureOr<Joke> build() {
    return fetch();
  }

  Future<Joke> fetch() async {
    final url = Uri.parse('https://official-joke-api.appspot.com/jokes/random');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Joke.fromJson(json);
    } else {
      throw Exception('Failed to load joke');
    }
  }

  Future<void> newJoke() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => fetch());
  }
}

//4. Modeles
class Joke {
  String setup;
  String punchline;

  Joke({required this.setup, required this.punchline});

  Joke.fromJson(Map<String, dynamic> json)
      : setup = json['setup'],
        punchline = json['punchline'];
}
