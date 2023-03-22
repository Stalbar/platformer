import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:platformer/game/model/user.dart';


class UsersStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/users.json");
  }

  Future<List<User>> readUsers() async {
    final file = await _localFile;
    final content = await file.readAsString();
    var users = jsonDecode(content) as List;
    List<User> usersList = users.map((user) => User.fromJson(user)).toList();
    return usersList;
  }

  Future<File> writeUsers(List<User> users) async {
    final file = await _localFile;
    String jsonUsers = jsonEncode(users);
    return file.writeAsString(jsonUsers);
  }
}