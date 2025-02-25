import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_training/home_page/home_page.dart';
import 'package:riverpod_training/providers/state_notifier_provider.dart';

void main() {
  runApp(const ProviderScope(
    child: MyConsumeApp()));
}

class MyConsumeApp extends ConsumerWidget {
  const MyConsumeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final theme = ref.watch(themeNotifierProvider);
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Riverpod',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
    darkTheme: ThemeData.dark(),
    themeMode: theme == AppTheme.light ? ThemeMode.light : ThemeMode.dark,
    home: const HomePage(),
  );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


