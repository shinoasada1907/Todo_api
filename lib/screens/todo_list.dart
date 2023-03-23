// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_page.dart';
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/widgets/todo_card.dart';

import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'Not Todo Item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateEdit: navigateToEditTodo,
                    deleteById: deleteById);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddTodo, label: const Text('Add')),
    );
  }

  Future<void> navigateToEditTodo(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddTodo() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final success = await TodoService.deleteById(id);

    if (success) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showFailedMessage(context, message: 'Delete Fail');
    }
  }

  Future<void> fetchTodo() async {
    final reponse = await TodoService.fetchTodo();
    if (reponse != null) {
      setState(() {
        items = reponse;
      });
    } else {
      showFailedMessage(context, message: 'Something went Wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
