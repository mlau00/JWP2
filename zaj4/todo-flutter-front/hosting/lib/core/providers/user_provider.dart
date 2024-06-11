import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:todo_flutter_front/core/models/user_model.dart';
import 'package:todo_flutter_front/services/api_call.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _errorWhileLogin = false;
  bool get errorWhileLogin => _errorWhileLogin;

  Future<bool> authUser(String login, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    final response = await ApiCall().loginUser(login, password);
    _isLoading = false;

    log(response.toString());

    if (response is UserModel) {
      log('Response is user model');
      _errorWhileLogin = false;
      notifyListeners();
      return true;
    } else {
      log('Response is NOT user model');
    }
    _errorWhileLogin = true;
    notifyListeners();
    return false;
  }
}
