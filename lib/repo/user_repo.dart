import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_template/model/user.dart';

class UserRepo {
  static final _db = FirebaseFirestore.instance.collection("users");

  /// 取得 Firebase 中對應 id 的 [Wallet] 物件。
  /// 其中，[id] 應為 user id。
  static Future<User?> read(String uid) async {
    try {
      final doc = await _db.doc(uid).get();
      final data = doc.data();
      if (data == null) return null;
      return User.fromJson(data);
    } on Exception {
      return null;
    }
  }

  /// 為第一次登入的使用者初始化 Firebase 的 [Wallet]。
  /// 其中，[id] 應為 user id。
  static Future<User?> create(String id) async {
    if ((await _db.doc(id).get()).exists) return null;
    final data = User(
  uid: id,
  todoList: [],
  folders: ["Folder 1"],
);

    try {
      await _db.doc(id).set(data.toJson());
      return data;
    } on Exception {
      return null;
    }
  }

  /// 複寫 Firebase 中對應 id 的 [Wallet] 物件。
  /// 其中，[data] 的 id 應為 user id。
  static Future<void> update(User data) async {
    await _db.doc(data.uid).set(data.toJson());
  }
}
