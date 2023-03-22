import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:platformer/game/game.dart';
import 'package:platformer/game/model/user_score.dart';

import '../model/storage.dart';

class Leaderboard extends StatefulWidget {
  static const id = 'Leaderboard';
  final UsersStorage storage;
  final SimplePlatformer gameRef;
  const Leaderboard({super.key, required this.storage, required this.gameRef});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late List<UserScore> score;

  @override
  void initState() {
    score = [];
    widget.storage.readScore().then((value) => {
      setState(() {
        score = value;
      })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: score.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
                  child: ListTile(
                    title: Text(
                      score[index].username,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      score[index].score.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      )
                    ),
                  ),
                );
              }
            )
          ),
          ElevatedButton(
            onPressed: () {
              widget.gameRef.overlays.remove(Leaderboard.id);
            }, 
            child: Text(
              'Back', 
            ),
          ),
        ],
      )
    );
  }
}