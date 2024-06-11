import 'dart:developer';

class TaskModel {
  final int id;
  final String name;

  const TaskModel({required this.id, required this.name});

  static List<TaskModel> getListTaskModels(List<dynamic> jsonList) {
    List<TaskModel> taskModelList = [];
    for (Map<String, dynamic> json in jsonList) {
      log(json.toString());
      TaskModel taskModel = TaskModel.fromJson(json);
      taskModelList.add(taskModel);
    }

    return taskModelList;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String name = json['name'].toString();

    TaskModel taskModel = TaskModel(id: id, name: name);

    return taskModel;
  }
}
