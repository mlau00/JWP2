import 'package:flutter/material.dart';
import 'package:todo_flutter_front/core/utils.dart';

class MyTextFormFeild extends StatefulWidget {
  const MyTextFormFeild(
      {required this.textEditingController,
      required this.labelText,
      super.key});
  final String labelText;
  final TextEditingController textEditingController;

  @override
  State<MyTextFormFeild> createState() => _MyTextFormFeildState();
}

class _MyTextFormFeildState extends State<MyTextFormFeild> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        expands: true,
        maxLines: null,
        controller: widget.textEditingController,
        decoration: InputDecoration(
            isDense: true,
            // contentPadding: EdgeInsets.symmetric(vertical: 30),
            labelStyle: TextStyle(color: MyUtils.primaryColor),
            labelText: widget.labelText,
            focusedBorder: _getOutlineInputBorder(),
            enabledBorder: _getOutlineInputBorder()),
        cursorColor: MyUtils.primaryColor,
      ),
    );
  }
}

_getOutlineInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: MyUtils.primaryColor),
      borderRadius: BorderRadius.circular(7));
}
