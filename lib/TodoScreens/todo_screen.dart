import 'package:flutodo/Providers/todo_provider.dart';
import 'package:flutodo/Widgets/filter_todo.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/todo_item.dart';

class TodoScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TodoFilters(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new todo...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _addTodo(ref, value),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTodo(ref, _controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // Todo list
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Text(
                      'No todos yet!\nAdd one above to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoItem(todo: todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addTodo(WidgetRef ref, String title) {
    if (title.trim().isNotEmpty) {
      ref.read(todoListProvider.notifier).addTodo(title);
      _controller.clear();
    }
  }
}
