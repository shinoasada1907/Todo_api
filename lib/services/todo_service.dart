// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final reponse = await http.delete(uri);
    return reponse.statusCode == 200;
  }

  static Future<bool> updateData(String id, Map body) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final reponse = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    print('status: ${reponse.statusCode}');
    return reponse.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final reponse = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return reponse.statusCode == 201;
  }

  static Future<List?> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final reponse = await http.get(uri);
    if (reponse.statusCode == 200) {
      final json = jsonDecode(reponse.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }
}
