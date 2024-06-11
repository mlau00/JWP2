import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_flutter_front/core/models/task_model.dart';
import 'package:todo_flutter_front/services/api_call.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _listTaskModels = [];
  List<TaskModel> get listTaskModels => _listTaskModels;

  // bool _isTaskDeleted = false;
  // bool get isTaskDeleted => _isTaskDeleted;

  Future<void> fetchTasks() async {
    try {
      final response = await ApiCall().fetchAllTasks();
      log(response.toString());
      _listTaskModels = response;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await ApiCall().deleteTask(id);
      if (response) {
        // _listTaskModels.removeWhere((task) => task.id == id);
        // notifyListeners();
        fetchTasks();
      }
    } catch (e) {}
  }

  Future<void> addTask(String name) async {
    try {
      final response = await ApiCall().addTask(name);
      if (response) {
        // _listTaskModels.add
        // notifyListeners();
        fetchTasks();
      }
    } catch (e) {}
  }

  Future<void> updateTask(TaskModel taskModel) async {
    try {
      final response = await ApiCall().updateTask(taskModel);

      if (response) {
        fetchTasks();
      }
    } catch (e) {}
  }
}
