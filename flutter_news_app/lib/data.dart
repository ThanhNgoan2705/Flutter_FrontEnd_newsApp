import 'dart:convert';

import 'package:flutter_news_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  AppData._();
  static final instance = AppData._();

  User? user;

  Future<void> setUser(User user) async {
    this.user = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void>removeUser() async {
    user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      user = User.fromJson(jsonDecode(userJson));
    }
  }
}
