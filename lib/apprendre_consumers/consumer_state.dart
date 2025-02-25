import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkProvider = StateProvider<bool>((ref) => true);
final yearProvider = Provider<int>((ref) => 1993);

class StateFullScreen extends ConsumerStatefulWidget {
  const StateFullScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StateForScreen();
  }
}

class _StateForScreen extends ConsumerState<StateFullScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkProvider);
    final textColor = isDark ? Colors.white : Colors.black;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: isDark ? Colors.black87 : Colors.white,
            elevation: 10,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Je suis un ConsumerStatefulWidget',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    ref.watch(yearProvider).toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20), 
          FloatingActionButton(
            backgroundColor:  Colors.white,
            onPressed: () {
        

              ref.read(darkProvider.notifier).state = !isDark;
           
            },
            child: const Icon(Icons.palette, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
