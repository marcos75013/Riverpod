import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myFirstProvider = StateProvider<String>((ref) => 'Hello les codeurs!');
final mySecondProvider = StateProvider<String>((ref) => "Je suis une valeur dans un provider");
final myThirdProvider = Provider<bool>((ref) => true);
final myFourthProvider = Provider<int>((ref) => 1);
final myFifthProvider = Provider<double>((ref) => 1.5);

// Ajout de nouveaux providers modifiables
final counterProvider = StateProvider<int>((ref) => 0);
final messageProvider = StateProvider<String>((ref) => 'Message initial');
final themeProvider = StateProvider<bool>((ref) => false);

class SayHelloScreen extends ConsumerWidget {
  const SayHelloScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myFirstProvider);
    final counter = ref.watch(counterProvider);
    final message = ref.watch(messageProvider);
    final isDarkTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data,
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.blue,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Compteur: $counter',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state--,
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              message,
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.green,
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(messageProvider.notifier).state = 'Message modifié: ${DateTime.now().toString()}';
              },
              child: const Text('Changer le message'),
            ),
            const SizedBox(height: 30),
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                ref.read(themeProvider.notifier).state = value;
                ref.read(myFirstProvider.notifier).state = 'Hellos les amis';
              },
            ),
            Text(
              'Thème sombre',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
