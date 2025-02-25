import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

//1. Providers
final todoNotifierProvider = ChangeNotifierProvider<TodoNotifier>(
  (ref) => TodoNotifier(
    toDos: [ToDo(name: "Apprendre Riverpod")],
  ),
);

//2. Consumer
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(Object context, WidgetRef ref) {
    final listen = ref.watch(todoNotifierProvider); // permet de lire le provider
    final TextEditingController controller = TextEditingController(); // Créez un TextEditingController

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller, // Associez le contrôleur au TextField
            decoration: const InputDecoration(
              labelText: 'Nouveau To Do',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (newValue) {
              listen.add(ToDo(name: newValue));
              controller.clear(); // Effacez le texte après avoir ajouté le ToDo
            },
          ),
        ),


        Expanded(
            child: ListView.separated(
               itemBuilder: ((context, index) {
               final todo = listen.toDos[index]; // permet de lire le provider


            return ListTile(
              title: Text(todo.name),
              leading: IconButton(
                onPressed: (() => listen.update(todo)),
                icon: Icon(
                  todo.icon,
                  color: todo.color,
                ),
              ),
              trailing: IconButton(
                onPressed: (() => listen.remove(todo)),
                icon: const Icon(Icons.delete, color: Colors.orange),
              ),
            );
          }),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: listen.toDos.length,
        )),
      ],
    );
  }
}

//3. ChangeNotifier
class TodoNotifier extends ChangeNotifier {
  List<ToDo> toDos;
  TodoNotifier({required this.toDos});

  add(ToDo toDo) {
    toDos.add(toDo);
    notifyListeners();
  }

  remove(ToDo toDo) {
    toDos.remove(toDo);
    notifyListeners();
  }

  update(ToDo toDo) {
    ToDo toBeChanged = toDos.firstWhere((t) => t == toDo);
    toBeChanged.isDone = !toBeChanged.isDone;
    notifyListeners();
  }
}

class CounterNotifier extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }

  void reset() {
    count = 0;
    notifyListeners();
  }
}

//4. Autres
class ToDo {
  String name;
  bool isDone;

  IconData get icon => isDone ? Icons.check_box : Icons.check_box_outline_blank;
  Color get color => isDone ? Colors.green : Colors.red;

  ToDo({
    required this.name,
    this.isDone = false,
  });
}
