import 'package:flutter/material.dart';
import 'package:flutter_application_template/model/user.dart';

class HomePageViewModel extends ChangeNotifier {
  List<TodoItem> todoItemList = [];
  List<String> folderList = [];
  String selectedFolder = 'All';

  void addFolder(String newFolderName) {
    folderList.add(newFolderName);
    notifyListeners();
  }

  void renameFolder(String folderName, String newFolderName) {
    int index = folderList.indexOf(folderName); // find current folder's index
    folderList[index] = newFolderName;
    notifyListeners();
  }

  void deleteFolder(String folderName) {
    folderList.remove(folderName);
    notifyListeners();
  }

  void selectFolder(String folderName) {
    selectedFolder = folderName;
    notifyListeners();
  }

  void addTodoItem(TodoItem item) {
    todoItemList.add(item);
    todoItemList.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  void deleteTodoItem(int index) {
    todoItemList.removeAt(index);
    notifyListeners();
  }

  void loadData(User user) {
    folderList = user.folders;
    todoItemList = user.todoList.map((todoItem) {
      return TodoItem(
        name: todoItem.name,
        date: todoItem.date,
        place: todoItem.place,
        note: todoItem.note,
        folder: todoItem.folder,
      );
    }).toList();
    notifyListeners();
  }
}