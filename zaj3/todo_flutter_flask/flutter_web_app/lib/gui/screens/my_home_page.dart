import 'dart:developer';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/models/task_model.dart';
import 'package:flutter_web_app/core/providers/tasks_provider.dart';
import 'package:flutter_web_app/core/utils.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

double width = 0;

class _MyHomePageState extends State<MyHomePage> {
  // List<TaskModel> listTaskModels = [];
  bool isTextFieldError = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    width = MediaQuery.of(context).size.width;
    List<TaskModel> listTaskModels =
        context.watch<TaskProvider>().listTaskModels;

    return Scaffold(
      backgroundColor: MyUtils.bgColor,
      body: Center(
        child: SizedBox(
          width: width / 3,
          child: Column(
            children: [
              const Text(
                'TODO list',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 50,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              if (textEditingController.text.isEmpty) {
                                setState(() {
                                  isTextFieldError = true;
                                });
                              } else {
                                setState(() {
                                  isTextFieldError = false;
                                });
                              }
                            },
                            cursorColor: MyUtils.primaryColor,
                            textAlignVertical: TextAlignVertical.center,
                            controller: textEditingController,
                            decoration: InputDecoration(
                                suffixIcon: isTextFieldError
                                    ? const Tooltip(
                                        message: 'Input is empty',
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      )
                                    : null,
                                prefixIcon: const Icon(Icons.list),
                                labelStyle:
                                    TextStyle(color: MyUtils.primaryColor),
                                labelText: 'Enter a task name',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isTextFieldError
                                            ? Colors.red
                                            : MyUtils.primaryColor),
                                    borderRadius: BorderRadius.circular(7)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isTextFieldError
                                            ? Colors.red
                                            : MyUtils.primaryColor),
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                        ),
                        SizedBox(
                          width: MyUtils.defaultPadding,
                        ),
                        SizedBox(
                            height: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (textEditingController.text.isEmpty) {
                                  setState(() {
                                    isTextFieldError = true;
                                  });
                                } else {
                                  context
                                      .read<TaskProvider>()
                                      .addTask(textEditingController.text);
                                  textEditingController.clear();
                                  setState(
                                    () {
                                      isTextFieldError = false;
                                    },
                                  );
                                }
                              },
                              style: const ButtonStyle().copyWith(
                                  backgroundColor: MaterialStatePropertyAll(
                                      MyUtils.secondaryColor),
                                  shadowColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  overlayColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)))),
                              child: const Text(
                                'Add a task',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: MyUtils.defaultPadding,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: MyUtils.defaultPadding,
                    );
                  },
                  itemBuilder: (context, index) {
                    return _getToDoBarWidget(listTaskModels[index], context);
                  },
                  itemCount: listTaskModels.length,
                ),
              ),

              // TextButton(
              //     onPressed: () {
              //       context.read<TaskProvider>().fetchTasks();
              //     },
              //     child: Text("Click me"))
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getToDoBarWidget(TaskModel taskModel, BuildContext context) {
  log(width.toString());
  return Container(
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7), color: MyUtils.primaryColor),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            taskModel.name,
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              _getToDoButton('Edit', () {
                _showDialog(context, taskModel);
              }),
              _getToDoButton('Delete', () {
                context.read<TaskProvider>().deleteTask(taskModel.id);
              })
            ],
          )
        ],
      ),
    ),
  );
}

void _showDialog(BuildContext context, TaskModel taskModel) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController textEditingController = TextEditingController();
      return AlertDialog(
        title: Text('${taskModel.name}'),
        content: Container(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: textEditingController,
                  cursorColor: MyUtils.primaryColor,
                  decoration: InputDecoration(),
                ),
                SizedBox(
                  height: MyUtils.defaultPadding,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!textEditingController.text.isEmpty) {
                      TaskModel updatedTaskModel = TaskModel(
                          id: taskModel.id, name: textEditingController.text);
                      context.read<TaskProvider>().updateTask(updatedTaskModel);
                      Navigator.pop(context);
                    }
                  },
                  style: const ButtonStyle().copyWith(
                      backgroundColor:
                          MaterialStatePropertyAll(MyUtils.secondaryColor),
                      shadowColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)))),
                  child: const Text(
                    'Change name',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )),
      );
    },
  );
}

Widget _getToDoButton(String text, Function function) {
  return TextButton(
    onPressed: () {
      function.call();
    },
    child: Text(text),
    style: ButtonStyle().copyWith(
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        overlayColor: MaterialStatePropertyAll(Colors.transparent)),
  );
}
