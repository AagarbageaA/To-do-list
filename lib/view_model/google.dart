import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_application_template/repo/user_repo.dart';

/// 管理使用者帳號資訊、預設值，以及登入、登出行為
class GoogleViewModel with ChangeNotifier {
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
  User? _user;
  User? get user => _user;

  GoogleViewModel() {
    // 設定會使用到的 Google API scopes
    // 可參考 https://developers.google.com/identity/protocols/oauth2/scopes?hl=zh-tw
    _googleAuthProvider
        .addScope("https://www.googleapis.com/auth/calendar.events");

    // 註冊監聽器，當登入狀態改變時進行一些操作，包括 notifyListeners，
    // 重新整理頁面時也能保留登入狀態
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        _user = firebaseUser;
        await UserRepo.create(_user!.uid);
      }
      notifyListeners();
    });
  }

  /// 彈出視窗以 Google 帳號登入，回傳是否成功登入
  Future<bool> signInWithGoogle() async {
    try {
      // 以彈出式視窗登入
      await FirebaseAuth.instance.signInWithPopup(_googleAuthProvider);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
    notifyListeners();
    return true;
  }

  /// 登出帳號，回傳是否成功登出
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
    notifyListeners();
    return true;
  }
}
