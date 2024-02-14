import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/repo/user_repo.dart';
import 'package:flutter_application_template/view_model/google.dart';

class UserViewModel with ChangeNotifier {
  String? _uid;
  List<TodoItem>? _todoList;
  List<String>? _folders;

  UserViewModel(GoogleViewModel vm) {
    _uid = vm.user?.uid;
    if (_uid != null) {
      UserRepo.read(_uid!).then((value) {
        if (value != null) {
          _todoList = value.todoList;
          _folders = value.folders;
          notifyListeners();
        }
      });
    }
  }

  List<TodoItem>? get todoList => _todoList;
  List<String>? get folders => _folders;
}
