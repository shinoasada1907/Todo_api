// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({this.todo, super.key});
  Map? todo;
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('you can not updated to do without data');
      return;
    }
    final id = todo['_id'];
    //Update data to the server
    final isSuccess = await TodoService.updateData(id, body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Update success');
    } else {
      showFailedMessage(context, message: 'Update failed');
    }
  }

  Future<void> submitData() async {
    //Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Creation success');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showFailedMessage(context, message: 'Creation failed');
    }
  }

  Map get body {
    //Get data todo from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
