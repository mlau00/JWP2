import 'package:flutter/material.dart';
import 'package:todo_flutter_front/core/utils.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyUtils.bgColor,
      body: Center(
        child: CircularProgressIndicator(
          color: MyUtils.primaryColor,
        ),
      ),
    );
  }
}
