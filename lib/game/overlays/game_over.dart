import 'package:flutter/material.dart';
import 'package:platformer/game/game.dart';
import 'package:platformer/game/model/storage.dart';
import 'package:platformer/game/model/user_score.dart';

import '../game_play.dart';
import 'main_menu.dart';


class GameOver extends StatefulWidget {
  static const id = 'GameOver';
  final SimplePlatformer gameRef;
  final UsersStorage storage;

  const GameOver({super.key, required this.gameRef, required this.storage});

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  late List<UserScore> scores;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      loadScores();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withAlpha(100),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  String username = widget.gameRef.playerData.userName;
                  writeScore(username, widget.gameRef.playerData.score.value);
                  widget.gameRef.overlays.remove(GameOver.id);
                  widget.gameRef.resumeEngine();
                  widget.gameRef.removeAll(widget.gameRef.children);
                  widget.gameRef.add(GamePlay(username: username));
                },
                child: const Text('Restart'),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  String username = widget.gameRef.playerData.userName;
                  writeScore(username, widget.gameRef.playerData.score.value);
                  widget.gameRef.overlays.remove(GameOver.id);
                  widget.gameRef.resumeEngine();
                  widget.gameRef.removeAll(widget.gameRef.children);
                  widget.gameRef.overlays.add(MainMenu.id);
                },
                child: const Text('Exit'),
              ), 
            )
          ],
        )
      )
    );
  }

  Future loadScores() async {
    scores = await widget.storage.readScore();
  }

  void writeScore(String username, int score) {
    scores.add(UserScore(username: username, score: score));
    widget.storage.writeScores(scores);
  }
}