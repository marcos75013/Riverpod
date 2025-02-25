import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//1. Provider

final counter = StateProvider<int>((ref) => 0); 
final colorProvider = StateProvider<Color>((ref) => Colors.red);

//2. Consumer

class CounterScreen extends ConsumerWidget {
  CounterScreen({super.key});

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,  
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorRef = ref.watch(colorProvider);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Le state provider', style: Theme.of(context).textTheme.titleLarge),
        Text("Nombre du count: ${ref.watch(counter)}", style: TextStyle(color: colorRef, fontSize: 24),),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors.map((colors) {
            return FloatingActionButton.small(
              onPressed: () {
               ref.read(colorProvider.notifier).state = colors;
              },  
              backgroundColor: colors,
              child: const Icon(Icons.palette,),  
            );
          }).toList(),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                  onPressed: () {
                    ref.read(counter.notifier).state++;
                  },
                  child: const Icon(Icons.add)),
              FloatingActionButton(
                  onPressed: () {
                    ref.read(counter.notifier).state--;
                  },
                  child: const Icon(Icons.minimize)),
            ],
          ),
        )
      ],
    ));
  }
}
