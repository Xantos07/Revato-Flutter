import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../controller/task_controller.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    try {
      await createTask(title);
      await fetchTasks();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
