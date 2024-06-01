import 'dart:convert';
import 'dart:developer';

import 'package:flutter_web_app/core/models/task_model.dart';
import 'package:flutter_web_app/services/api_path.dart';
import 'package:http/http.dart' as http;

class ApiCall {
  Future<List<TaskModel>> fetchAllTasks() async {
    String url = ApiPath.baseUrl + ApiPath.showAllTasksEndpoint;

    try {
      final response = await http.get(Uri.parse(url));
      final responseBodyFromJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<TaskModel> taskModelList =
            TaskModel.getListTaskModels(responseBodyFromJson);

        return taskModelList;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      log(e.toString());
    }

    throw Exception("Wrong!");
  }

  Future<bool> deleteTask(int id) async {
    String url = ApiPath.baseUrl + ApiPath.deleteTask;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {'id': id};
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {}

    return false;
  }

  Future<bool> addTask(String name) async {
    String url = ApiPath.baseUrl + ApiPath.addTask;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {'name': name};
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {}

    return false;
  }

  Future<bool> updateTask(TaskModel taskModel) async {
    String url = ApiPath.baseUrl + ApiPath.updateTask;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {'id': taskModel.id, 'name': taskModel.name};
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {}

    return false;
  }
}
