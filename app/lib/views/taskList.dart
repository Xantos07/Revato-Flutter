import 'package:flutter/material.dart';
import '../models/task.dart';
import '../../controller/task_controller.dart';
import 'task_create_bar.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes tâches')),
      body: Column(
        children: [
          TaskCreateBar(
            onTaskCreated: () {
              setState(() {
                futureTasks = getTasks();
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune tâche trouvée'));
                }

                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      trailing: Icon(
                        task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task.done ? Colors.green : Colors.grey,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
