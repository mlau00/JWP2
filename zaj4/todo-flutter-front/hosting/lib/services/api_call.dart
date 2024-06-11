import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:todo_flutter_front/core/models/task_model.dart';
import 'package:todo_flutter_front/core/models/user_model.dart';
import 'package:todo_flutter_front/services/api_path.dart';

class ApiCall {
  Future<List<TaskModel>> fetchAllTasks() async {
    String url = ApiPath.baseUrl + ApiPath.baseTasksEndpoint;

    try {
      final response = await http.get(Uri.parse(url));
      final responseBodyFromJson = jsonDecode(response.body)['body'];

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
    String url =
        ApiPath.baseUrl + ApiPath.baseTasksEndpoint + ApiPath.deleteTask;
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
    String url = ApiPath.baseUrl + ApiPath.baseTasksEndpoint + ApiPath.addTask;
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
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  Future<bool> updateTask(TaskModel taskModel) async {
    String url =
        ApiPath.baseUrl + ApiPath.baseTasksEndpoint + ApiPath.updateTask;
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

  Future<UserModel?> loginUser(String login, String password) async {
    String url =
        ApiPath.baseUrl + ApiPath.baseLoginEndpoint + ApiPath.loginUser;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> body = {"login": login, "password": password};

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['body'];
        UserModel user = UserModel.fronJson(data);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
