import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';
import 'package:flutter_application_template/repo/user_repo.dart';
import 'package:flutter_application_template/view_model/google.dart';
import 'package:provider/provider.dart';

class DataViewModel extends ChangeNotifier {
  List<TodoItem> todoItemList = [];
  List<String> folderList = [];
  String selectedFolder = 'All';
  bool visible = false;

  void addFolder(String newFolderName, BuildContext context) {
    if (!folderList.contains(newFolderName)) {
      folderList.add(newFolderName);
      notifyListeners();
      upload(context);
    }
  }

  void renameFolder(
      String folderName, String newFolderName, BuildContext context) {
    int index = folderList.indexOf(folderName); // find current folder's index
    folderList[index] = newFolderName;
    notifyListeners();
    upload(context);
  }

  void deleteFolder(String folderName, BuildContext context) {
    folderList.remove(folderName);
    notifyListeners();
    upload(context);
  }

  void selectFolder(String folderName) {
    selectedFolder = folderName;
    notifyListeners();
  }

  void addTodoItem(TodoItem item, BuildContext context) {
    todoItemList.add(item);
    todoItemList.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
    upload(context);
  }

  void deleteTodoItem(int index, BuildContext context) {
    todoItemList.removeAt(index);
    notifyListeners();
    upload(context);
  }

  void changeCheckState(int index, BuildContext context) {
    todoItemList[index].ischecked = !todoItemList[index].ischecked;
    notifyListeners();
    upload(context);
  }

  void changeVisibleState(BuildContext context) {
    visible = !visible;
    notifyListeners();
    upload(context);
  }

  void editTodoItem(int index, TodoItem newitem, BuildContext context) {
    todoItemList[index] = newitem;
    todoItemList.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
    upload(context);
  }

  void loadData(BuildContext context) async {
    final user = await UserRepo.read(context.read<GoogleViewModel>().user!.uid);
    folderList = user!.folders;
    todoItemList = user.todoList.map((todoItem) {
      return TodoItem(
          name: todoItem.name,
          date: todoItem.date,
          place: todoItem.place,
          note: todoItem.note,
          folder: todoItem.folder,
          ischecked: todoItem.ischecked);
    }).toList();
    notifyListeners();
  }

  void upload(BuildContext context) {
    final user = User(
      uid: context.read<GoogleViewModel>().user!.uid,
      todoList: todoItemList,
      folders: folderList,
    );
    UserRepo.update(user);
  }
}
