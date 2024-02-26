import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_template/model/user.dart';

class UserRepo {
  static final _db = FirebaseFirestore.instance.collection("users");

  /// 取得 Firebase 中對應 id 的 [users] 物件。
  /// 其中，[uid] 應為 user id。
  static Future<User?> read(String uid) async {
    try {
      final doc = await _db.doc(uid).get();
      final data = doc.data();
      if (data == null) return null;

      // fetch todoList
      List<dynamic>? todoListData = data['todoList'];
      List<TodoItem> todoList = [];

      if (todoListData != null) {
        todoList = todoListData.map((item) => TodoItem.fromJson(item)).toList();
      }

      // fetch folders
      List<dynamic>? foldersData = data['folders'];
      List<String> folders = [];
      if (foldersData != null) {
        folders = foldersData.cast<String>();
      }

      // create User
      return User(
        uid: data['uid'],
        todoList: todoList,
        folders: folders,
      );
    } catch (e) {
      return null;
    }
  }

  /// initial [users] when first log in。
  static Future<User?> create(String uid) async {
    if ((await _db.doc(uid).get()).exists) return null;
    final data = User(
      uid: uid,
      todoList: [
        TodoItem(
          name: "First success",
          date: "2024-02-14",
          place: "Home",
          note: "It's 6:51 a.m. right now",
          folder: "Folder 1",
          ischecked: true,
        ),
      ],
      folders: ["Folder 1"],
    );

    try {
      await _db.doc(uid).set(data.toJson());
      return data;
    } on Exception {
      return null;
    }
  }

  static Future<void> update(User data) async {
    await _db.doc(data.uid).set(data.toJson());
  }
}
