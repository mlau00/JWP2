import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter_front/core/models/user_model.dart';
import 'package:todo_flutter_front/core/providers/user_provider.dart';
import 'package:todo_flutter_front/core/utils.dart';
import 'package:todo_flutter_front/gui/widgets/my_circular_progress_indicator.dart';
import 'package:todo_flutter_front/gui/widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double width = 0;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<UserProvider>().isLoading;
    bool errorWhileLogin = context.watch<UserProvider>().errorWhileLogin;
    width = MediaQuery.of(context).size.width;
    return isLoading
        ? MyCircularProgressIndicator()
        : Scaffold(
            backgroundColor: MyUtils.bgColor,
            body: SafeArea(
                minimum: EdgeInsets.only(top: MyUtils.defaultPadding),
                child: Center(
                  child: SizedBox(
                    width: width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextFormFeild(
                          textEditingController: loginController,
                          labelText: 'Login',
                        ),
                        SizedBox(
                          height: MyUtils.defaultPadding,
                        ),
                        MyTextFormFeild(
                            textEditingController: passwordController,
                            labelText: 'Hasło'),
                        SizedBox(
                          height: MyUtils.defaultPadding,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool success = await _authUser(
                                      loginController.text,
                                      passwordController.text,
                                      context);
                                  loginController.clear();
                                  passwordController.clear();

                                  if (success) {
                                    Navigator.pushReplacementNamed(
                                        context, '/mainScreen');
                                  }
                                },
                                child: Text('Zaloguj'),
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    backgroundColor: MyUtils.secondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7))))),
                        if (errorWhileLogin) _errorWidget()
                      ],
                    ),
                  ),
                )));
  }

  _errorWidget() {
    return Text(
      'Błąd przy logowaniu',
      style: TextStyle(color: Colors.red),
    );
  }
}

Future<bool> _authUser(
    String login, String password, BuildContext context) async {
  log(login);
  log(password);
  final success = context.read<UserProvider>().authUser(login, password);

  return success;
}
