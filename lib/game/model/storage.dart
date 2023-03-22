import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:platformer/game/model/user.dart';
import 'package:platformer/game/model/user_score.dart';


class UsersStorage<T> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localUsersFile async {
    final path = await _localPath;
    return File("$path/users.json");
  }

  Future<List<User>> readUsers() async {
    final file = await _localUsersFile;
    String content;
    try {
      content = await file.readAsString();
    }
    catch (error) {
      return [];
    }
    var users = jsonDecode(content) as List;
    List<User> usersList = users.map((user) => User.fromJson(user)).toList();
    return usersList;
  }

  Future<File> writeUsers(List<User> users) async {
    final file = await _localUsersFile;
    String jsonUsers = jsonEncode(users);
    return file.writeAsString(jsonUsers);
  }

  Future<File> get _localUserScoreFile async {
    final path = await _localPath;
    return File("$path/score.json");
  }

  Future<List<UserScore>> readScore() async {
    final file = await _localUserScoreFile;
    String content;
    try {
      content = await file.readAsString();
    }
    catch (error) {
      return [];
    }
    var scores = jsonDecode(content) as List;
    List<UserScore> scoreList = scores.map((score) => UserScore.fromJson(score)).toList();
    return scoreList;
  }

  Future<File> writeScores(List<UserScore> scores) async {
    final file = await _localUserScoreFile;
    String jsonScores = jsonEncode(scores);
    return file.writeAsString(jsonScores);
  }
}