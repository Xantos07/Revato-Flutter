import 'package:flutter/material.dart';
import '../controller/task_controller.dart';

class TaskCreateBar extends StatefulWidget {
  final VoidCallback onTaskCreated;

  const TaskCreateBar({required this.onTaskCreated, super.key});

  @override
  State<TaskCreateBar> createState() => _TaskCreateBarState();
}

class _TaskCreateBarState extends State<TaskCreateBar> {
  final TextEditingController _controller = TextEditingController();

  void _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    try {
      await createTask(title);
      _controller.clear();
      widget.onTaskCreated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nouvelle tâche',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
