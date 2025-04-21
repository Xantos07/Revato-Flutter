import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import '../models/task.dart';

// GET: récupérer toutes les tâches
Future<List<Task>> getTasks() async {
  final response = await http.get(Uri.parse('$API_BASE_URL/api/tasks'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  } else {
    throw Exception('Erreur: ${response.statusCode}');
  }
}

Future<void> createTask(String title) async {
  final url = Uri.parse('$API_BASE_URL/api/tasks');
  final body = jsonEncode({'title': title, 'done': false});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  
  if (response.statusCode != 201) {
    throw Exception('Erreur lors de la création: ${response.statusCode}');
  }
}
